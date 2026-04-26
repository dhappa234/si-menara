import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/services.dart';
import '../services/mailer_send_service.dart';

class PermintaanDataScreen extends StatefulWidget {
  const PermintaanDataScreen({super.key});

  @override
  State<PermintaanDataScreen> createState() => _PermintaanDataScreenState();
}

class _PermintaanDataScreenState extends State<PermintaanDataScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nama = TextEditingController();
  final _email = TextEditingController();
  final _instansi = TextEditingController();
  final _jenisData = TextEditingController();
  final _keperluan = TextEditingController();

  File? _file;
  String? _fileName;

  bool _loading = false;

  // ================= PICK FILE (PDF + IMAGE) =================
  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
    );

    if (result == null) return;

    final pickedFile = result.files.single;

    // Limit 10MB
    final sizeInMB = pickedFile.size / (1024 * 1024);

    if (sizeInMB > 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("File maksimal 10MB")),
      );
      return;
    }

    setState(() {
      _file = File(pickedFile.path!);
      _fileName = pickedFile.name;
    });
  }

  // ================= SUBMIT =================
  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (_file == null) {
      HapticFeedback.vibrate();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Upload dokumen pendukung dulu")),
      );
      return;
    }

    setState(() => _loading = true);

    try {
      final fileBytes = await _file!.readAsBytes();

      final fileName =
          "${DateTime.now().millisecondsSinceEpoch}_$_fileName";

      // 1. Upload ke Supabase Storage
      await Supabase.instance.client.storage.from('permintaan').uploadBinary(
        fileName,
        fileBytes,
        fileOptions: const FileOptions(upsert: true),
      );

      // 2. Ambil URL publik
      final fileUrl = Supabase.instance.client.storage
          .from('permintaan')
          .getPublicUrl(fileName);

      final tanggal =
      DateTime.now().toIso8601String().substring(0, 10); // yyyy-mm-dd

      // 3. Simpan ke Database
      await Supabase.instance.client.from('permintaan_data').insert({
        "nama": _nama.text.trim(),
        "email": _email.text.trim(),
        "instansi": _instansi.text.trim(),
        "jenis_data": _jenisData.text.trim(),
        "keperluan": _keperluan.text.trim(),
        "file_url": fileUrl,
        "status": "Diproses",
        "created_at": DateTime.now().toIso8601String(),
      });

      // 4. Kirim Email Admin
      await EmailService.kirimEmailAdmin(
        nama: _nama.text.trim(),
        emailPemohon: _email.text.trim(),
        instansi: _instansi.text.trim(),
        jenisData: _jenisData.text.trim(),
        keperluan: _keperluan.text.trim(),
        tanggal: tanggal,
        fileUrl: fileUrl,
      );

      _clearForm();
      _showSuccessDialog();
    } catch (e) {
      debugPrint("Error: $e");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal dikirim: $e")),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  // ================= CLEAR =================
  void _clearForm() {
    _nama.clear();
    _email.clear();
    _instansi.clear();
    _jenisData.clear();
    _keperluan.clear();

    setState(() {
      _file = null;
      _fileName = null;
    });
  }

  // ================= SUCCESS DIALOG =================
  void _showSuccessDialog() {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: "Success",
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, anim1, anim2) => const SizedBox(),
      transitionBuilder: (context, anim1, anim2, child) {
        return Transform.scale(
          scale: anim1.value,
          child: Opacity(
            opacity: anim1.value,
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              content: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle_rounded,
                      color: Colors.green, size: 80),
                  SizedBox(height: 20),
                  Text(
                    "Berhasil! ✅",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 12),
                  Text(
                    "Permintaan data berhasil dikirim. Kami akan mengirimkan data ke email Anda.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    Future.delayed(const Duration(seconds: 10), () {
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
    });
  }

  // ================= INPUT =================
  Widget _buildInput(String label, TextEditingController c,
      {int max = 1, String? hint, String? Function(String?)? validator}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: Colors.black87)),
        const SizedBox(height: 8),
        TextFormField(
          controller: c,
          maxLines: max,
          validator:
          validator ?? (v) => v == null || v.isEmpty ? "Wajib diisi" : null,
          style: const TextStyle(fontSize: 14),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
            filled: true,
            fillColor: const Color(0xFFF8F9FA),
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFF39C12)),
            ),
          ),
        ),
      ],
    );
  }

  // ================= UPLOAD UI =================
  Widget _buildUploadArea() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Dokumen Pendukung",
            style:
            GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 14)),
        const SizedBox(height: 8),
        InkWell(
          onTap: _pickFile,
          child: DottedBorder(
            color: const Color(0xFFD1E3F8),
            strokeWidth: 2,
            dashPattern: const [6, 3],
            borderType: BorderType.RRect,
            radius: const Radius.circular(12),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 24),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FA),
                borderRadius: BorderRadius.circular(12),
              ),
              child: _file == null
                  ? Column(
                children: [
                  Icon(Icons.cloud_upload_outlined,
                      size: 40, color: Colors.orange.shade300),
                  const SizedBox(height: 8),
                  const Text("Tap untuk unggah dokumen",
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  Text("Format PDF/JPG/PNG (Surat Permohonan)",
                      style: TextStyle(
                          fontSize: 12, color: Colors.grey.shade500)),
                  Text("Maksimal: 10MB",
                      style: TextStyle(
                          fontSize: 11, color: Colors.grey.shade400)),
                ],
              )
                  : Column(
                children: [
                  const Icon(Icons.check_circle,
                      color: Colors.green, size: 30),
                  const SizedBox(height: 8),
                  Text(_fileName ?? "",
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ================= DISPOSE =================
  @override
  void dispose() {
    _nama.dispose();
    _email.dispose();
    _instansi.dispose();
    _jenisData.dispose();
    _keperluan.dispose();
    super.dispose();
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text("Permintaan Data",
            style: GoogleFonts.poppins(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 18)),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildInput("Nama Pemohon", _nama,
                      hint: "Masukkan nama lengkap"),
                  const SizedBox(height: 16),
                  _buildInput("Email Pemohon", _email, hint: "Alamat email aktif"),
                  const SizedBox(height: 16),
                  _buildInput("Instansi", _instansi,
                      hint: "Universitas atau Kantor yang bersangkutan"),
                  const SizedBox(height: 16),
                  _buildInput("Jenis Data", _jenisData,
                      hint: "Contoh: Data Inflasi 2025"),
                  const SizedBox(height: 16),
                  _buildInput("Keperluan", _keperluan,
                      max: 4, hint: "Jelaskan alasan permintaan data..."),
                  const SizedBox(height: 20),
                  _buildUploadArea(),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: _loading ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF39C12),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: _loading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Kirim Permintaan",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.white)),
                          SizedBox(width: 10),
                          Icon(Icons.send_rounded,
                              size: 18, color: Colors.white),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_loading)
            Container(
              color: Colors.black38,
              child: const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/auth_wrapper.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  bool _obscurePassword = true;

  // ================= LOGIN =================
  Future<void> _signIn() async {

    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {

      final response =
      await Supabase.instance.client.auth.signInWithPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (response.user != null && mounted) {

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const AuthWrapper(),
          ),
        );
      }

    } on AuthException catch (_) {

      _showMsg("Email atau password salah");

    } catch (e) {

      _showMsg("Error: $e");

    } finally {

      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showMsg(String msg) {

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {

    const Color themeOrange = Color(0xFFFF9800);

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),

      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(

            padding: const EdgeInsets.symmetric(horizontal: 24),

            child: Form(
              key: _formKey,

              child: Column(
                children: [

                  Image.asset(
                    'assets/images/logo_bps.png',
                    height: 120,
                  ),

                  const SizedBox(height: 30),

                  const Text(
                    'Login Admin',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 40),

                  _buildInputLabel("Email"),

                  TextFormField(
                    controller: _emailController,

                    decoration: _inputDec(
                      "Email",
                      Icons.email,
                    ),

                    validator: (v) =>
                    v == null || v.isEmpty
                        ? "Wajib diisi"
                        : null,
                  ),

                  const SizedBox(height: 20),

                  _buildInputLabel("Password"),

                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,

                    decoration: _inputDec(
                      "Password",
                      Icons.lock,

                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),

                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),

                    validator: (v) =>
                    v == null || v.isEmpty
                        ? "Wajib diisi"
                        : null,
                  ),

                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    height: 50,

                    child: ElevatedButton(

                      onPressed:
                      _isLoading ? null : _signIn,

                      style: ElevatedButton.styleFrom(
                        backgroundColor: themeOrange,
                      ),

                      child: _isLoading
                          ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                          : const Text(
                        "LOGIN",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputLabel(String text) {

    return Align(
      alignment: Alignment.centerLeft,

      child: Padding(
        padding: const EdgeInsets.only(bottom: 6),

        child: Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDec(
      String hint,
      IconData icon, {
        Widget? suffixIcon,
      }) {

    return InputDecoration(

      hintText: hint,

      prefixIcon: Icon(icon),

      suffixIcon: suffixIcon,

      filled: true,

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }
}

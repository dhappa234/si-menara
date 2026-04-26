import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../screens/Login.dart';
import '../screens/ProfilePage.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}
class _AuthWrapperState extends State<AuthWrapper> {
  final _supabase = Supabase.instance.client;
  late final Stream<AuthState> _authStateChanges;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _authStateChanges = _supabase.auth.onAuthStateChange;
    _checkInitialAuthState();
  }
  Future<void> _checkInitialAuthState() async {
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    // Loading awal
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return StreamBuilder<AuthState>(
      stream: _authStateChanges,
      builder: (context, snapshot) {
        final session =
            Supabase.instance.client.auth.currentSession;
        // SUDAH LOGIN → PROFIL
        if (session != null) {
          return const ProfilePage();
        }
        // BELUM LOGIN → LOGIN PAGE
        return const LoginPage();
      },
    );
  }
}

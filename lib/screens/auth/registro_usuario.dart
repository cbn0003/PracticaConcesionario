import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../core/theme.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _passwordVisible = false;
  bool _isLoading = false;
  String? _errorMail;
  String? _errorPassword;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> registrarUsuario() async {
    setState(() {
      _errorMail = null;
      _errorPassword = null;
    });

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    final bool emailValid = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    ).hasMatch(email);

    if (email.isEmpty || !emailValid || password.isEmpty) {
      setState(() {
        if (email.isEmpty) {
          _errorMail = 'El correo no puede estar vacío';
        } else if (!emailValid) {
          _errorMail = 'El formato del correo no es válido';
        }
        if (password.isEmpty) {
          _errorPassword = 'La contraseña no puede estar vacía';
        }
      });
      return;
    }

    setState(() => _isLoading = true);

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            '¡Cuenta creada! Ya puedes iniciar sesión.',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: AppTheme.primary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).size.height - 130,
            left: 16,
            right: 16,
          ),
        ),
      );

      await FirebaseAuth.instance.signOut();
      if (mounted) Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      setState(() {
        if (e.code == 'email-already-in-use') {
          _errorMail = 'Este correo ya está registrado';
        } else if (e.code == 'invalid-email') {
          _errorMail = 'El formato del correo no es válido';
        } else if (e.code == 'weak-password') {
          _errorPassword = 'La contraseña debe tener al menos 6 caracteres';
        } else if (e.code == 'network-request-failed') {
          _errorMail = 'Sin conexión a internet';
        } else if (e.code == 'too-many-requests') {
          _errorMail = 'Demasiados intentos. Inténtalo más tarde';
        } else {
          _errorMail = 'Error: ${e.code}';
        }
      });
    } catch (e) {
      setState(() => _errorMail = 'Ocurrió un error inesperado');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 48),

              // Logo
              SizedBox(
                width: double.infinity,
                height: 180,
                child: Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      width: 150,
                      height: 150,
                      color: AppTheme.primary.withAlpha(20),
                      child: Image.asset(
                        'assets/icon/car.png',
                        width: 150,
                        height: 150,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              const Text(
                'Crear cuenta',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textDark,
                ),
              ),
              const Text(
                'Regístrate para empezar',
                style: TextStyle(
                  fontSize: 14,
                  color: AppTheme.textMuted,
                ),
              ),

              const SizedBox(height: 24),

              // Email
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'Correo electrónico',
                  errorText: _errorMail,
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                        color: Color(0xFF2563EB), width: 1.5),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Contraseña
              TextField(
                controller: _passwordController,
                obscureText: !_passwordVisible,
                decoration: InputDecoration(
                  hintText: 'Contraseña',
                  errorText: _errorPassword,
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                        color: Color(0xFF2563EB), width: 1.5),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _passwordVisible
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: AppTheme.textMuted,
                    ),
                    onPressed: () => setState(
                          () => _passwordVisible = !_passwordVisible,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Botón registrar
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : registrarUsuario,
                  child: _isLoading
                      ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                      : const Text('Registrarme'),
                ),
              ),

              const SizedBox(height: 20),

              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      '¿Ya tienes cuenta? ',
                      style: TextStyle(color: AppTheme.textMuted),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Text(
                        'Iniciar sesión',
                        style: TextStyle(
                          color: AppTheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'registro_usuario.dart'; // Importante para poder navegar al registro

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _passwordVisible = false;

  //Variables para guardar mensajes de error
  String? _errorPassword;
  String? _errorMail;



  Future<void> iniciarSesion() async {
    setState(() {
      _errorMail = null;
      _errorPassword = null;
    });
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: const Text(
              "¡Bienvenido/a!",
            textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 16),
        ),
          backgroundColor: Colors.blue,
          behavior: SnackBarBehavior.floating,//Para que se mueva
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).size.height - 200,//Se pone arriba
            left:20,
            right: 20,
          ),
          duration: const Duration(seconds: 2),
          ),
          
      );
    } on FirebaseAuthException catch (e) {
     setState(() {
       if (e.code == 'user-not-found'|| e.code == 'invalid-email') {
        _errorMail = 'El correo electrónico no es válido o no existe.';
      } else if (e.code == 'wrong-password') {
        _errorPassword = 'La contraseña es incorrecta.';
      } else if(e.code == 'invalid-credential') {
        _errorPassword = 'Credenciales no validas.';
        _errorMail = 'Credenciales no validas';
       }else{
         _errorMail: 'Error: ${e.message}';
       }
     });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Inicio de sesión"),
          centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            const Icon(Icons.lock_person, size: 80, color: Colors.blue),
            const SizedBox(height: 150),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: "Correo electrónico",
                errorText: _errorMail,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)
                ),
                prefixIcon: Icon(
                    Icons.email,
                  color: Colors.blue,
                ),
              ),
            ),

            const SizedBox(height: 15),
            TextField(
              controller: _passwordController,
              obscureText: !_passwordVisible,
              decoration: InputDecoration(
                labelText: "Contraseña",
                errorText: _errorPassword,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)
                ),
                  prefixIcon: Icon(
                      Icons.lock,
                      color: Colors.blue,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _passwordVisible ? Icons.visibility : Icons.visibility_off,
                      color: Colors.blue,
                    ),
                    onPressed: () {
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    },
                  )
              ),
            ),
            const SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: iniciarSesion,
                child: const Text("Entrar", style: TextStyle(fontSize: 18)),
              ),
            ),
            TextButton(
              onPressed: () {
                // Navegamos a la pantalla de registro
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RegisterScreen()),
                );
              },

              child: const Text("¿No tienes cuenta? Regístrate aquí"),
            ),
          ],
        ),
      ),
      )
    );
  }
}
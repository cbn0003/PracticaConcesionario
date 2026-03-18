import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Controladores para capturar el texto de los inputs
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _passwordVisible = false;

  //Variables para guardar mensajes de error
  String? _errorPassword;
  String? _errorMail;

  // Es importante limpiar los controladores cuando el widget se destruye
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Lógica para crear el usuario en Firebase
  Future<void> registrarUsuario() async {
    setState(() {
      _errorMail = null;
      _errorPassword = null;
    });
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    final bool emailValid = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"
    ).hasMatch(email);


    // Validar que los campos no estén vacíos antes de llamar a Firebase
    if (email.isEmpty || password.isEmpty || !emailValid) {
      setState(() {
        if (email.isEmpty) {
          _errorMail = 'El correo electrónico no puede estar vacío.';
        }else if(!emailValid){
          _errorMail = 'El formato del correo no es válido.';
        }
        if (password.isEmpty) {
          _errorPassword = 'La contraseña no puede estar vacía.';
        }
      });
      return;
    }

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (!mounted) return; // Verifica que el usuario no haya cerrado la pantalla

      // Mensaje de éxito
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("¡Cuenta creada! Ya puedes iniciar sesión.", textAlign: TextAlign.center),
          backgroundColor: Colors.blue,
          behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).size.height - 130, // Lo posiciona arriba
            left: 20,
            right: 20,
          ),
        ),
      );

      // REGRESO AL LOGIN: Esta línea cierra esta pantalla y vuelve a la anterior
      await FirebaseAuth.instance.signOut();
      Navigator.pop(context);

    } on FirebaseAuthException catch (e) {
      setState(() {
        if (e.code == 'email-already-in-use') {
          _errorMail = "Este correo ya está registrado";
        } else if (e.code == 'invalid-email') {
          _errorMail = "El formato del correo no es válido";
        } else if (e.code == 'weak-password') {
          _errorPassword = "La contraseña debe tener al menos 6 caracteres";
        } else if (e.code == 'network-request-failed') {
          _errorMail = "No hay conexión a internet";
        } else if (e.code == 'too-many-requests') {
          _errorMail = "Demasiados intentos. Inténtalo más tarde";
        } else {
          _errorMail = "Error: ${e.code}";
        }
      });
    } catch (e) {
      // Errores genéricos (como falta de internet)
      setState(() {
        _errorMail = "Ocurrió un error inesperado";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text("Crear cuenta"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView( // Evita errores de diseño si sale el teclado
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              const Icon(Icons.person_add, size: 80, color: Colors.blue),
              const SizedBox(height: 150),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: "Correo electrónico",
                  hintText: "ejemplo@correo.com",
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
                  onPressed: registrarUsuario,
                  child: const Text("Registrarme", style: TextStyle(fontSize: 18), selectionColor: Colors.blue),


                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
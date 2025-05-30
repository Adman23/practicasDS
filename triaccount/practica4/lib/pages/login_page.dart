import 'package:flutter/material.dart';
import '../services/triaccount_api_service.dart';
import 'register_page.dart';
import 'home_page.dart';
import '../models/user.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final TriAccountService apiService = TriAccountService();

  bool isLoading = false;
  String? errorMessage;

  late User loggedUser;

  // Constructor del estado: verifica si ya hay un usuario logueado
  _LoginPageState() {
    _checkLogin();
  }

  // Verifica si el usuario ya está logueado (sesión guardada) y redirige al Home
  _checkLogin() async {
    User? user = await apiService.checkLogin();
    if (user != null){
      loggedUser = user;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage(loggedUser: loggedUser)),
      );
    }
  }

  // Metodo que gestiona el proceso de login
  void _handleLogin() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      // Intenta iniciar sesión con las credenciales introducidas
      loggedUser = await apiService.login(
        emailController.text.trim(),
        passwordController.text,
      );

      // Si el login es exitoso, redirige al HomePage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage(loggedUser: loggedUser)),
      );
    } catch (e) {
      // Si hay un error, lo muestra en pantalla
      setState(() {
        errorMessage = e.toString();
      });
    } finally {
      // Desactiva el estado de carga al finalizar
      setState(() {
        isLoading = false;
      });
    }
  }

  // Construye la interfaz de usuario
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Iniciar Sesión',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 24),

            // Campo de texto para el email
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),

            // Campo de texto para la contraseña (oculta el texto)
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                labelText: 'Contraseña',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 24),

            // Muestra el mensaje de error si existe
            if (errorMessage != null)
              Text(
                errorMessage!,
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),

            // Botón de inicio de sesión
            ElevatedButton(
              onPressed: isLoading ? null : _handleLogin, // Desactivado si está cargando
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[900],
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: isLoading
                  ? const CircularProgressIndicator(color: Colors.white) // Indicador de carga
                  : const Text(
                'Iniciar Sesión',
                style: TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 20),

            // Enlace para ir a la página de registro
            Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => RegisterPage()),
                  );
                },
                child: const Text.rich(
                  TextSpan(
                    text: '¿No tienes cuenta? ',
                    children: [
                      TextSpan(
                        text: 'Regístrate',
                        style: TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

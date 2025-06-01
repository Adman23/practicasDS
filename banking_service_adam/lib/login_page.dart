import 'package:banking_service_adam/register_page.dart';
import 'package:flutter/material.dart';
import 'BankService.dart';
import 'main.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  BankService bank = BankService();

  // Constructor del estado: verifica si ya hay un usuario logueado
  _LoginPageState() {
    _checkLogin();
  }

  void _ErrorAlert(String message){
    showDialog<String> (
      context: context,
      builder: (BuildContext context) => AlertDialog(
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, "OK"),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  } // Muestra errores con un aviso

  _checkLogin() async {
    try {
      String name = await bank.checkLogin();
      if (name != "") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => BankWidget(title: name, bank: bank)),
        );
      }
    }catch (e) {
      _ErrorAlert(e.toString());
    }
  }       // Verifica si se mantiene la sesión

  void _handleLogin() async {
    try {
      String email = emailController.text.trim();
      String password = passwordController.text;
      String name = await bank.login(email, password);

      // Si el login es exitoso, redirige al BankWidget
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => BankWidget(title: name, bank: bank)),
      );
    } catch (e) {
      _ErrorAlert(e.toString());
    }
  } // Realiza login

  @override
  Widget build(BuildContext context){
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

            // Botón de inicio de sesión
            ElevatedButton(
              onPressed: _handleLogin, // Desactivado si está cargando
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[900],
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text(
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
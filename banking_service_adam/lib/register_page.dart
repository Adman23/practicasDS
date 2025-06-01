import 'package:flutter/material.dart';
import 'BankService.dart';
import 'main.dart';


class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmationController = TextEditingController();

  BankService bank = BankService();

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

  // Función que maneja el registro de usuario
  void _handleRegister() async {
    try {
      // Intenta registrar al usuario con los datos proporcionados
      await bank.registerUser(
        usernameController.text.trim(),
        emailController.text.trim(),
        passwordController.text,
        passwordConfirmationController.text,
      );

      // Si el registro es exitoso, vuelve a la pantalla de login
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registro exitoso. Inicia sesión.')),
      );
    } catch (e) {
      _ErrorAlert(e.toString());
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Registro',
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),

              // Campo: Nombre de usuario
              TextField(
                controller: usernameController,
                decoration: const InputDecoration(
                  labelText: 'Nombre de Usuario',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Campo: Email
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),

              // Campo: Contraseña
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(
                  labelText: 'Contraseña',
                  border: OutlineInputBorder(),
                ),
                obscureText: true, // Oculta el texto
              ),
              const SizedBox(height: 16),

              // Campo: Confirmación de contraseña
              TextField(
                controller: passwordConfirmationController,
                decoration: const InputDecoration(
                  labelText: 'Confirmar Contraseña',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 24),


              // Botón de registro
              ElevatedButton(
                onPressed:  _handleRegister, // Desactivado si está cargando
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[900],
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text(
                  'Registrarse',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
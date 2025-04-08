import 'package:flutter/material.dart';
import 'Objetivo.dart';
import 'AdminFiltros.dart';
import 'FiltroSizePassword.dart';
import 'FiltroCorreo.dart';
import 'FiltroCharIntPassword.dart';
import 'FiltroBlankPassword.dart';
import 'Cliente.dart';
import 'FiltroCorreoRepetido.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const appTitle = 'INTRODUZCA CORREO Y CONTRASEÑA';

    return MaterialApp(
      title: appTitle,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text(appTitle),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: const MyCustomForm(),
      ),
    );
  }
}

class MyCustomForm extends StatefulWidget {
  const MyCustomForm({super.key});

  @override
  MyCustomFormState createState() => MyCustomFormState();
}

class MyCustomFormState extends State<MyCustomForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  late final AdminFiltros admin;
  late final Cliente correo;

  @override
  void initState() {
    super.initState();

    final correoFiltro = Objetivo();
    admin = AdminFiltros(correoFiltro);

    admin.addFiltro(FiltroCorreo());
    admin.addFiltro(FiltroSizePassword());
    admin.addFiltro(FiltroCharIntPassword());
    admin.addFiltro(FiltroBlankPassword());
    admin.addFiltro(FiltroCorreoRepetido());

    correo = Cliente(admin);
  }



  void _loginAlert(String message){
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
  }


  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      String email = emailController.text;
      String password = passwordController.text;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Correo: $email, Contraseña: $password')),
      );



      // Enviar correo devuelve un par de valores que permiten identificar
      // si hay fallo y cual es el fallo
      MapEntry<bool, String> output = correo.enviarCorreo(email, password);
      _loginAlert(output.value);

      if(output.key){
        emailController.text = "";
        passwordController.text = "";
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(16),
        width: 500,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Correo'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, introduce un correo';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: passwordController,
                decoration: const InputDecoration(labelText: 'Contraseña'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, introduce una contraseña';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Enviar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ejercicio 1 grupal',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Filtros Intercepción'),
    );
  }
}




//------------------------------------------------------------------------------
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

//------------------------------------------------------------------------------
class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),

      // Se puede poner de child un widget de layout que permita
      // children y poner varios de ellos
      body: Padding(
        padding: EdgeInsets.all(5),
        child: SendMail(),
      ),


    );
  }
}
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
class SendMail extends StatefulWidget {
  const SendMail({super.key});
  @override
  State<SendMail> createState() => _SendMailState();
}

//------------------------------------------------------------------------------
class _SendMailState extends State<SendMail> {
  // Funciones y variables
  final _formKey = GlobalKey<FormState>();
  Map<String, String> users = {};
  String _correo = "";
  String _password = "";

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 500,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text(users.toString()),

              Padding(
                padding: EdgeInsets.all(12),
                child: TextFormField(
                  decoration: InputDecoration(labelText: 'Correo'),
                  validator: (value){
                    if (value!.trim().isEmpty) {
                      return 'Ingresa el correo';
                    }
                    return null;
                  },

                  onSaved: (value) {
                    _correo = value!;
                  },
                ),
              ),

              Padding(
                padding: EdgeInsets.all(12),
                child: TextFormField(
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  obscuringCharacter: "*",
                  decoration: InputDecoration(labelText: 'Contraseña'),
                  validator: (value){
                    if (value!.trim().isEmpty) {
                      return 'Ingresa una contraseña';
                    }
                    return null;
                  },

                  onSaved: (value) {
                    _password = value!;
                  },
                ),
              ),

              ElevatedButton(
                onPressed: (){
                  setState(() {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      users[_correo] = _password;
                    }
                  });
                },
                child: Text('Enviar'),
              ),
            ],
          ),
        ),
      ),
    );

  }
}
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
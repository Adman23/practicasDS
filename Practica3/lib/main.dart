import 'package:flutter/material.dart';
import 'BankService.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
        home: const BankWidget(title: 'Bienvenido usuario: Pepe'),
    );
  }
}


class BankWidget extends StatefulWidget {
  const BankWidget({super.key, required this.title});

  final String title;

  @override
  State<BankWidget> createState() => _BankWidget();
}

class _BankWidget extends State<BankWidget> {

  BankService bank = BankService();

  @override
  Widget build(BuildContext context) {
    return Scaffold( // Scaffold principal de la aplicación

      // Barra título
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),

      // Cuerpo central
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          // Listado Visual de Cuentas
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                // BLOQUE VISUALIZAR CUENTAS
                Text("Cuentas: "), // Esto se puede poner más bonito
                // Contenedor que tiene todas las cuentas en una lista
                Expanded(
                  flex: 1,
                  child: Container(
                    height: 100,
                    decoration: BoxDecoration(
                      border: Border(top: BorderSide(color: Colors.grey),
                                    bottom: BorderSide(color: Colors.grey),
                                    left: BorderSide(color: Colors.grey),
                                    right: BorderSide(color: Colors.grey),),
                    ),
                    child: Center(
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: bank.accounts.keys.length,
                        itemBuilder: (context, idx){
                          return Center(
                                    child: Padding(padding:EdgeInsets.all(10.0),
                                           child:Text(bank.accounts.keys.elementAt(idx))),
                                  );
                        },
                      ),
                    ),
                  )
                ),
              ],
            ),
          ),

          // BLOQUE CREAR CUENTA
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      bank.createAccount();
                    });
                  },
                  child: Text('Create new Account'),
                ),
              ],
            ),
          ),

          // BLOQUE INGRESAR DINERO
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                // Campos de valor
                //


                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      // Codigo de ingresar, tiene que coger valores de los otros campos
                    });
                  },
                  child: Text('Ingresar'),
                ),
              ],
            ),
          ),


          // BLOQUE RETIRAR DINERO
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Text("COSA1"),
                Text("COSA2"),
                Text("COSA3"),
                Text("COSA4"),
                Text("COSA5"),
                Container(
                  height: 100,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border(top: BorderSide(color: Colors.grey),
                      bottom: BorderSide(color: Colors.grey),
                      left: BorderSide(color: Colors.grey),
                      right: BorderSide(color: Colors.grey),),
                  ),
                  child: Text("COSA9"),
                )
              ],
            ),
          ),


          // BLOQUE TRANSFERIR DINERO
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Text("COSA1"),
                Text("COSA2"),
                Text("COSA3"),
                Text("COSA4"),
                Text("COSA5"),
                Container(
                  height: 100,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border(top: BorderSide(color: Colors.grey),
                      bottom: BorderSide(color: Colors.grey),
                      left: BorderSide(color: Colors.grey),
                      right: BorderSide(color: Colors.grey),),
                  ),
                  child: Text("COSA9"),
                )
              ],
            ),
          )

        ]
      ),
    );
  }
}

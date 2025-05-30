import 'package:flutter/material.dart';
import './subscriptionManager.dart';
import './subscription.dart';

void main() {
  runApp(const MyApp());
}


//------------------------------------------------------------------------------
// Widget principal de la página
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ejercicio 2',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Suscripciones'),
    );
  }
}
//------------------------------------------------------------------------------





//------------------------------------------------------------------------------
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;
  @override
  State<MyHomePage> createState() => _Home();
}
//------------------------------------------------------------------------------
class _Home extends State<MyHomePage> {

  SubscriptionManager manager = SubscriptionManager();

  void _addSubscription(String description, double payment) {
    setState(() {
      manager.add(Subscription(description, payment));
    });
  }

  void _removeSubscription(Subscription subscription) {
    setState(() {
      manager.remove(subscription);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold( // Tenemos un Scaffold como widget principal

      // AppBar que es la barra de arriba y funciona como título
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),

      // Cuerpo principal del programa, tengo un padding para que deje algo
      // de espacio a los bordes
      body: Padding(
        padding: EdgeInsets.all(15),

        // Habrá 2 elementos que se colocarán en fila
        child: Row(
          children: [

            // Primero de los 2 elementos
            // Listado de todas las suscripciones junto a un widget que muestra
            // El gasto tota por mes.
            Subscriptions(manager: manager, onRemove: _removeSubscription),

            // Segundo de los 2 elementos
            // Funciona como un formulario para instroducir nuevas suscripciones
            // Obviamente como no se usa base de datos no se guardan los
            // datos al recargar.
            SubscriptionForm(onAdd: _addSubscription),

              // Aquí se pueden añadir más widget!
          ]
        ),
      ),
    );
  }
}
//------------------------------------------------------------------------------



//------------------------------------------------------------------------------
// Clase para el listado general de las suscripciones
class Subscriptions extends StatefulWidget {
  const Subscriptions({super.key, required this.manager, required this.onRemove});
  final SubscriptionManager manager;
  final Function(Subscription) onRemove;

  @override
  State<Subscriptions> createState() => _SubscriptionList();
}

//------------------------------------------------------------------------------
// Implementación
class _SubscriptionList  extends State<Subscriptions> {

  late SubscriptionManager manager;

  @override
  void initState(){
    super.initState();
    manager = widget.manager;
  }

  String _getTotal(){
    return manager.monthlyTotal.toString();
  }


  @override Widget build(BuildContext context){
    return Flexible(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(30.0),
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                width: 400,
                height: 50,
                constraints: BoxConstraints(maxHeight: 150, maxWidth: 500),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                    padding: EdgeInsets.all(5),
                    child: Center(child: Text("A final de mes se cobrará un total de: "
                        "${_getTotal()}"),)
                ),
              ),
            ),
          ),

          Expanded (
            child: GridView.builder(
              itemCount: manager.subscriptions.length,
              itemBuilder: (BuildContext context, int idx){
                return Align(
                  alignment: Alignment.center,
                  child: Container(
                    constraints: BoxConstraints(maxHeight: 150, maxWidth: 500),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 2),
                      borderRadius: BorderRadius.circular(10),
                    ),

                    child: Center(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text("${manager.subscriptions[idx].description} "
                                "\nCoste: ${manager.subscriptions[idx].payment}"),
                            ElevatedButton(
                              onPressed: (){
                                setState(() {
                                  widget.onRemove(manager.subscriptions[idx]);
                                });
                              },
                              child: Icon(Icons.close),
                            ),
                          ]
                      ),
                    ),
                  ),
                );
              },
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 3/2,
                mainAxisExtent: 100,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
//------------------------------------------------------------------------------




//------------------------------------------------------------------------------
// Widget modificable para que funcione como formulario
class SubscriptionForm extends StatefulWidget {
  const SubscriptionForm({super.key, required this.onAdd});
  final Function(String, double) onAdd;
  @override
  State<SubscriptionForm> createState() => _SubForm();
}
//------------------------------------------------------------------------------

class _SubForm extends State<SubscriptionForm> {
  final _formKey = GlobalKey<FormState>();
  String _description = "";
  double _payment = 0.0;

  @override Widget build(BuildContext context){
    return Padding(
      padding: EdgeInsets.only(left: 15.0),
      child: Container(
        width: 400,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(12),
                child: TextFormField(
                  decoration: InputDecoration(labelText: 'Descripción'),
                  validator: (value){
                    if (value == null || value.isEmpty) {
                      return 'Ingresa una descripción';
                    }
                    return null;
                  },

                  onSaved: (value) {
                    _description = value!;
                  },
                ),
              ),

              Padding(
                padding: EdgeInsets.all(12),
                child: TextFormField(
                  decoration: InputDecoration(labelText: 'Coste mensual'),
                  validator: (value){
                    if (value == null || value.isEmpty) {
                      return 'Ingresa un coste';
                    }
                    return null;
                  },

                  onSaved: (value) {
                    _payment = double.parse(value!);
                  },
                ),
              ),

              ElevatedButton(
                onPressed: (){
                  setState(() {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      widget.onAdd(_description, _payment);
                    }
                  });
                },
                child: Text('Enviar'),
              ),
            ],
          ),
        ),
      ),

      // Aqui podrías añadir más cosas

    );
  } // Aqui acaba el metodo de build
} // Aqui acaba la clase
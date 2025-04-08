import 'package:flutter/material.dart';
import 'statisticsFactory.dart';
import 'operation_interface.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ejercicio individual 1',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Operaciones de estadística'),
    );
  }
}


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  List<Map<String,dynamic>> results = [];
  List<double> values = [];

  // Para introducir nuevas operaciones simplemente hay que introducirlas aqui
  // Si están implementadas se podrán usar en la aplicación
  List<bool> selectedOperations = [];
  List<String> operations = [];
  StatisticsFactory factory = StatisticsFactory();


  _MyHomePageState(){
    operations = factory.getOperationsList();
    selectedOperations = List.filled(operations.length, false);
  }

  final TextEditingController _controller = TextEditingController();

  // Función para calcular el resultado de las operaciones escogidas
  void getResults(){
      results.clear();
      for (int i = 0; i < operations.length; i++){
        if (selectedOperations[i]) {
          StatisticalOperation operation = factory.getOperation(operations[i], values);
          setState(() {
            results.add({'name': operations[i].toString(), 'value': operation.operate()});
          });
        }
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text(widget.title),
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: values.length,
                    itemBuilder: (context, idx){
                      return Row (
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(values[idx].toString()),
                          ElevatedButton(
                            onPressed: (){
                              setState(() {
                                values.remove(values[idx]);
                              });
                            },
                            child: Icon(Icons.close),
                          ),
                        ],
                      );
                    }
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _controller,
                      onSubmitted: (value) {
                        setState(() {
                          values.add(double.parse(value));
                          _controller.clear();
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'Enter a value',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            flex: 1,
            child: Container(
                alignment: Alignment.topLeft,
                child: Column(
                  children: [
                    ListView.builder(
                      shrinkWrap:true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: operations.length,
                      itemBuilder: (context, idx){
                        return CheckboxListTile (
                          title: Text(operations[idx]),
                          value: selectedOperations[idx],
                          onChanged: (bool? value){
                            setState(() {
                              selectedOperations[idx] = value!;
                            });
                          },
                        );
                      }
                    ),
                  ],
                )
            ),
          ),

          ElevatedButton(
            onPressed: () {
              setState(() {
                getResults();
              });
            },
            child: Text('Calculate'),
          ),
          Expanded(
            flex: 4,
            child: Container(
              alignment: Alignment.topLeft,
              child: ListView.builder(
                itemCount: results.length,
                itemBuilder: (context, idx) {
                  return Container(
                    height: 50, // Tamaño específico
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.grey)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(results[idx]['name'].toString()),
                        Text(results[idx]['value'].toStringAsFixed(4)),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}



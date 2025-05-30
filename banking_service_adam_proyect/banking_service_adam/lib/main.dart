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
  final ScrollController _scrollController = ScrollController();
  final _valueControllerDeposit = TextEditingController();
  final _valueControllerWithdrawal = TextEditingController();
  final _valueControllerTransfer = TextEditingController();

  String _selectedAccountDeposit = "";
  String _selectedAccountWithdrawal = "";
  String _selectedAccountTransferFrom = "";
  String _selectedAccountTransferTo = "";
  double? _amountDeposit = 0;
  double? _amountWithdrawal = 0;
  double? _amountTransfer = 0;

  @override
  void dispose(){
    _scrollController.dispose();
    super.dispose();
  }

  Future<String?> _showSelectionDialog(BuildContext context, Iterable<String> items) {
    return showModalBottomSheet<String>(
      context: context,
      builder: (context) {
        return ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items.elementAt(index);
            return ListTile(
              title: Text("Número de cuenta: $item"),
              onTap: () {
                Navigator.pop(context, item);
              },
            );
          },
        );
      },
    );
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
  }


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
                      child: RawScrollbar(
                        controller: _scrollController,
                        radius: const Radius.circular(10),
                        thickness: 10,
                        thumbColor: Colors.indigo,
                        child: ListView.builder(
                          controller: _scrollController,
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: bank.accounts.keys.length,
                          itemBuilder: (context, idx){
                            return Center(
                              child: Padding(
                                padding:EdgeInsets.all(10.0),
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border(top: BorderSide(color: Colors.grey),
                                      bottom: BorderSide(color: Colors.grey),
                                      left: BorderSide(color: Colors.grey),
                                      right: BorderSide(color: Colors.grey),),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Padding(padding: EdgeInsets.only(top: 10, left:10, right: 10), child: Text("Account: ${bank.accounts.keys.elementAt(idx)}")),
                                      Padding(padding: EdgeInsets.all(10.0), child: Text("Balance: ${bank.getBalance(bank.accounts.keys.elementAt(idx))}")),                                   ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      )
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
                // SELECCIÓN DE LA CUENTA A DEPOSITAR
                ElevatedButton(
                  onPressed: () async {
                    final selected = await _showSelectionDialog(context, bank.accounts.keys);
                    setState(() {
                      _selectedAccountDeposit = selected!;
                    });
                    if (selected != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Seleccionaste: $selected')),
                      );
                    }
                  },
                  child: const Text('Seleccionar cuenta'),
                ),

                // MOSTRAR LA SELECCIÓN
                Padding(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Center(
                    child: Text("Seleccionada: $_selectedAccountDeposit"),
                  ),
                ),

                // INTRODUCIR CANTIDAD A INGRESAR
                Expanded(
                  flex:1,
                  child: Padding(
                    padding: EdgeInsets.only(left:20, right: 20),
                    child: TextField(
                      controller: _valueControllerDeposit,
                      onChanged: (value) {
                        setState(() {
                          _amountDeposit = double.tryParse(_valueControllerDeposit.text);
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'Introduce cantidad',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),

                // INGRESAR EL DINERO
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      if (_selectedAccountDeposit != "") {
                        if (_amountDeposit != null && _amountDeposit != 0) {
                          try{
                            bank.deposit(_selectedAccountDeposit, _amountDeposit!);
                          }
                          catch(e){
                            _ErrorAlert(e.toString());
                          }
                          _valueControllerDeposit.clear();
                          _selectedAccountDeposit = "";
                        }
                        else{
                          _ErrorAlert("No hay cantidad o es incorrecta");
                        }
                      }
                      else{
                        _ErrorAlert("Tienes que seleccionar una cuenta a ingresar");
                      }
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
                // SELECCIÓN DE LA CUENTA A DEPOSITAR
                ElevatedButton(
                  onPressed: () async {
                    final selected = await _showSelectionDialog(context, bank.accounts.keys);
                    setState(() {
                      _selectedAccountWithdrawal = selected!;
                    });
                    if (selected != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Seleccionaste: $selected')),
                      );
                    }
                  },
                  child: const Text('Seleccionar cuenta'),
                ),

                // MOSTRAR LA SELECCIÓN
                Padding(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Center(
                    child: Text("Seleccionada: $_selectedAccountWithdrawal"),
                  ),
                ),

                // INTRODUCIR CANTIDAD A RETIRAR
                Expanded(
                  flex:1,
                  child: Padding(
                    padding: EdgeInsets.only(left:20, right: 20),
                    child: TextField(
                      controller: _valueControllerWithdrawal,
                      onChanged: (value) {
                        setState(() {
                          _amountWithdrawal = double.tryParse(_valueControllerWithdrawal.text);
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'Introduce cantidad',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),

                // RETIRAR EL DINERO
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      if (_selectedAccountWithdrawal != "") {
                        if (_amountWithdrawal != null && _amountWithdrawal != 0) {
                          try {
                            bank.withdraw(_selectedAccountWithdrawal, _amountWithdrawal!);
                          }
                          catch(e){
                            _ErrorAlert(e.toString());
                          }
                          _valueControllerWithdrawal.clear();
                          _selectedAccountWithdrawal = "";
                        }
                        else{
                          _ErrorAlert("No hay cantidad o es incorrecta");
                        }
                      }
                      else{
                        _ErrorAlert("Tienes que seleccionar una cuenta");
                      }
                    });
                  },
                  child: Text('Retirar'),
                ),
              ],
            ),
          ),


          // BLOQUE TRANSFERIR DINERO
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                // SELECCIÓN DE LA CUENTA ORIGEN
                ElevatedButton(
                  onPressed: () async {
                    final selected = await _showSelectionDialog(context, bank.accounts.keys);
                    setState(() {
                      _selectedAccountTransferFrom = selected!;
                    });
                    if (selected != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Seleccionaste: $selected')),
                      );
                    }
                  },
                  child: const Text('Cuenta Origen'),
                ),
                // MOSTRAR LA SELECCIÓN
                Padding(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Center(
                    child: Text(_selectedAccountTransferFrom),
                  ),
                ),

                // SELECCIÓN DE LA CUENTA DESTINO
                ElevatedButton(
                  onPressed: () async {
                    final selected = await _showSelectionDialog(context, bank.accounts.keys);
                    setState(() {
                      _selectedAccountTransferTo = selected!;
                    });
                    if (selected != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Seleccionaste: $selected')),
                      );
                    }
                  },
                  child: const Text('Cuenta Origen'),
                ),

                // MOSTRAR LA SELECCIÓN
                Padding(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Center(
                    child: Text(_selectedAccountTransferTo),
                  ),
                ),


                // INTRODUCIR CANTIDAD A TRANSFERIR
                Expanded(
                  flex:1,
                  child: Padding(
                    padding: EdgeInsets.only(left:20, right: 20),
                    child: TextField(
                      controller: _valueControllerTransfer,
                      onChanged: (value) {
                        setState(() {
                          _amountTransfer = double.tryParse(_valueControllerTransfer.text);
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'Introduce cantidad',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),

                // TRANSFERIR EL DINERO
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      if (_selectedAccountTransferFrom != "") {
                        if (_selectedAccountTransferTo != "") {
                          if (_amountTransfer != null && _amountTransfer != 0) {
                            try {
                              bank.transfer(_selectedAccountTransferFrom,
                                  _selectedAccountTransferTo, _amountTransfer!);
                            }
                            catch (e) {
                              _ErrorAlert(e.toString());
                            }
                            _valueControllerTransfer.clear();
                            _selectedAccountTransferTo = "";
                            _selectedAccountTransferFrom = "";
                          }
                          else {
                            _ErrorAlert("No hay cantidad o es incorrecta");
                          }
                        }
                        else{
                          _ErrorAlert("Tienes que seleccionar una cuenta de destino");
                        }
                      }
                      else{
                        _ErrorAlert("Tienes que seleccionar una cuenta de origen");
                      }
                    });
                  },
                  child: Text('Transferir'),
                ),
              ],
            ),
          )

        ]
      ),
    );
  }


}

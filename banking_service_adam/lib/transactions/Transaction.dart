import '../Account.dart';


abstract class Transaction {
  String id = "";
  double amount = 0.0;
  static int _idCounter = 0;

  // Recibe la cantidad de la transacción (el valor a utilizar) y asigna un id automatico
  Transaction({required this.amount}) : id = 'TC_${_idCounter++}';
  // Recibe la cuenta para aplicar la transacción
  void apply(Account account);
}
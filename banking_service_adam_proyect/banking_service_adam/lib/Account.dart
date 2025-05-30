

class Account {
  String number = "";
  double balance = 0;

  /*
    Balance inicial será 0 por definición y necesitará un número de cuenta
   */
  Account({required this.number});

  /*
    Función para hacer un depósito de dinero
   */
  void deposit(double value){
    if (value > 0){
      balance += value; // Modificamos la cuenta
    }
    else {
      throw RangeError("Valor no está en el rango ( > 0 )");
    }
  }

  /*
  Función para hacer una retirada de dinero de la cuenta
   */
  void withdrawal(double value){

    if (value > 0){
      if (value <= balance) {
        balance -= value; // Modificamos la cuenta
      }
      else{
        throw StateError("El valor supera el balance de la cuenta");
      }
    }
    else {
      throw RangeError("Valor no está en el rango ( > 0 )");
    }
  }
}
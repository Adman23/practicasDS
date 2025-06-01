class Account {
  int id;
  String number;
  double balance;

  /*
    Balance inicial será 0 por definición y necesitará un número de cuenta
   */
  Account({required this.number, required this.id, required this.balance});

  factory Account.fromJson(Map<String, dynamic> json){
    return Account(
      id: json['id']!,
      number: json['number']!,
      balance: double.parse(json['balance'])
    );
  }

  /*
    Función para hacer un depósito de dinero
   */
  void deposit(double value){
    if (value > 0){
      balance +=  value; // Modificamos la cuenta
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


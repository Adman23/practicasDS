
// Definimos clase abstracta que cogerán el resto de operaciones

abstract class StatisticalOperation{

  List<double> values = []; // Valores sobre los que se aplica la operación

  // Constructor que asigna los valores iniciales
  StatisticalOperation(this.values);

  // Realizar la operación en concreto, específica de cada clase
  double operate();
}








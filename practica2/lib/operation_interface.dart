
// Definimos clase abstracta que cogerán el resto de operaciones

abstract class StatisticalOperation{

  List<double> values = []; // Valores sobre los que se aplica la operación
  double lastValue = 0; // Último valor que se calculo (si no se cambian los valores)

  // Constructor que asigna los valores iniciales
  StatisticalOperation(this.values);

  // Realizar la operación en concreto, específica de cada clase
  double operate();

  // Poder obtener ese último valor
  double getLastValue(){
    return lastValue;
  }

  // Poder cambiar los valores una vez se ha creado el objeto
  void setValues(List<double> newValues){
    values.clear();
    values = newValues;
    lastValue = 0;
  }
}








import './operation_interface.dart';

class Mean extends StatisticalOperation {
  Mean(super.values);

  @override
  double operate(){
    double result = 0;
    for (int i = 0; i < super.values.length; i++){
      result += super.values[i];
    }
    result = result / super.values.length;
    super.lastValue = result;
    return result;
  }

}


class Trend extends StatisticalOperation {
  Trend(super.values);
  @override
  double operate(){
    Map<double, int> frequency = {};
    for (var number in super.values) {
      if (frequency.containsKey(number)){
        frequency[number] = frequency[number]! + 1;
      }
      else {
        frequency[number] = 1;
      }
    }

    int max = 0;
    double trend = 0;
    frequency.forEach((key, value){
      if (value > max){
        max = value;
        trend = key;
      }
    });

    return trend;
  }
}

// Falta implementar mediana, varianza y desviación estandar y alguna más

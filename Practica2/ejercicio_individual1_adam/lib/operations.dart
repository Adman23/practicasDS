import 'dart:math';

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

class Variance extends StatisticalOperation {
  Variance(super.values);
  @override
  double operate(){
    double mean = Mean(super.values).operate();
    double variance = 0;
    for (double value in super.values){
      variance = variance + pow(value - mean, 2);
    }

    variance = variance / (super.values.length);

    return variance;
  }
}

class StandardDeviation extends StatisticalOperation {
  StandardDeviation(super.values);
  @override
  double operate() => sqrt(Variance(super.values).operate());
}

class Median extends StatisticalOperation {
  Median(super.values);
  @override
  double operate(){
    List<double> values = super.values;
    values.sort();
    double median = 0;
    int size = values.length;
    if (size % 2 == 0 && size >= 2){
      double value1 = values[(size/2-1).toInt()];
      double value2 = values[(size/2).toInt()];
      median = Mean([value1, value2]).operate();
    }
    else{
      median = values[(size/2).toInt()]; // Cogemos el índice del medio
    }

    return median;
  }
}

class Range extends StatisticalOperation {
  Range(super.values);
  @override
  double operate(){
    List<double> values = super.values;
    values.sort();
    return values[values.length-1] - values[0];
  }
}

















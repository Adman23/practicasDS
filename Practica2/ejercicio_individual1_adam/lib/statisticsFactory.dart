import './operations.dart';
import './operation_interface.dart';

class StatisticsFactory {
  List<String> operations = [];

  StatisticsFactory(){
    operations = ['Mean', 'Trend', 'Variance', 'StandardDeviation', 'Median',
                  'Range'];
  }

  List<String> getOperationsList(){
    return operations;
  }

  StatisticalOperation getOperation(String operationName, List<double> values){
    operationName = operationName.trim();
    operationName = operationName.toLowerCase();
    switch(operationName){
      case('mean'): {
        return Mean(values);
      }
      case('trend'): {
        return Trend(values);
      }
      case('variance'):{
        return Variance(values);
      }
      case('standarddeviation'):{
        return StandardDeviation(values);
      }
      case('median'):{
        return Median(values);
      }
      case('range'):{
        return Range(values);
      }
      default: throw ArgumentError("Not a supported operation");
    }
  }
}

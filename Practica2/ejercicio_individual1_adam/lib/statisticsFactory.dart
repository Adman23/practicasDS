import './operations.dart';
import './operation_interface.dart';

class StatisticsFactory {
  StatisticalOperation getOperation(String operationName, List<double> values){
    switch(operationName){
      case('mean'):case('Mean'): {
        return Mean(values);
      }
      case('trend'):case('Trend'): {
        return Trend(values);
      }
      default: throw ArgumentError("Not a supported operation");
    }
  }
}

import 'dart:math';

import '../Expense.dart';
class Target {
  void publish(Expense expense){
    print("Se muestra lo siguiente: " + expense.title + " " + expense.date.toString() + " " + expense.participants.toString() + " " + expense.buyer.toString() + " " + expense.cost.toString());
  }
}
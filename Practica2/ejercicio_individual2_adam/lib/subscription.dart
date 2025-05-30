
class Subscription {
  String subDescription = "";
  double monthlyPayment = 0.0;

  Subscription(this.subDescription, this.monthlyPayment);

  // Setters
  set payment(double payment) => monthlyPayment = payment;
  set description(String des) => subDescription = des;

  // Getters
  String get description => subDescription;
  double get payment => monthlyPayment;
}
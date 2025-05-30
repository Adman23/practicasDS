import './subscription.dart';

class SubscriptionManager {
  List<Subscription> currentSubs = [];
  double totalPayment = 0.0;
  SubscriptionManager();
  SubscriptionManager.fromList(List<Subscription> other);
  
  // Setters
  void add(Subscription newSub) {
    currentSubs.add(newSub);
  }
  void remove(Subscription sub) {
    currentSubs.remove(sub);
  }

  void clone(SubscriptionManager sm){
    currentSubs.clear();
    for (Subscription sub in sm.currentSubs){
      currentSubs.add(Subscription(sub.description, sub.payment));
    }
  }
  
  // Getters
  List<Subscription> get subscriptions => currentSubs;

  double get monthlyTotal {

    totalPayment = 0;
    for (Subscription sub in currentSubs) {
      totalPayment += sub.payment;
    }
    return totalPayment;
  }
  
  // Other
  bool isEmpty() => currentSubs.isEmpty;
}
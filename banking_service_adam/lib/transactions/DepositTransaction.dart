import 'Transaction.dart';
import '../Account.dart';

class DepositTransaction extends Transaction {

  DepositTransaction({required super.amount});

  @override
  void apply(Account account){
    try{
      account.deposit(super.amount);
    }
    catch(e){
      rethrow;
    }
  }
}
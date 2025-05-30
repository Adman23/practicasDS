import 'Transaction.dart';
import '../Account.dart';

class WithdrawalTransaction extends Transaction {

  WithdrawalTransaction({required super.amount});

  @override
  void apply(Account account){
    try{
      account.withdrawal(super.amount);
    }
    catch(e){
      rethrow;
    }
  }
}

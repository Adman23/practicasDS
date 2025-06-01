import 'Transaction.dart';
import '../Account.dart';

class WithdrawalTransaction extends Transaction {

  WithdrawalTransaction({required super.amount});

  @override
  Future<void> apply(Account account) async{
    try{
      final body = {
        "amount": amount,
      };
      await super.operate("withdrawal", body, account.id);
      account.withdrawal(super.amount);
    }
    catch(e){
      rethrow;
    }
  }
}

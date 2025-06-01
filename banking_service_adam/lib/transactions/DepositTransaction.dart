import 'Transaction.dart';
import '../Account.dart';

class DepositTransaction extends Transaction {

  DepositTransaction({required super.amount});

  @override
  Future<void> apply(Account account) async {
    try{
      final body = {
        "amount": amount,
      };
      await super.operate("deposit", body, account.id);
      account.deposit(super.amount);
    }
    catch(e){
      rethrow;
    }
  }
}
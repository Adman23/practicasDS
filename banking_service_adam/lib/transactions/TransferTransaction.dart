import 'Transaction.dart';
import '../Account.dart';

class TransferTransaction extends Transaction {
  Account toAccount;

  TransferTransaction({required super.amount, required this.toAccount});

  @override
  Future<void> apply(Account fromAccount) async {
    try{
      final body = {
        "amount": amount,
        "to_account_id": toAccount.id,
      };
      await super.operate("transfer", body, fromAccount.id);

      fromAccount.withdrawal(super.amount);
      toAccount.deposit(super.amount);
    }
    catch(e){
      rethrow;
    }
  }
}
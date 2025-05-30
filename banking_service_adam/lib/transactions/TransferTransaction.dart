import 'Transaction.dart';
import '../Account.dart';

class TransferTransaction extends Transaction {
  Account toAccount;

  TransferTransaction({required super.amount, required this.toAccount});

  @override
  void apply(Account fromAccount){
    try{
      fromAccount.withdrawal(super.amount);
      toAccount.deposit(super.amount);
    }
    catch(e){
      rethrow;
    }
  }
}
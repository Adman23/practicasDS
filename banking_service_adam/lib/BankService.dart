import './Transaction.dart';
import './WithdrawalTransaction.dart';
import './DepositTransaction.dart';
import './TransferTransaction.dart';
import './Account.dart';


class BankService {
  Map<String, Account> accounts = {};
  static int _idCounter = 10;

  void createAccount(){
    String accountNum = "ES 21 9183 76622 17 18255486${_idCounter++}";
    Account newAccount = Account(number: accountNum);
    accounts[accountNum] = newAccount;
  }

  void deposit(String accountNum, double amount) {
    Transaction deposit = DepositTransaction(amount: amount);
    deposit.apply(accounts[accountNum]!); // Si no existe la cuenta lanza NoSuchMethodError
  }

  void withdraw(String accountNum, double amount) {
    Transaction withdrawal = WithdrawalTransaction(amount: amount);
    withdrawal.apply(accounts[accountNum]!); // Si no existe la cuenta lanza NoSuchMethodError
  }

  void transfer(String accountNumFrom, String accountNumTo, double amount) {
    Transaction transfer = TransferTransaction(amount: amount, toAccount: accounts[accountNumTo]!);
    transfer.apply(accounts[accountNumFrom]!); // Si no existe la cuenta lanza NoSuchMethodError
  }

  double getBalance(String accountNum){
    return accounts[accountNum]!.balance;
  }
}

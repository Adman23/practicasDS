
import  'package:sistema_bancario/Account.dart';
import  'package:sistema_bancario/Transaction.dart';
import  'package:sistema_bancario/DepositTransaction.dart';
import  'package:sistema_bancario/WithdrawalTransaction.dart';
import  'package:sistema_bancario/TransferTransaction.dart';
import  'package:sistema_bancario/BankService.dart';
import  'package:sistema_bancario/DepositTransaction.dart';
import  'package:test/test.dart';

void main(){
  // TESTS para las cuentas
  test('balanceInicial', () {
    BankService banco = BankService();
    banco.createAccount();
    expect(banco.getBalance(banco.accounts.keys.elementAt(0)), equals(0.0));
  });

  test('depositarNegativoCero', () {
    BankService banco = BankService();
    banco.createAccount();
    expect(() => banco.deposit(banco.accounts.keys.elementAt(0), -1), throwsA(isA<RangeError>()));
  });

  test('retirarNegativoCero', () {
    BankService banco = BankService();
    banco.createAccount();
    expect(() => banco.withdraw(banco.accounts.keys.elementAt(0), -1), throwsA(isA<RangeError>()));
  });

  // TESTS para las transacciones
  test('aumentarSaldo', () {
    String accountNum = "1";
    Account newAccount = Account(number: accountNum);
    Transaction deposit = DepositTransaction(amount: 3);
    deposit.apply(newAccount);
    expect(newAccount.balance, equals(3.0));
  });

  test('retirarSaldoInsuficiente', () {
    String accountNum = "1";
    Account newAccount = Account(number: accountNum);
    Transaction withdrawal = WithdrawalTransaction(amount: 3);
    expect(() => withdrawal.apply(newAccount), throwsA(isA<StateError>()));
  });

  test('transferirSaldo', () {
    String accountNum1 = "1";
    String accountNum2 = "2";
    Account newAccount1 = Account(number: accountNum1);
    Account newAccount2 = Account(number: accountNum2);
    Transaction deposit = DepositTransaction(amount: 10);
    deposit.apply(newAccount1);
    Transaction transfer = TransferTransaction(amount: 5, toAccount: newAccount2);
    transfer.apply(newAccount1);
    expect(newAccount1.balance, equals(5.0));
    expect(newAccount2.balance, equals(5.0));
  });



  // TESTS para el bank service
  test('lista_vacia', () {
    BankService banco = BankService();
    expect(banco.accounts.isEmpty, true);
  });

  test('deposit_aumenta', () {
    BankService banco = BankService();
    banco.createAccount();
    banco.deposit(banco.accounts.keys.elementAt(0), 50);
    expect(banco.getBalance(banco.accounts.keys.elementAt(0)), 50);
  });

  test('StateError_saldoInsuficiente', () {
    BankService banco = BankService();
    banco.createAccount();
    banco.deposit(banco.accounts.keys.elementAt(0), 50);
    expect(() => banco.withdraw(banco.accounts.keys.elementAt(0), 100), throwsA(isA<StateError>()));
  });

  test('mueve_fondos', () {
    BankService banco = BankService();
    banco.createAccount();
    banco.deposit(banco.accounts.keys.elementAt(0), 50);
    banco.createAccount();
    banco.transfer(banco.accounts.keys.elementAt(0), banco.accounts.keys.elementAt(1), 25);
    expect(banco.getBalance(banco.accounts.keys.elementAt(0)), 25);
    expect(banco.getBalance(banco.accounts.keys.elementAt(1)), 25);
  });

  test('StateError_fondosTransferenciaInsuficiente', () {
    BankService banco = BankService();
    banco.createAccount();
    banco.deposit(banco.accounts.keys.elementAt(0), 50);
    banco.createAccount();
    expect(() => banco.transfer(banco.accounts.keys.elementAt(0), banco.accounts.keys.elementAt(1), 65), throwsA(isA<StateError>()));
  });

  test('txId genera identificadores unicos', () {
    BankService banco = BankService();
    banco.createAccount();
    banco.createAccount();
    expect(banco.accounts.keys.first != banco.accounts.keys.elementAt(1),true);});




}
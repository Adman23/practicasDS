import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import  'package:sistema_bancario/Account.dart';
import  'package:sistema_bancario/Transaction.dart';
import  'package:sistema_bancario/DepositTransaction.dart';
import  'package:sistema_bancario/WithdrawalTransaction.dart';
import  'package:sistema_bancario/TransferTransaction.dart';
import 'package:sistema_bancario/BankService.dart';
import 'package:sistema_bancario/DepositTransaction.dart';


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
    Transaction deposit = new DepositTransaction(amount: 3);
    deposit.apply(accountNum);

    expect(banco.getBalance(banco.accounts.keys.elementAt(0)), equals(3.0));
  });

  test('retirarSaldoInsuficiente', () {
    BankService banco = BankService();
    banco.createAccount();

    try {
      banco.withdraw(banco.accounts.keys.elementAt(0), 3);
    } on StateError {
      print("Guay");
    }
  });

  test('transferirSaldo', () {
    BankService banco = BankService();
    banco.createAccount();
    banco.createAccount();

    banco.deposit(banco.accounts.keys.elementAt(0), 5);
    banco.transfer(banco.accounts.keys.elementAt(0), banco.accounts.keys.elementAt(1), 5);
    expect(banco.getBalance(banco.accounts.keys.elementAt(0)), equals(0));
    expect(banco.getBalance(banco.accounts.keys.elementAt(1)), equals(5));
  });

  // TESTS para el bank service





}
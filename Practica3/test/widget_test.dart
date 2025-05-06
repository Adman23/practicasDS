// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:sistema_bancario/BankService.dart';


void main() {

  // TESTS para las cuentas
  test('nombre', () {
    BankService banco = BankService();
    banco.createAccount();
    expect(banco.getBalance(banco.accounts.keys.elementAt(0)), equals(0.0));
  });
}

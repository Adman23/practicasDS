import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:triaccount/models/user.dart';
import 'package:triaccount/services/triaccount_api_service.dart';


void main() {
  final service = TriAccountService();

  const testUsername = 'testuser2';
  const testEmail = 'test2@example.com';
  const testPhone = '1234567890';
  const testPassword = 'password123';

  group('TriAccountService API Tests', () {
    setUp(() async {
      SharedPreferences.setMockInitialValues({});
    });

    test('Register user', () async {
      await service.registerUser(
        testUsername,
        testEmail,
        testPhone,
        testPassword,
        testPassword,
      );
      // Si no lanza error, el test es exitoso
      expect(true, isTrue);
    });

    test('Login user and get token', () async {
      final user = await service.login(testEmail, testPassword);
      expect(user.username, equals(testUsername));
    });

    test('Check login returns user', () async {
      await service.login(testEmail, testPassword);
      final user = await service.checkLogin();
      expect(user, isNotNull);
      expect(user!.email, equals(testEmail));
    });

    test('Fetch users returns list', () async {
      await service.login(testEmail, testPassword);
      final users = await service.fetchUsers();
      expect(users, isA<List<User>>());
      expect(users.isNotEmpty, isTrue);
    });

    test('Logout user', () async {
      await service.login(testEmail, testPassword);
      await service.logout();
      final user = await service.checkLogin();
      expect(user, isNull);
    });
  });
}

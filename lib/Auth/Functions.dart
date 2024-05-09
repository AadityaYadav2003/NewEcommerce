import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mysql1/mysql1.dart';
import 'package:new_ecommerce/Utlis/SnackBar/snackbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class User {
  final int? id;
  final String name;
  final String email;
  String? sinceMember;

  User({
    this.id,
    required this.name,
    required this.email,
    this.sinceMember,
  });
}

class UserController extends GetxController {
  final Rx<User?> user = Rx<User?>(null);

  Future<MySqlConnection> connectToDatabase() async {
    final setting = ConnectionSettings(
      host: '10.0.2.2',
      port: 3306,
      user: "user123",
      password: 'user123',
      db: 'userdata',
    );
    await Future.delayed(const Duration(milliseconds: 100));

    final connection = await MySqlConnection.connect(setting);
    return connection;
  }

  // Register
  Future<bool> registerUser(String name, String email, String password) async {
    MySqlConnection? conn;
    try {
      conn = await connectToDatabase();
      var emailCheckResults =
          await conn.query('SELECT * FROM user WHERE email = ?', [email]);

      if (emailCheckResults.isNotEmpty) {
        showCustomSnackBar(
          "Email already registered. Please Log in or use a different email",
          title: "Registration",
        );
        return false;
      }
      var now = DateTime.now();
      var formatteDate = DateFormat('yyyy-MM-dd').format(now);
      var insertResult = await conn.query(
        'INSERT INTO users (Name, Email, Password, since_member) VALUES (?, ?, ?, ?)',
        [name, email, password, formatteDate],
      );
      if (insertResult.affectedRows == 0) {
        return false;
      }
      var userId = insertResult.insertId;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("id", userId.toString());
      prefs.setString('Name', name);
      prefs.setString('Email', email);

      user.value = User(
        id: userId,
        name: name,
        email: email,
        sinceMember: formatteDate,
      );
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Error inserting user data: $e');
      }
      return false;
    } finally {
      await conn?.close();
    }
  }
  // Login

  Future<bool> login(String email, String password) async {
    MySqlConnection? conn;
    try {
      conn = await connectToDatabase();

      var result = await conn.query(
        'SELECT * FROM users WHERE email = ? AND password = ?',
        [email, password],
      );
      if (result.isEmpty) {
        showCustomSnackBar(
          "Incorrect email or password",
          title: "Login",
        );
        return false;
      }
      var userData = result.first;
      var userid = userData['id'] as int;

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('id', userid.toString());
      prefs.setString('Name', userData['Name']);
      prefs.setString('Email', userData['Email']);
      String sinceMemberString = userData['since_member']?.toString() ?? '';

      prefs.setString('since_member', sinceMemberString);

      user.value = User(
        id: userid,
        name: userData['Name'],
        email: userData['Email'],
        sinceMember: sinceMemberString,
      );
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Error logging in: $e');
      }
      return false;
    } finally {
      await conn?.close();
    }
  }

  void logOut() {
    SharedPreferences.getInstance().then((prefs) {
      prefs.remove('Name');
      prefs.remove('Email');
      prefs.remove('since_member');
    });
    user.value = null;
  }

  @override
  void onInit() {
    super.onInit();
    SharedPreferences.getInstance().then((prefs) {
      final idString = prefs.getString('id');
      final name = prefs.getString('Name');
      final email = prefs.getString('Email');
      final sinceMember = prefs.getString('since_Member') ?? '';

      if (idString != null && name != null && email != null) {
        final id = int.tryParse(idString);
        if (id != null) {
          user.value = User(
            id: id,
            name: name,
            email: email,
            sinceMember: sinceMember,
          );
        }
      }
    });
  }
}

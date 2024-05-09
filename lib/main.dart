import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_ecommerce/Auth/Functions.dart';
import 'package:new_ecommerce/View/LoginPages/SignIn.dart';
import 'package:new_ecommerce/View/LoginPages/signUp.dart';
import 'package:new_ecommerce/View/MainPages/NavBar.dart';

void main() {
  Get.put(UserController());
  WidgetsFlutterBinding.ensureInitialized();
  UserController userController = UserController();
  userController.onInit();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: NavBar(),
    );
  }
}

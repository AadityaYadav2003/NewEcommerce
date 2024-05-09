import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_ecommerce/Auth/Functions.dart';
import 'package:new_ecommerce/View/MainPages/ProfileUtils/UserData.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserController userController = Get.find<UserController>();
  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child:  Scaffold(
        body: SizedBox(
          height: 200,
          child: UserData(),
        ),
      ),
    );
  }
}

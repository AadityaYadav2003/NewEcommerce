import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_ecommerce/Auth/Functions.dart';
import 'package:new_ecommerce/Utlis/SnackBar/snackbar.dart';
import 'package:new_ecommerce/Utlis/TextFields/Textfield.dart';
import 'package:new_ecommerce/View/MainPages/NavBar.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  UserController userController = Get.put(UserController());
  bool isLoading = false;
  bool isPasswordVisible = false;

  void registration(UserController userController) async {
    String name = nameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (name.isEmpty) {
      showCustomSnackBar("Type in your email address", title: "Email address");
    } else if (email.isEmpty) {
      showCustomSnackBar("Type in your email address", title: "Email address");
    } else if (!GetUtils.isEmail(email)) {
      showCustomSnackBar("Type your valid email address",
          title: "Valid Email address");
    } else if (password.length < 6) {
      showCustomSnackBar("password cannot be less than six characters",
          title: "Password");
    } else if (password.isEmpty) {
      showCustomSnackBar("Type your password", title: "Password");
    } else {
      setState(() {
        isLoading = true;
      });
      try {
        bool success = await userController.registerUser(name, email, password);
        if (success) {
          Get.to(const NavBar());
        } else {
          showCustomSnackBar("Registeration Failed. Please try again later",
              title: "Registration");
        }
      } catch (e) {
        print("Error during registration: $e");
        showCustomSnackBar("An error occured during registration",
            title: "REgistration");
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
                child: Center(
              child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 200, left: 20),
                        child: Text(
                          "Sign Up",
                          style: GoogleFonts.aBeeZee(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      AppTextField(
                        hintText: "Name",
                        textController: nameController,
                        leftIcon: Icons.person,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      AppTextField(
                        hintText: "Email",
                        textController: emailController,
                        leftIcon: Icons.email,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      AppTextField(
                        hintText: "Password",
                        textController: passwordController,
                        leftIcon: Icons.password,
                        isObsecure: !isPasswordVisible,
                        rightIcon: isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        onRightIconPressed: () {
                          setState(() {
                            isPasswordVisible = !isPasswordVisible;
                          });
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextButton(
                          onPressed: () async {
                            registration(userController);
                          },
                          child: Container(
                            width: 140,
                            height: 45,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: const Color.fromARGB(255, 102, 104, 209),
                            ),
                            child: Center(
                              child: Text(
                                "Sign Up",
                                style: GoogleFonts.aBeeZee(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          )),
                      const SizedBox(
                        height: 15,
                      ),
                      Center(
                        child: RichText(
                          text: TextSpan(
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => Get.back(),
                              text: "Have an account already?",
                              style: GoogleFonts.aBeeZee(
                                color: Colors.black,
                                fontSize: 20,
                              )),
                        ),
                      )
                    ],
                  )),
            ))
          ],
        ),
      ),
    );
  }
}

import "package:flutter/foundation.dart";
import "package:flutter/gestures.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mysql1/mysql1.dart";
import "package:new_ecommerce/Auth/Functions.dart";
import "package:new_ecommerce/Utlis/SnackBar/snackbar.dart";
import "package:new_ecommerce/Utlis/TextFields/Textfield.dart";
import "package:new_ecommerce/View/LoginPages/signUp.dart";
import "package:new_ecommerce/View/MainPages/NavBar.dart";

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  late UserController _userController;

  @override
  void initState() {
    _userController = Get.put(UserController());
    super.initState();
  }

  Future<void> login() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    if (email.isEmail) {
      showCustomSnackBar('Type in your email address', title: 'Email address');
    } else if (GetUtils.isEmail(email)) {
      showCustomSnackBar('Type your valid email address',
          title: 'Valid Email address');
    } else if (password.isEmpty) {
      showCustomSnackBar('Type in your password', title: "Password");
    } else {
      UserController userController = UserController();
      MySqlConnection? conn;
      try {
        conn = await userController.connectToDatabase();
        if (kDebugMode) {
          print("Success");
        }
        final result = await conn.query(
          'SELECT name, email FROM user WHERE email = ? AND password = ? LIMIT 1',
          [email, password],
        );
        if (result.isNotEmpty) {
          await conn.close();
          Get.to(() => const NavBar());
          if (kDebugMode) {
            print('Login Successful');
          }
        } else {
          showCustomSnackBar('Invalid email or password',
              title: 'Login failed');
        }
      } catch (e) {
        if (kDebugMode) {
          print('Error connecting to database: $e');
        }
      } finally {
        await conn?.close();
      }
    }
  }

  bool isPasswordVisible = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Column(
        children: [
          Expanded(
            child: Center(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(children: [
                    Container(
                      margin: const EdgeInsets.only(
                        left: 20,
                      ),
                      width: double.maxFinite,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Login',
                            style: GoogleFonts.aBeeZee(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Sign into your account',
                            style: GoogleFonts.aBeeZee(
                              fontSize: 20,
                              color: Colors.grey[500],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          AppTextField(
                            hintText: 'Email',
                            textController: emailController,
                            leftIcon: Icons.email,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          AppTextField(
                            hintText: 'Password',
                            textController: passwordController,
                            isObsecure: !isPasswordVisible,
                            rightIcon: isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            onRightIconPressed: () {
                              setState(() {
                                isPasswordVisible = !isPasswordVisible;
                              });
                            },
                            leftIcon: Icons.password,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Container(),
                              ),
                              RichText(
                                text: TextSpan(
                                  text: 'Signin to your account',
                                  style: GoogleFonts.aBeeZee(
                                    color: Colors.grey[500],
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Center(
                            child: TextButton(
                              onPressed: () async {
                                if (_formKey.currentState?.validate() ??
                                    false) {
                                  bool success = await _userController.login(
                                      emailController.text.trim(),
                                      passwordController.text.trim());
                                  if (success) {
                                    Get.to(() => const NavBar());
                                    if (kDebugMode) {
                                      print('Login Successful');
                                    }
                                  } else {
                                    showCustomSnackBar(
                                        "Invalid email address or password",
                                        title: 'Login Failed');
                                  }
                                }
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
                                    'Sign In',
                                    style: GoogleFonts.aBeeZee(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          RichText(
                            text: TextSpan(
                                text: "Don't have an account?",
                                style: GoogleFonts.aBeeZee(
                                  color: Colors.grey[500],
                                  fontSize: 20,
                                ),
                                children: [
                                  TextSpan(
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () => Get.to(
                                            () => const SignUp(),
                                          ),
                                    text: 'Create',
                                    style: GoogleFonts.aBeeZee(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Colors.black,
                                    ),
                                  ),
                                ]),
                          )
                        ],
                      ),
                    )
                  ]),
                ),
              ),
            ),
          )
        ],
      )),
    );
  }
}

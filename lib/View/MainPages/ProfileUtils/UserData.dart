import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:google_fonts/google_fonts.dart";
import "package:intl/intl.dart";
import "package:mysql1/mysql1.dart";
import "package:new_ecommerce/Auth/Functions.dart";
import "package:new_ecommerce/View/LoginPages/SignIn.dart";
import "package:new_ecommerce/View/MainPages/ProfileUtils/ProfilePicture.dart";

class UserData extends StatefulWidget {
  const UserData({super.key});

  @override
  State<UserData> createState() => _UserDataState();
}

class _UserDataState extends State<UserData> {
  final UserController userController = Get.find<UserController>();
  String selectedImagePath = '';
  @override
  void initState() {
    void_loadSelectedImagePath();
    super.initState();
  }

  void_loadSelectedImagePath() async {
    if (userController.user.value?.id != null) {
      String? imagePath =
          await getImagePathFromDatabase(userController.user.value!.id!);
      setState(() {
        selectedImagePath = imagePath ?? '';
      });
    }
  }

  Future<void> saveImagePathInDatabase(int userid, String imagePath) async {
    MySqlConnection? conn;
    try {
      conn = await userController.connectToDatabase();

      var result = await conn.query(
        'SELECT * FROM images WHERE userid = ?',
        [userid],
      );
      if (result.isNotEmpty) {
        await conn.query(
          'UPDATE images SET ImagePath = ? WHERE userid = ?',
          [imagePath, userid],
        );
      } else {
        await conn.query(
          'INSERT INTTO images (userid, ImagePath) VALUES (?, ?)',
          [userid, imagePath],
        );
      }
    } finally {
      await conn?.close();
    }
  }

  Future<String?> getImagePathFromDatabase(int userid) async {
    MySqlConnection? conn;
    try {
      conn = await userController.connectToDatabase();
      var result = await conn.query(
        'SELECT ImagePath FROM image WHERE userid = ?',
        [userid],
      );
      if (result.isNotEmpty) {
        dynamic imagePathData = result.first['ImagePath'];
        print('Image Path from Database: $imagePathData');

        if (imagePathData is String) {
          return imagePathData;
        } else if (imagePathData is Uint8List) {
          return String.fromCharCodes(imagePathData);
        }
      }
      return null;
    } finally {
      await conn?.close();
    }
  }

  void _showImageSelectionDialog(int userid) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Select Profile Picture'),
            content: Column(
              children: [
                InkWell(
                  onTap: () async {
                    String imagePath =
                        'https://imgs.search.brave.com/tlyPsC6OLW55UILIs8lQRcWAMhZUUIsz_y9OfiS0rQQ/rs:fit:500:0:0/g:ce/aHR0cHM6Ly9pY29u/LWxpYnJhcnkuY29t/L2ltYWdlcy91c2Vy/LWljb24tanBnL3Vz/ZXItaWNvbi1qcGct/Ni5qcGc';
                    await saveImagePathInDatabase(userid, imagePath);
                    setState(() {
                      selectedImagePath = imagePath;
                    });
                    Navigator.pop(context);
                  },
                  child: Image.network(
                    'https://imgs.search.brave.com/tlyPsC6OLW55UILIs8lQRcWAMhZUUIsz_y9OfiS0rQQ/rs:fit:500:0:0/g:ce/aHR0cHM6Ly9pY29u/LWxpYnJhcnkuY29t/L2ltYWdlcy91c2Vy/LWljb24tanBnL3Vz/ZXItaWNvbi1qcGct/Ni5qcGc',
                    width: 80,
                    height: 80,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () async {
                    String imagePath =
                        'https://imgs.search.brave.com/rWrtL3aZnYQ4Qbcl7gA9i3T_dQmhq2Oe996b7XdUWxE/rs:fit:500:0:0/g:ce/aHR0cHM6Ly9hc3Nl/dHMuc3RpY2twbmcu/Y29tL2ltYWdlcy81/ODVlNGJkN2NiMTFi/MjI3NDkxYzMzOTcu/cG5n';
                    await saveImagePathInDatabase(userid, imagePath);
                    setState(() {
                      selectedImagePath = imagePath;
                    });
                    Navigator.pop(context);
                  },
                  child: Image.network(
                    'https://imgs.search.brave.com/rWrtL3aZnYQ4Qbcl7gA9i3T_dQmhq2Oe996b7XdUWxE/rs:fit:500:0:0/g:ce/aHR0cHM6Ly9hc3Nl/dHMuc3RpY2twbmcu/Y29tL2ltYWdlcy81/ODVlNGJkN2NiMTFi/MjI3NDkxYzMzOTcu/cG5n',
                    width: 80,
                    height: 80,
                  ),
                )
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GetBuilder<UserController>(
        init: userController,
        builder: (userController) {
          final User? user = userController.user.value;
          if (user == null) {
            return Scaffold(
              appBar: AppBar(
                title: Text(
                  'Profile',
                  style: GoogleFonts.aBeeZee(),
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.to(const SignIn());
                      },
                      child: Container(
                        width: 200,
                        height: 40,
                        margin: const EdgeInsets.only(left: 20, right: 20),
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Text(
                            'Sign In',
                            style: GoogleFonts.aBeeZee(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Please login to view your profile',
                      style: GoogleFonts.aBeeZee(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Scaffold(
              body: GetBuilder<UserController>(
                  init: userController,
                  builder: (userController) {
                    return Padding(
                      padding: const EdgeInsets.all(16),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    _showImageSelectionDialog(
                                        userController.user.value!.id ?? 0);
                                  },
                                  child: ProfilePicture(
                                    imagePath: selectedImagePath,
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      user.sinceMember != null
                                          ? DateFormat('dd MM yyyy').format(
                                              DateTime.parse(user.sinceMember!),
                                            )
                                          : '',
                                      style: const TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    SizedBox(
                                      width: 160,
                                      child: Text(
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        user.email,
                                        style: GoogleFonts.aBeeZee(
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                SizedBox(
                                  width: 160,
                                  child: Text(
                                    user.name,
                                    style: GoogleFonts.aBeeZee(
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    userController.logOut();

                                    Get.to(const SignIn());
                                  },
                                  child: Text(
                                    'Logout',
                                    style: GoogleFonts.aBeeZee(),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  }),
            );
          }
        },
      ),
    );
  }
}

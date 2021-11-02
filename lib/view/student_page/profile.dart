import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutor_helper/api/api_management.dart';
import 'package:tutor_helper/model/students.dart';
import 'package:tutor_helper/view/login_screen.dart';

class StudentEditProfile extends StatefulWidget {
  const StudentEditProfile({Key? key}) : super(key: key);

  @override
  _StudentEditProfileState createState() => _StudentEditProfileState();
}

class _StudentEditProfileState extends State<StudentEditProfile> {
  String image = "";
  String tokenHome = "";
  int studentId = 0;
  String email = "";

  var _name = "";
  var _phone = "";

  final nameController = TextEditingController();
  final phoneController = TextEditingController();

  var dataFromHome = Get.arguments;
  final storage = const FlutterSecureStorage();
  void _logOut() async {
    return await storage.deleteAll();
  }

  Future<String?> _getData() async {
    return await storage.read(key: "database");
  }

  //String imageLink = "assets/images/default_avatar.png";

  _loadImage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      image = prefs.getString("imagePath") ?? "";
      studentId = prefs.getInt("studentId") ?? 0;
      tokenHome = prefs.getString("token") ?? "";
      email = prefs.getString("email") ?? "";
    });
  }

  @override
  initState() {
    super.initState();
    _loadImage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        title: const Text("My profile"),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.black),
            onPressed: () {
              _logOut();
              Get.offAll(() => const LoginPage());
            },
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 16, top: 25, right: 16),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            children: [
              const SizedBox(
                height: 15,
              ),
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 4,
                              color: Theme.of(context).scaffoldBackgroundColor),
                          boxShadow: [
                            BoxShadow(
                                spreadRadius: 2,
                                blurRadius: 10,
                                color: Colors.black.withOpacity(0.1),
                                offset: const Offset(0, 10))
                          ],
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              fit: BoxFit.cover, image: NetworkImage(image))),
                    ),
                  ],
                ),
              ),

              FutureBuilder<String?>(
                  future: _getData(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var data = jsonDecode(snapshot.data.toString());
                      int studentId = data['data']['studentId'];
                      String token = data['data']['jwtToken'];
                      //tokenHome = token;
                      //print(image);
                      return FutureBuilder<Student>(
                          future:
                              API_Management().getStdentById(token, studentId),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              var email = data['data']['email'];
                              var name = snapshot.data!.data.fullName;
                              var phone = snapshot.data!.data.phoneNumber;
                              //var createAt = snapshot.data!.data.createAt;
                              return Column(
                                children: [
                                  buildTextFieldDisable(
                                      "Id", studentId.toString()),
                                  buildTextFieldDisable("Email", email),
                                  buildTextField("Name", name, nameController),
                                  buildTextField(
                                      "Phone", phone, phoneController),
                                  //buildTextFieldDisable("Create at", createAt),
                                ],
                              );
                            } else {
                              return Container();
                            }
                          });
                    } else {
                      return Container();
                    }
                  }),
              // buildTextField("Phone", phoneNumber),
              const SizedBox(
                height: 35,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // ignore: deprecated_member_use
                  OutlineButton(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("CANCEL",
                        style: TextStyle(
                            fontSize: 14,
                            letterSpacing: 2.2,
                            color: Colors.black)),
                  ),
                  // ignore: deprecated_member_use
                  RaisedButton(
                    onPressed: () {
                      //Save xuống database
                      setState(() {
                        _name = nameController.text;
                        _phone = phoneController.text;
                      });

                      API_Management().updateStudent(
                          studentId, email, _name, _phone, 2, 2, image, tokenHome);
                      Fluttertoast.showToast(
                          msg: "Account has been updated",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.blueGrey,
                          textColor: Colors.white,
                          fontSize: 16.0);
                      return Navigator.pop(context);
                      //Get.to(const StudentEditProfile());
                    },
                    color: Colors.blue[500],
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: const Text(
                      "SAVE",
                      style: TextStyle(
                          fontSize: 14,
                          letterSpacing: 2.2,
                          color: Colors.white),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(
      String labelText, String placeholder, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.only(bottom: 3),
            labelText: labelText,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: placeholder,
            hintStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            )),
      ),
    );
  }

  Widget buildTextFieldDisable(String labelText, String placeholder) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: TextField(
        decoration: InputDecoration(
            enabled: false,
            contentPadding: const EdgeInsets.only(bottom: 3),
            labelText: labelText,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: placeholder,
            hintStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            )),
      ),
    );
  }
}

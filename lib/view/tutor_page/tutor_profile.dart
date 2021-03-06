import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tutor_helper/api/api_management.dart';
import 'package:tutor_helper/model/tutor_courses.dart';

class TutorProfilePage extends StatefulWidget {
  const TutorProfilePage({Key? key}) : super(key: key);

  @override
  _TutorProfilePageState createState() => _TutorProfilePageState();
}

class _TutorProfilePageState extends State<TutorProfilePage> {
  String username = "";
  String email = "";
  String phone = "";
  String image = "";
  int tutorId = 0;
  String token = "";

  final storage = const FlutterSecureStorage();

  Future<String?> _getData() async {
    return await storage.read(key: "database");
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("View Profile"),
        backgroundColor: const Color(0XFF263064),
        elevation: 1,
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            FutureBuilder<String?>(
              future: _getData(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var data = jsonDecode(snapshot.data.toString());
                  var imagePath = data["data"]['imagePath'].toString();
                  return FutureBuilder<TutorCourses>(
                    future: API_Management().getTutorByTutorID(
                        data["data"]['jwtToken'], data["data"]['tutorId']),
                    builder: (context, tutorData) {
                      if (tutorData.hasData) {
                        email = data["data"]['email'];
                        username = tutorData.data!.data.fullName;
                        phone = tutorData.data!.data.phoneNumber;
                        image = imagePath;
                        token = data["data"]['jwtToken'];
                        tutorId = data["data"]['tutorId'];

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              // margin: const EdgeInsets.only(bottom: 7),
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 5),
                              color: Colors.white,
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                children: [
                                  Container(
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      color: const Color(0xff7c94b6),
                                      image: DecorationImage(
                                        image: NetworkImage(imagePath),
                                        fit: BoxFit.cover,
                                      ),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(50.0)),
                                      border: Border.all(
                                        color: Colors.cyan,
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    username,
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(bottom: 7),
                              padding:
                                  const EdgeInsets.fromLTRB(20, 15, 10, 15),
                              color: Colors.white,
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Email",
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w900),
                                  ),
                                  TextFormField(
                                    keyboardType: TextInputType.emailAddress,
                                    enabled: false,
                                    initialValue: email,
                                    onChanged: (value) {
                                      setState(() {
                                        email = value;
                                      });
                                    },
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Text(
                                    "Username",
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w900),
                                  ),
                                  // TextFormField(
                                  //   keyboardType: TextInputType.name,
                                  //   initialValue: username,
                                  //   onChanged: (value) {
                                  //     setState(() {
                                  //       username = value;
                                  //     });
                                  //   },
                                  // ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Text(
                                    "Phone number",
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w900),
                                  ),
                                  TextFormField(
                                    keyboardType: TextInputType.phone,
                                    initialValue: phone,
                                    onChanged: (value) {
                                      phone = value;
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      } else {
                        return const Visibility(
                          child: Text(""),
                          visible: false,
                        );
                      }
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                } else {
                  return const Text("");
                }
              },
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () {
                  // log(imagePath);
                  // API_Management().updateTutor(
                  //     token, username, email, phone, image, tutorId);
                },
                child: const Text(
                  "Update",
                  style: TextStyle(fontSize: 25),
                ))
          ],
        ),
      ),
    );
  }
}

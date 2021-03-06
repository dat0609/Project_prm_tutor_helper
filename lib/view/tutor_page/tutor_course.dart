import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:tutor_helper/api/api_management.dart';
import 'package:tutor_helper/model/tutor_courses.dart';
import 'package:tutor_helper/presenter/date_time_format.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:tutor_helper/view/tutor_page/tutor_view_course_detail.dart';
import 'package:url_launcher/url_launcher.dart';

class TutorCoursePage extends StatefulWidget {
  const TutorCoursePage({Key? key}) : super(key: key);

  @override
  _TutorCoursePageState createState() => _TutorCoursePageState();
}

class _TutorCoursePageState extends State<TutorCoursePage> {
  String imageLink = "assets/images/default_avatar.png";
  final DateTime now = DateTime.now();
  DateTimeTutor dt = DateTimeTutor();
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
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        child: Stack(children: [
          _upper(),
          _under(),
        ]),
      ),
    );
  }

  Container _upper() {
    initializeDateFormatting('vi', null);
    final DateTime now = DateTime.now();
    DateTimeTutor dtt = DateTimeTutor();
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [
                Color(0xFFD4E7FE),
                Color(0xFFD4E7FE),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.6, 0.3])),
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 60),
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerRight,
            child: RichText(
              text: TextSpan(
                  text: dtt.dateOfWeekFormat.format(now),
                  style: const TextStyle(
                      color: Color(0XFF263064),
                      fontSize: 12,
                      fontWeight: FontWeight.w900),
                  children: [
                    TextSpan(
                      text: " " + dtt.dateFormat.format(now),
                      style: const TextStyle(
                          color: Color(0XFF263064),
                          fontSize: 12,
                          fontWeight: FontWeight.normal),
                    )
                  ]),
            ),
          ),
          FutureBuilder<String?>(
            future: _getData(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var data = jsonDecode(snapshot.data.toString());

                return FutureBuilder<TutorCourses>(
                    future: API_Management().getTutorByTutorID(
                        data["data"]["jwtToken"], data["data"]["tutorId"]),
                    builder: (context, tutorData) {
                      if (tutorData.hasData) {
                        String username = tutorData.data!.data.fullName;
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  border:
                                      Border.all(width: 1, color: Colors.white),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.blueGrey.withOpacity(0.2),
                                      blurRadius: 12,
                                      spreadRadius: 8,
                                    )
                                  ],
                                ),
                                child: GestureDetector(
                                  child: CircleAvatar(
                                    backgroundColor: Colors.black,
                                    radius: 10,
                                    child: ClipOval(
                                      child: Image.network(
                                        data["data"]["imagePath"],
                                        fit: BoxFit.cover,
                                        width: 200,
                                        height: 200,
                                      ),
                                    ),
                                  ),
                                  onTap: () {},
                                )),
                            const SizedBox(
                              width: 20,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width - 120,
                                  child: Text(
                                    "Hi $username",
                                    style: const TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.w900,
                                      color: Color(0XFF343E87),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        );
                      } else {
                        return const Text("");
                      }
                    });
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              } else {
                return const Text("");
              }
            },
          ),
        ],
      ),
    );
  }

  Container _under() {
    return Container(
      margin: const EdgeInsets.only(top: 140),
      padding: const EdgeInsets.fromLTRB(20, 20, 5, 0),
      height: MediaQuery.of(context).size.height - 200,
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        color: Colors.white,
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFD4E7FE), Colors.cyan]),
        // borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Your Courses",
            style: TextStyle(
                fontSize: 20, color: Colors.black, fontWeight: FontWeight.w600),
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: FutureBuilder<String?>(
              future: _getData(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var data = jsonDecode(snapshot.data.toString());
                  int tutorID = data["data"]["tutorId"];
                  return FutureBuilder<TutorCourses>(
                    future: API_Management()
                        .getTutorByTutorID(data["data"]['jwtToken'], tutorID),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        var tutorCourse = snapshot.data!.data.courses;
                        return ListView.builder(
                            itemCount: tutorCourse.length,
                            itemBuilder: (context, index) {
                              var courseData =
                                  snapshot.data!.data.courses[index];
                              if (courseData.status == true) {
                                return buildClassItem(
                                    courseData.title,
                                    courseData.description,
                                    courseData.courseId,
                                    courseData.tutorId,
                                    courseData.tutorRequestId,
                                    courseData.studentId,
                                    data["data"]['jwtToken']);
                              } else {
                                return const Visibility(
                                  child: Text("data"),
                                  visible: false,
                                );
                              }
                            });
                      } else if (snapshot.hasError) {
                        return const Text("");
                      } else {
                        return const Text("");
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
          )
        ],
      ),
    );
  }

  Container buildClassItem(String title, String description, int courseId,
      int tutorId, int tutorRequestId, int studentId, String token) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15, right: 7, left: 5),
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 20),
      height: 150,
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9FB),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 5, // changes position of shadow
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width - 120,
                child: Text(
                  title.trim(), //Subject Name
                  overflow: TextOverflow.clip,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width - 120,
                child: Text(
                  description.trim(), //Address
                  overflow: TextOverflow.clip,
                  style: const TextStyle(color: Colors.black, fontSize: 13),
                ),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: () {
                  Get.to(() => const TutorViewCourseDetail(), arguments: {
                    "title": title,
                    "description": description,
                    "courseid": courseId,
                    "tutorid": tutorId,
                    "tutorrequestid": tutorRequestId,
                    "studentid": studentId,
                    "token": token,
                  });
                },
                icon: const Icon(Icons.arrow_right_alt_rounded),
              ),
              IconButton(
                onPressed: () {
                  //API_Management().updateCourse();
                  _showModal(token, courseId, title, description, tutorId,
                      tutorRequestId, studentId);
                },
                icon: const Icon(Icons.link_rounded),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showModal(var token, int courseId, String title, String description,
      int tutorId, int tutorRequestId, int studentId) {
    var linkUrl = "";
    showMaterialModalBottomSheet(
        backgroundColor: Colors.blueGrey,
        context: context,
        builder: (context) {
          return Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Share this link to your students",
                style: TextStyle(fontSize: 20),
              ),
              TextField(
                decoration: const InputDecoration(
                  hintText: "Enter Link",
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    linkUrl = value;
                  });
                },
              ),
              IconButton(
                  onPressed: () {
                    var uri = Uri.dataFromString('https://meet.google.com');
                    var uuid = uri.path;

                    var realPath = uuid.substring(1);
                    //log(realPath);
                    launch(realPath);
                  },
                  icon: const Icon(Icons.meeting_room_outlined)),
              TextButton(
                  onPressed: () {
                    if (linkUrl.isEmpty) {
                      Get.snackbar("Error", "Please enter a link",
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                          snackPosition: SnackPosition.BOTTOM);
                    } else if (!linkUrl.startsWith("https://")) {
                      Get.snackbar("Error", "Please enter a valid link",
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                          snackPosition: SnackPosition.BOTTOM);
                    } else {
                      API_Management().updateCourse(
                          token,
                          courseId,
                          title,
                          description,
                          linkUrl,
                          tutorId,
                          tutorRequestId,
                          studentId);
                      Fluttertoast.showToast(
                          msg: "Create meet link success",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.blueGrey,
                          textColor: Colors.white,
                          fontSize: 16.0);
                      Get.back();
                    }
                  },
                  child: const Text("Create",
                      style: TextStyle(color: Colors.black))),
            ],
          ));
        });
  }
}

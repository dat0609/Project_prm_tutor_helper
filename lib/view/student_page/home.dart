import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:tutor_helper/model/courses.dart';
import 'package:tutor_helper/model/tutor_courses.dart';
import 'package:tutor_helper/presenter/date_time_format.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:tutor_helper/view/student_page/profile.dart';
import 'package:tutor_helper/view/student_page/view_course_detail.dart';
import 'package:tutor_helper/api/api_management.dart';
import 'package:url_launcher/url_launcher.dart';

class StudentHomePage extends StatefulWidget {
  const StudentHomePage({Key? key}) : super(key: key);

  @override
  _StudentHomePageState createState() => _StudentHomePageState();
}

class _StudentHomePageState extends State<StudentHomePage> {
  final storage = const FlutterSecureStorage();

  Future<String?> _getData() async {
    return await storage.read(key: "database");
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [_upper(), _under()]);
  }

  Container _upper() {
    initializeDateFormatting('vi', null);
    final DateTime now = DateTime.now();
    DateTimeTutor dtt = DateTimeTutor();
    return Container(
      decoration: const BoxDecoration(
          //color: Color(0xFFD4E7FE),
          gradient: LinearGradient(
              colors: [
                Color(0xFFD4E7FE),
                Color(0xFFF0F0F0),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.6, 0.3])),
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
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
          const SizedBox(
            height: 15,
          ),
          FutureBuilder<String?>(
            future: _getData(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var data = jsonDecode(snapshot.data.toString());
                var email = data["data"]["email"].toString().split("@");
                String username = email[0];
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(width: 1, color: Colors.white),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blueGrey.withOpacity(0.2),
                              blurRadius: 12,
                              spreadRadius: 8,
                            )
                          ],
                        ),
                        child: GestureDetector(
                          child: Image.network(
                            data["data"]["imagePath"],
                            fit: BoxFit.fill,
                            width: 50,
                            height: 50,
                          ),
                          onTap: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //       builder: (context) =>
                            //           const TutorEditProfilePage()),
                            // );
                            Get.to(const StudentEditProfile());
                          },
                        )),
                    const SizedBox(
                      width: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hi $username",
                          style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w900,
                            color: Color(0XFF343E87),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          "Here is all your course!!",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.blueGrey,
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        const Text(
                          "You need to attention...",
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.blueGrey,
                          ),
                        ),
                      ],
                    )
                  ],
                );
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

  Positioned _under() {
    return Positioned(
        top: 185,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              height: MediaQuery.of(context).size.height - 245,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: FutureBuilder<String?>(
                future: _getData(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var data = jsonDecode(snapshot.data.toString());
                    int studentId = data['data']['studentId'];
                    String token = data['data']['jwtToken'];
                    return FutureBuilder<Course>(
                      future: API_Management()
                          .getCourseByStudentId(token, studentId),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          var studentCourse = snapshot.data!.data;
                          return ListView.builder(
                              itemCount: studentCourse.length,
                              itemBuilder: (context, index) {
                                var course = snapshot.data!.data[index];
                                // log(studentId.toString());
                                if (course.status == true) {
                                  return FutureBuilder<TutorCourses>(
                                      future: API_Management()
                                          .getCoursesByTutorID(
                                              token, course.tutorId),
                                      builder: (context, snapshot) {
                                        var tutor = snapshot.data?.data;
                                        if (snapshot.hasData) {
                                          return Card(
                                            elevation: 5,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15)),
                                            child: ListTile(
                                              leading: TextButton(
                                                  onPressed: () {
                                                    var baseUrl =
                                                        course.linkUrl;
                                                    if (!baseUrl
                                                        .contains("https:/")) {
                                                      var meetUrl = "https://" +
                                                          course.linkUrl;
                                                      var uri =
                                                          Uri.dataFromString(
                                                              meetUrl);
                                                      var uuid = uri.path;

                                                      var realPath =
                                                          uuid.substring(1);

                                                      launch(realPath);
                                                    }
                                                  },
                                                  child: const Text("Meet")),
                                              title: Text(course.title),
                                              subtitle:
                                                  Text(course.description),
                                              trailing: Text(tutor!.fullName),
                                              onTap: () {
                                                Get.to(
                                                    () =>
                                                        const StudentViewCourseDetail(),
                                                    arguments: {
                                                      "course": course,
                                                      "studentId": studentId,
                                                      "token": token,
                                                      "courseId":
                                                          course.courseId,
                                                      "courseTitle":
                                                          course.title,
                                                      "tutorId": tutor.tutorId,
                                                      "tutor": tutor,
                                                    });
                                              },
                                            ),
                                          );
                                        } else if (snapshot.hasError) {
                                          return Text('${snapshot.error}');
                                        } else {
                                          return const Text("");
                                        }
                                      });
                                } else {
                                  return Container();
                                }
                              });
                        } else if (snapshot.hasError) {
                          return const Text("");
                        } else {
                          return const Center(
                              child: CircularProgressIndicator());
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
            ),
          ],
        ));
  }
}

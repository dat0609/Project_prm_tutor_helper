import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:tutor_helper/api/api_management.dart';
import 'package:tutor_helper/model/classes.dart';
import 'package:tutor_helper/model/tutor_courses.dart';
// ignore: library_prefixes
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

class StudentViewCourseDetail extends StatefulWidget {
  const StudentViewCourseDetail({Key? key}) : super(key: key);

  @override
  _StudentViewCourseDetailState createState() =>
      _StudentViewCourseDetailState();
}

class _StudentViewCourseDetailState extends State<StudentViewCourseDetail> {
  // ignore: non_constant_identifier_names
  var corse_from_home = Get.arguments;
  final storage = const FlutterSecureStorage();

  DateTime convertDateFromString(String strDate) {
    return DateTime.parse(strDate);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int courseId = corse_from_home["courseId"];
    var token = corse_from_home["token"];
    String courseName = corse_from_home["courseTitle"];
    var tutorId = corse_from_home["tutorId"];
    DateTime date = DateTime.now();

    void _showSheetModal() {
      showModalBottomSheet(
          elevation: 10,
          context: context,
          builder: (context) {
            return FutureBuilder<TutorCourses>(
                future: API_Management().getTutorByTutorID(token, tutorId),
                builder: (context, snapshot) {
                  var tutor = snapshot.data?.data;
                  if (snapshot.hasData) {
                    return Center(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Center(
                          child: Text(
                            "Tutor Information",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Image.network(tutor!.imagePath),
                        const SizedBox(height: 10),
                        Text(tutor.fullName),
                        const SizedBox(height: 10),
                        Text(tutor.email),
                        const SizedBox(height: 10),
                        TextButton(
                            onPressed: () {
                              UrlLauncher.launch('tel:+${tutor.phoneNumber}');
                            },
                            child: const Text("Call")),
                        TextButton(
                            onPressed: () {
                              UrlLauncher.launch('mailto:${tutor.email}');
                            },
                            child: const Text("Mail for tutor"))
                      ],
                    ));
                  } else {
                    return Container();
                  }
                });
          });
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(courseName),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.info),
              onPressed: () {
                _showSheetModal();
              },
            )
          ],
        ),
        body: FutureBuilder<Classes>(
          future: API_Management().getAllClass(token),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var data = snapshot.data;
              return ListView.builder(
                  itemCount: snapshot.data!.data.length,
                  itemBuilder: (context, index) {
                    var startTime =
                        convertDateFromString(data!.data[index].startTime);
                    if (data.data[index].courseId == courseId) {
                      var start = data.data[index].startTime.split("T");
                      var endTime = data.data[index].endTime.split("T");
                      return ListTile(
                        title: Text(data.data[index].title),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(start[0] + " " + start[1]),
                            Text(endTime[0] + " " + endTime[1]),
                          ],
                        ),
                        trailing:
                            Text(startTime.isAfter(date) ? "" : "Out of date"),
                        leading: Text(
                            data.data[index].status ? "Progress" : "Cancel"),
                        onTap: () {
                          //launch("https://meet.google.com/esk-brwa-bzi");
                        },
                      );
                    } else {
                      return Container();
                    }
                  });
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ));
  }
}

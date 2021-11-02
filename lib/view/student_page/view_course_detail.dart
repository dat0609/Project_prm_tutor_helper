import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:tutor_helper/api/api_management.dart';
import 'package:tutor_helper/model/classes.dart';

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
    DateTime date = DateTime.now();

    return Scaffold(
        appBar: AppBar(
          title: Text(courseName),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {},
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
                      return ListTile(
                        title: Text(data.data[index].title),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(data.data[index].startTime),
                            Text(data.data[index].endTime),
                          ],
                        ),
                        trailing:
                            Text(startTime.isAfter(date) ? "" : "Out of date"),
                        leading: Text(
                            data.data[index].status ? "Progress" : "Cancel"),
                        onTap: () {},
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

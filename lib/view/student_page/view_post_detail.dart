import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:tutor_helper/api/api_management.dart';

class StudentViewPostDetail extends StatefulWidget {
  const StudentViewPostDetail({Key? key}) : super(key: key);

  @override
  _StudentViewPostDetailState createState() => _StudentViewPostDetailState();
}

class _StudentViewPostDetailState extends State<StudentViewPostDetail> {
  var datafromPost = Get.arguments;
  final storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [_navigator(), _upper()],
    );
  }

  AppBar _navigator() {
    var token = datafromPost["token"];
    var postId = datafromPost["postId"];
    var title = datafromPost["title"];
    var description = datafromPost["description"];
    var studentId = datafromPost["studentId"];
    var subjectId = datafromPost["subjectId"];
    var gradeId = datafromPost["gradeId"];
    var status = datafromPost["status"];

    return AppBar(
      title: Text(datafromPost["title"]),
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            if (status == "Pending") {
              API_Management().deletePost(token, postId, title, description,
                  studentId, gradeId, subjectId);

              Get.back();
            }
          },
        )
      ],
    );
  }

  Container _upper() {
    return Container(
      margin: const EdgeInsets.only(top: 75),
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
      height: 800,
      width: 500,
      decoration: const BoxDecoration(
        color: Color(0xFFF9F9FB),
      ),
      child: Scaffold(
        body: Column(
          children: <Widget>[
            listItem("Title:", datafromPost["title"]),
            const SizedBox(height: 10),
            listItem("Des:", datafromPost["description"]),
            const SizedBox(height: 10),
            listItem("Status:", datafromPost["status"]),
            const SizedBox(height: 10),
            //listItem("Create at:", datafromPost["create"]),
            const SizedBox(height: 50),
            ElevatedButton(onPressed: () {}, child: const Text("Edit")),
          ],
        ),
      ),
    );
  }

  Material listItem(String left, String right) {
    return Material(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            left,
            style: const TextStyle(
                fontSize: 15, color: Colors.black, fontWeight: FontWeight.w900),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width - 135,
            child: Text(
              right.trim(), //Address
              overflow: TextOverflow.clip,
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.w400),
            ),
          ),
        ],
      ),
    );
  }
}

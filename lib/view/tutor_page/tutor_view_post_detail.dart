import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:tutor_helper/api/api_management.dart';
import 'package:tutor_helper/view/tutor_page/tutor_management.dart';

class TutorViewPostDetail extends StatefulWidget {
  const TutorViewPostDetail({Key? key}) : super(key: key);

  @override
  _TutorViewPostDetailState createState() => _TutorViewPostDetailState();
}

class _TutorViewPostDetailState extends State<TutorViewPostDetail> {
  var datafromPost = Get.arguments;
  final storage = const FlutterSecureStorage();
  int tutorRequestIDGotten = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      _navigator(),
      _upper(),
    ]);
  }

  Container _upper() {
    tutorRequestIDGotten = datafromPost["tutorRequestID"];
    return Container(
      margin: const EdgeInsets.only(top: 75),
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
      height: 800,
      width: 500,
      decoration: const BoxDecoration(
        color: Color(0xFFF9F9FB),
      ),
      child: Column(
        children: [
          // listItem("Student:", datafromPost),
          const SizedBox(
            height: 10,
          ),
          listItem("Title:", datafromPost["title"]),
          const SizedBox(
            height: 10,
          ),
          listItem("Desc:", datafromPost["description"]),
          const SizedBox(
            height: 10,
          ),
          listItem("Student Id:", datafromPost["studentId"].toString()),
          const SizedBox(
            height: 10,
          ),
          const SizedBox(height: 10),
          listItem("Grade", datafromPost["gradeName"]),
          const SizedBox(height: 10),
          listItem("Subject:", datafromPost["subjectName"]),
          const SizedBox(height: 100),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                  onPressed: () {
                    showAlertDialog(context);
                  },
                  child: const Text(
                    "Accept",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.fromLTRB(40, 20, 40, 20),
                    backgroundColor: Colors.green[700],
                    textStyle: const TextStyle(fontSize: 20),
                  )),
            ],
          ),
        ],
      ),
    );
  }

  AppBar _navigator() {
    return AppBar(
      title: Text(datafromPost["title"]),
      actions: const <Widget>[],
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

  showAlertDialog(BuildContext context) {
    Widget okButton = TextButton(
      child: const Text("OK"),
      onPressed: () {
        Get.offAll(() => const TutorManagement());
      },
    );
    Widget cancelButton = TextButton(
      child: const Text("Cancel"),
      onPressed: () {
        Get.back();
      },
    );
    AlertDialog secondAlert = AlertDialog(
      title: const Text("Thank you!"),
      content: const Text("The request has been accepted!!!"),
      actions: [
        okButton,
      ],
    );
    Widget acceptButton = TextButton(
      child: const Text("Accept"),
      onPressed: () {
        log(datafromPost["gradeId"].toString());
        API_Management().acceptTutorRequest(
            datafromPost["token"],
            datafromPost["tutorId"],
            datafromPost["tutorRequestID"],
            datafromPost["studentId"],
            datafromPost["gradeId"],
            datafromPost["title"],
            datafromPost["description"],
            datafromPost["subjectId"]);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return secondAlert;
          },
        );
      },
    );
    AlertDialog firstAlert = AlertDialog(
      title: const Text("Attention!"),
      content: const Text("Are you sure you want to accept the request?"),
      actions: [
        cancelButton,
        acceptButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return firstAlert;
      },
    );
  }
}

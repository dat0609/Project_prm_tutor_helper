import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

class TutorInfoPage extends StatefulWidget {
  const TutorInfoPage({Key? key}) : super(key: key);

  @override
  _TutorInfoPageState createState() => _TutorInfoPageState();
}

class _TutorInfoPageState extends State<TutorInfoPage> {
  // ignore: non_constant_identifier_names
  var data_from_home_page = Get.arguments;
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
    return AppBar(
      title: const Text("Tutor Infomation"),
      actions: const <Widget>[],
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
            Image.network(data_from_home_page["image"]),
            const SizedBox(
              height: 10,
            ),
            listItem("ID: ", data_from_home_page["tutorid"]),
            listItem("Email: ", data_from_home_page["title"]),
            listItem("Full name:", data_from_home_page["description"]),
            listItem("Phone:", data_from_home_page["phone"]),
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

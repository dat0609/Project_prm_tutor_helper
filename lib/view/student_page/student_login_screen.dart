import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutor_helper/constants/strings.dart';
import 'package:tutor_helper/view/student_page/student_management.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as https;

class StudentLoginPage extends StatefulWidget {
  const StudentLoginPage({Key? key}) : super(key: key);

  @override
  _StudentLoginPageState createState() => _StudentLoginPageState();
}

class _StudentLoginPageState extends State<StudentLoginPage> {
  final storage = const FlutterSecureStorage();
  void _loginWithGoogle() async {
    setState(() {});
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;
    final OAuthCredential googleCredential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    await FirebaseAuth.instance.signInWithCredential(googleCredential);
    final tokenResult =
        await FirebaseAuth.instance.currentUser!.getIdToken(true);

    Map<String, String> headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      "idToken": tokenResult,
      "role": "Student",
      "accessToken": "string",
      "providerId": "string",
      "signInMethod": "Google"
    });
    final response = await https.post(Uri.parse(Strings.student_signin_url),
        headers: headers, body: body);

    if (response.statusCode == 200) {
      final prefs = await SharedPreferences.getInstance();

      final data = jsonDecode(response.body);

      final imagePath = data["data"]["imagePath"];
      final studentId = data["data"]["studentId"];
      final token = data["data"]["jwtToken"];
      final email = data["data"]["email"];

      prefs.setString("imagePath", imagePath);
      prefs.setInt("studentId", studentId);
      prefs.setString("token", token);
      prefs.setString("email", email);

      storage.write(key: "database", value: response.body);
      Get.offAll(() => const StudentManagement());
    } else {
      Alert(
          context: context,
          type: AlertType.error,
          title: "Wrong Role!",
          desc: "You have login to wrong role!",
          buttons: [
            DialogButton(
              child: const Text(
                "Change Role",
              ),
              onPressed: () {
                Get.back();
                Get.back();
              },
            )
          ]).show();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(
                    "https://shopme-stored.s3.ap-southeast-1.amazonaws.com/login.png"),
                fit: BoxFit.cover)),
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      "Hello student,Let's Login to your account",
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.w800),
                    ),
                    SignInButton(
                      Buttons.Google,
                      onPressed: () {
                        setState(() {});
                        _loginWithGoogle();
                      },
                    )
                  ],
                ),
              ],
            ))
          ],
        ),
      ),
    );
  }
}

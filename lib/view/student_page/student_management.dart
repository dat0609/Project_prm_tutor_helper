import 'package:flutter/material.dart';
import 'package:tutor_helper/view/student_page/create_post.dart';
import 'package:tutor_helper/view/student_page/home.dart';
import 'package:tutor_helper/view/student_page/view_post.dart';
import 'package:tutor_helper/view/student_page/view_tutor.dart';

class StudentManagement extends StatefulWidget {
  const StudentManagement({Key? key}) : super(key: key);

  @override
  _StudentManagementState createState() => _StudentManagementState();
}

class _StudentManagementState extends State<StudentManagement> {
  int _selectedItemIndex = 0;
  @override
  Widget build(BuildContext context) {
    List pages = [
      const StudentHomePage(),
      const ViewTutorPage(),
      const TutorViewPost(),
      const CreatePostPage(),
    ];
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          bottomNavigationBar: BottomNavigationBar(
            elevation: 0,
            backgroundColor: const Color(0xFFF0F0F0),
            unselectedItemColor: Colors.grey,
            selectedItemColor: Colors.black,
            selectedIconTheme: IconThemeData(color: Colors.blueGrey[600]),
            currentIndex: _selectedItemIndex,
            type: BottomNavigationBarType.fixed,
            onTap: (int index) {
              setState(() {
                _selectedItemIndex = index;
              });
            },
            items: const [
              BottomNavigationBarItem(
                // ignore: deprecated_member_use
                title: Text("Home"),
                icon: Icon(Icons.home),
              ),
              BottomNavigationBarItem(
                // ignore: deprecated_member_use
                title: Text("Tutor"),
                icon: Icon(Icons.school),
              ),
              BottomNavigationBarItem(
                // ignore: deprecated_member_use
                title: Text("My Post"),
                icon: Icon(Icons.table_view_rounded),
              ),
              BottomNavigationBarItem(
                // ignore: deprecated_member_use
                title: Text("New Post"),
                icon: Icon(Icons.add),
              ),
            ],
          ),
          body: pages[_selectedItemIndex]),
    );
  }
}

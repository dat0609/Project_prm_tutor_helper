import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tutor_helper/api/api_management.dart';
import 'package:tutor_helper/model/subjects.dart';

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({Key? key}) : super(key: key);

  @override
  _CreatePostPageState createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  var _title = "";
  var _des = "";

  bool _validate = false;

  bool validateInput(String title, String des) {
    if (title.isEmpty) {
      setState(() {
        _validate = true;
      });
      return false;
    }
    if (des.isEmpty) {
      setState(() {
        _validate = true;
      });
      return false;
    }
    return true;
  }

  final storage = const FlutterSecureStorage();

  List<String> listGrades = [
    "Grade 1",
    "Grade 2",
    "Grade 3",
    "Grade 4",
    "Grade 5",
    "Grade 6",
    "Grade 7",
    "Grade 8",
    "Grade 9",
    "Grade 10",
    "Grade 11",
    "Grade 12",
  ];
  List<String> listSubjects = [];
  Map<String, int> mapSubject = {};
  String listGradeItem = "";
  String listSubjectItem = "";
  int gradeId = 0;
  int subjectId = 0;
  int gradeNow = 1;
  int subjectNow = 1;
  bool firstTime = true;
  bool gradeChanged = false;

  final titleController = TextEditingController();
  final subjectController = TextEditingController();
  final desController = TextEditingController();

  void clearText() {
    titleController.clear();
    subjectController.clear();
    desController.clear();
  }

  Future<String?> _getData() async {
    return await storage.read(key: "database");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Create Post'),
        ),
        body: FutureBuilder<String?>(
            future: _getData(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var data = jsonDecode(snapshot.data.toString());
                int studentId = data['data']['studentId'];
                String token = data['data']['jwtToken'];
                return ListView(
                    padding: const EdgeInsets.all(8),
                    children: <Widget>[
                      const ListTile(
                        title: Text('Title'),
                      ),
                      TextField(
                        controller: titleController,
                        decoration: InputDecoration(
                          errorText: _validate ? 'Title is required' : null,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          labelText: 'Input your title',
                        ),
                      ),
                      const ListTile(
                        title: Text('Description'),
                      ),
                      TextField(
                        controller: desController,
                        decoration: InputDecoration(
                          errorText:
                              _validate ? 'This field is required' : null,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          labelText: 'Your requirements about tutor',
                        ),
                        maxLines: 8,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: const [
                          Text("Subject"),
                          SizedBox(
                            width: 50,
                          ),
                          Text("Grade"),
                        ],
                      ),
                      _subjectFieldd(),
                      TextButton(
                          onPressed: () {
                            setState(() {
                              _title = titleController.text;
                              _des = desController.text;
                            });
                            var checked = validateInput(_title, _des);

                            if (checked) {
                              API_Management().createPost(token, _title, _des,
                                  "Pending", studentId, subjectNow, gradeNow);
                              Fluttertoast.showToast(
                                  msg:
                                      "Your request has been successfully sent",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.blueGrey,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            } else {
                              Fluttertoast.showToast(
                                msg: "Please fill all the fields",
                                toastLength: Toast.LENGTH_SHORT,
                              );
                            }

                            clearText();
                            //Get.to(() => const TutorViewPost());
                          },
                          child: const Text('Post',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20))),
                    ]);
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }));
  }

  Row _subjectFieldd() {
    if (firstTime) {
      listGradeItem = listGrades[0].toString();
      gradeChanged = true;
      gradeNow = 1;
      subjectNow = 1;
    }
    return Row(
      children: [
        DropdownButton(
          value: listGradeItem,
          icon: const Icon(Icons.keyboard_arrow_down),
          isDense: true,
          onChanged: (newValue) {
            setState(() {
              listGradeItem = newValue.toString();
              gradeChanged = true;
            });
            var listGradeItemsStr = newValue.toString().split(" ");
            gradeNow = int.parse(listGradeItemsStr[1]);
            gradeId = gradeNow;
          },
          items: listGrades.map((String items) {
            return DropdownMenuItem(value: items, child: Text(items));
          }).toList(),
        ),
        FutureBuilder<String?>(
          future: _getData(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var data = jsonDecode(snapshot.data.toString());
              return FutureBuilder<Subjects>(
                  future: API_Management()
                      .getSubjectByGrade(data["data"]["jwtToken"], gradeNow),
                  builder: (context, subjectData) {
                    if (subjectData.hasData) {
                      var sData = subjectData.data!.data;
                      listSubjects.clear();
                      mapSubject.clear();
                      for (int i = 0; i < sData.length; i++) {
                        listSubjects.add(sData[i].subjectName);
                        mapSubject[sData[i].subjectName] = sData[i].subjectId;
                      }
                      if (gradeChanged) {
                        listSubjectItem = listSubjects[0].toString();
                      }
                      firstTime = false;
                      return DropdownButton(
                        value: listSubjectItem,
                        icon: const Icon(Icons.keyboard_arrow_down),
                        items: listSubjects.map((String items) {
                          return DropdownMenuItem(
                              value: items, child: Text(items));
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            listSubjectItem = newValue.toString();
                            subjectNow = mapSubject[listSubjectItem]!.toInt();
                            gradeChanged = false;
                          });
                        },
                      );
                    } else {
                      return const Visibility(
                        child: Text(""),
                        visible: false,
                      );
                    }
                  });
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            } else {
              return const Text("");
            }
          },
        ),

        // FutureBuilder<Subjects>(
        //     future: API_Management().getSubjects(gradeId),
        //     builder: (context, snapshot) {
        //       if (snapshot.hasData) {
        //         return Expanded(child: ListView.builder(
        //           shrinkWrap: true,
        //           scrollDirection: Axis.vertical,
        //           itemCount: snapshot.data!.data.length,
        //           itemBuilder: (context, snapshot) {

        //           },

        //         ));
        //       }else if (snapshot.hasError) {
        //         return Text("${snapshot.error}");
        //       }
        //     })
      ],
    );
  }
}

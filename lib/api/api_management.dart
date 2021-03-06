import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:tutor_helper/constants/strings.dart';
import 'package:tutor_helper/model/classes.dart';
import 'package:tutor_helper/model/courses.dart';
import 'package:tutor_helper/model/student_courses.dart';
import 'package:tutor_helper/model/students.dart';
import 'package:tutor_helper/model/subjects.dart';
import 'package:tutor_helper/model/tutor_requests.dart';
import 'package:tutor_helper/model/tutor_courses.dart';
import 'package:tutor_helper/model/tutors.dart';

// ignore: camel_case_types
class API_Management {
  // void createCourses(var token, int courseid, String title, String description,
  //     int tutorid, int tutorrequestid, int studentid) async {
  //   Map<String, String> headers = {
  //     'Content-Type': 'application/json',
  //     "Authorization": "Bearer " + token.toString()
  //   };
  //   final body = jsonEncode({
  //     "title": title,
  //     "description": description,
  //     "status": true,
  //     "studentId": studentid,
  //     "tutorId": tutorid,
  //     "tutorRequestId": tutorrequestid
  //   });
  //   var response = await http.get(
  //     Uri.parse(Strings.courses_url),
  //     headers: headers,
  //   );
  // }

  void updateCourse(var token, int courseId, String title, String description,
      String linkUrl, int tutorId, int tutorRequestId, int studentId) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      "Authorization": "Bearer " + token.toString()
    };
    final body = jsonEncode({
      "courseId": courseId,
      "title": title,
      "description": description,
      "linkUrl": linkUrl,
      "status": true,
      "tutorId": tutorId,
      "tutorRequestId": tutorRequestId,
      "studentID": studentId
    });
    http.put(
      Uri.parse(Strings.courses_url),
      headers: headers,
      body: body,
    );
  }

  Future<Subjects> getSubjectByGrade(var token, int gradeId) async {
    var response = await http.get(
      Uri.parse(Strings.get_subject_by_grade_id(gradeId)),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer " + token.toString()
      },
    );
    if (response.statusCode == 200) {
      var jsonString = response.body;
      var jsonMap = json.decode(jsonString);
      return Subjects.fromJson(jsonMap);
    } else {
      throw Exception('Error while get Subjects');
    }
  }

  Future<StudentCourses> getStudentByStudentId(var token, int studentId) async {
    var response = await http.get(
      Uri.parse(Strings.student_get_url(studentId)),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer " + token.toString()
      },
    );
    if (response.statusCode == 200) {
      var jsonString = response.body;
      var jsonMap = json.decode(jsonString);
      return StudentCourses.fromJson(jsonMap);
    } else {
      throw Exception('Error while get Students');
    }
  }

  Future<Classes> getAllClasses(var token) async {
    var response = await http.get(
      Uri.parse(Strings.class_for_calendar_url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer " + token.toString()
      },
    );
    if (response.statusCode == 200) {
      var jsonString = response.body;
      var jsonMap = json.decode(jsonString);
      return Classes.fromJson(jsonMap);
    } else {
      throw Exception('Error while get Classes');
    }
  }

  Future<TutorRequests> getAllTutorRequests(String token) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      "Authorization": "Bearer " + token.toString()
    };
    var response =
        await http.get(Uri.parse(Strings.tutorrequests_url), headers: headers);
    if (response.statusCode == 200) {
      var jsonString = response.body;
      var jsonMap = json.decode(jsonString);
      return TutorRequests.fromJson(jsonMap);
    } else {
      throw Exception('Error while get TutorRequests');
    }
  }

  Future<Student> getStdentById(String token, int id) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      "Authorization": "Bearer " + token.toString()
    };
    var response = await http.get(Uri.parse(Strings.get_student_by_id(id)),
        headers: headers);
    if (response.statusCode == 200) {
      var jsonString = response.body;
      var jsonMap = json.decode(jsonString);
      return Student.fromJson(jsonMap);
    } else {
      throw Exception('Error while get Students');
    }
  }

  void createCourseByRequest(var token, String title, String description,
      int tutorId, int tutorrequestId, int studentId) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      "Authorization": "Bearer " + token.toString()
    };
    final body = jsonEncode({
      "title": title,
      "description": description,
      "linkUrl": "linkUrl",
      "status": true,
      "tutorId": tutorId,
      "tutorRequestId": tutorrequestId,
      "studentId": studentId
    });
    await http.post(
      Uri.parse(Strings.courses_url),
      headers: headers,
      body: body,
    );
  }

  void acceptTutorRequest(
      var token,
      int tutorId,
      int tutorRequestId,
      int studentId,
      int gradeId,
      String title,
      String description,
      int subjectId) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Charset': 'utf-8',
      "Authorization": "Bearer " + token.toString()
    };
    final body = jsonEncode({
      "tutorRequestId": tutorRequestId,
      "title": title,
      "description": description,
      "status": "Accepted",
      "studentId": studentId,
      "gradeId": gradeId,
      "subjectId": subjectId,
    });
    var response = await http.put(Uri.parse(Strings.tutorrequests_url),
        headers: headers, body: body);
    if (response.statusCode == 200) {
      API_Management().createCourseByRequest(
          token, title, description, tutorId, tutorRequestId, studentId);
    } else {}
  }

  Future<TutorCourses> getCoursesByTutorID(var token, int tutorId) async {
    var response = await http.get(
      Uri.parse(Strings.tutors_get_url(tutorId)),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer " + token.toString()
      },
    );
    if (response.statusCode == 200) {
      var jsonString = response.body;
      var jsonMap = json.decode(jsonString);
      return TutorCourses.fromJson(jsonMap);
    } else {
      throw Exception('Error while get Course');
    }
  }

  Future<Course> getCourseByStudentId(var token, int studentId) async {
    var response = await http.get(
      Uri.parse(Strings.courses_get_url_student_id(studentId)),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer " + token.toString()
      },
    );
    if (response.statusCode == 200) {
      var jsonString = response.body;
      var jsonMap = json.decode(jsonString);
      return Course.fromJson(jsonMap);
    } else {
      throw Exception('Error while get Course');
    }
  }

  Future<TutorRequests> getRequest(
    var token,
  ) async {
    var response = await http.get(
      Uri.parse(Strings.tutorrequests_url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer " + token.toString()
      },
    );
    if (response.statusCode == 200) {
      var jsonString = response.body;
      var jsonMap = json.decode(jsonString);
      return TutorRequests.fromJson(jsonMap);
    } else {
      throw Exception('Error while get Request');
    }
  }

  Future<Tutors> getTutor(var token) async {
    var response = await http.get(Uri.parse(Strings.tutors_url), headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer " + token.toString()
    });
    if (response.statusCode == 200) {
      var jsonString = response.body;
      var jsonMap = json.decode(jsonString);
      return Tutors.fromJson(jsonMap);
    } else {
      throw Exception('Error while get Request');
    }
  }

  Future<TutorCourses> getTutorByTutorID(var token, int tutorId) async {
    var response = await http.get(
      Uri.parse(Strings.tutors_get_url(tutorId)),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer " + token.toString()
      },
    );
    if (response.statusCode == 200) {
      var jsonString = response.body;
      var jsonMap = json.decode(jsonString);
      return TutorCourses.fromJson(jsonMap);
    } else {
      throw Exception('Error while get Course');
    }
  }

  void deleteCourse(var token, int courseid, String title, String description,
      int tutorId, int tutorRequestId, int studentId) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Charset': 'utf-8',
      "Authorization": "Bearer " + token.toString()
    };
    final body = jsonEncode({
      "courseId": courseid,
      "title": title,
      "description": description,
      "linkUrl": "strig",
      "status": false,
      "tutorId": tutorId,
      "tutorRequestId": tutorRequestId,
      "studentID": studentId,
    });
    await http.put(Uri.parse(Strings.courses_url),
        headers: headers, body: body);
  }

  void createClass(var token, int courseid, String title, String description,
      String startTime, String endTime, int tutorId, int studentId) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Charset': 'utf-8',
      "Authorization": "Bearer " + token.toString()
    };
    final body = jsonEncode({
      "title": title,
      "description": description,
      "startTime": startTime,
      "endTime": endTime,
      "status": true,
      "studentID": studentId,
      "tutorID": tutorId,
      "courseId": courseid,
    });
    await http.post(Uri.parse(Strings.class_url), headers: headers, body: body);
  }

  Future<Subjects> getSubjects(var token) async {
    var response = await http.get(
      Uri.parse(Strings.subject_url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer " + token.toString()
      },
    );
    if (response.statusCode == 200) {
      var jsonString = response.body;
      var jsonMap = json.decode(jsonString);
      return Subjects.fromJson(jsonMap);
    } else {
      throw Exception('Error while get Subjects');
    }
  }

  Future<Classes> getAllClass(var token) async {
    var response = await http.get(
      Uri.parse(Strings.class_for_calendar_url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer " + token.toString()
      },
    );
    if (response.statusCode == 200) {
      var jsonString = response.body;
      var jsonMap = json.decode(jsonString);
      return Classes.fromJson(jsonMap);
    } else {
      throw Exception('Error while get Classes');
    }
  }

  void updateClass(
      var token,
      int classid,
      int courseid,
      String title,
      String description,
      String startTime,
      String endTime,
      bool status,
      int studentId,
      int tutorId) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Charset': 'utf-8',
      "Authorization": "Bearer " + token.toString()
    };
    final body = jsonEncode({
      "id": classid,
      "title": title,
      "description": description,
      "startTime": startTime,
      "endTime": endTime,
      "status": status,
      "studentID": studentId,
      "tutorID": tutorId,
      "courseId": courseid
    });
    await http.put(Uri.parse(Strings.class_url), headers: headers, body: body);
  }

  Future<bool> createPost(var token, String title, String description,
      String status, int studentId, int subjectId, int gradeId) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      "Authorization": "Bearer " + token.toString()
    };
    final body = jsonEncode({
      "title": title,
      "description": description,
      "status": status,
      "studentId": studentId,
      "subjectId": subjectId,
      "gradeId": gradeId
    });
    var response = await http.post(Uri.parse(Strings.request_url),
        headers: headers, body: body);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  void updateStudent(int id, String email, String name, String phone,
      int schoolId, int gradeId, String image, var token) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      "Authorization": "Bearer " + token.toString()
    };

    final body = jsonEncode({
      "studentId": id,
      "email": email,
      "fullName": name,
      "phoneNumber": phone,
      "schoolId": schoolId,
      "gradeId": gradeId,
      "imagePath": image
    });

    var response = await http.put(Uri.parse(Strings.student_url),
        headers: headers, body: body);

    log(response.statusCode.toString());
  }

  // Future<Tutors> getTutorByCourseId(var token, int courseId) async {
  //   var response = await http.get(
  //     Uri.parse(Strings.tutors_get_url_by_course_id(courseId)),
  //     headers: {
  //       "Content-Type": "application/json",
  //       "Authorization": "Bearer " + token.toString()
  //     },
  //   );
  //   if (response.statusCode == 200) {
  //     var jsonString = response.body;
  //     var jsonMap = json.decode(jsonString);
  //     return Tutors.fromJson(jsonMap);
  //   } else {
  //     throw Exception('Error while get Tutor');
  //   }
  // }

  void deletePost(var token, int postId, String title, String description,
      int studentId, int gradeId, int subjectId) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Charset': 'utf-8',
      "Authorization": "Bearer " + token.toString(),
    };
    final body = jsonEncode({
      "tutorRequestId": postId,
      "title": title,
      "description": description,
      "status": "Deleted",
      "studentId": studentId,
      "gradeId": gradeId,
      "subjectId": subjectId
    });
    await http.put(Uri.parse(Strings.request_url),
        headers: headers, body: body);
  }

  Future<TutorRequests> getTutorRequestsBySubjectId(
      String token, int subjectId) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      "Authorization": "Bearer " + token.toString()
    };
    var response = await http.get(
        Uri.parse(Strings.get_tutorrequests_by_subject_id_url(subjectId)),
        headers: headers);
    if (response.statusCode == 200) {
      var jsonString = response.body;
      var jsonMap = json.decode(jsonString);
      return TutorRequests.fromJson(jsonMap);
    } else {
      throw Exception('Error while get TutorRequests');
    }
  }

  void updateTutor(String token, String username, String phone, String email,
      String imagePath, int tutorId) {
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      "Authorization": "Bearer " + token.toString()
    };
    final body = jsonEncode({
      "tutorId": tutorId,
      "email": email,
      "fullName": username,
      "phoneNumber": phone,
      "imagePath": imagePath
    });
    http.put(Uri.parse(Strings.tutors_url), headers: headers, body: body);
  }
}

// // class Subjects {
// //   Subjects({
// //     required this.message,
// //     required this.data,
// //     required this.status,
// //   });
// //   late final String message;
// //   late final List<Data> data;
// //   late final String status;

// //   Subjects.fromJson(Map<String, dynamic> json) {
// //     message = json['message'];
// //     data = List.from(json['data']).map((e) => Data.fromJson(e)).toList();
// //     status = json['status'];
// //   }

// //   Map<String, dynamic> toJson() {
// //     final _data = <String, dynamic>{};
// //     _data['message'] = message;
// //     _data['data'] = data.map((e) => e.toJson()).toList();
// //     _data['status'] = status;
// //     return _data;
// //   }
// // }

// // class Data {
// //   Data({
// //     required this.subjectId,
// //     required this.subjectName,
// //     required this.gradeId,
// //   });
// //   late final int subjectId;
// //   late final String subjectName;
// //   late final int gradeId;

// //   Data.fromJson(Map<String, dynamic> json) {
// //     subjectId = json['subjectId'];
// //     subjectName = json['subjectName'];
// //     gradeId = json['gradeId'];
// //   }

// //   Map<String, dynamic> toJson() {
// //     final _data = <String, dynamic>{};
// //     _data['subjectId'] = subjectId;
// //     _data['subjectName'] = subjectName;
// //     _data['gradeId'] = gradeId;
// //     return _data;
// //   }
// // }

// class Students {
//   Students({
//     required this.message,
//     required this.data,
//     required this.status,
//   });
//   late final String message;
//   late final Data data;
//   late final String status;

//   Students.fromJson(Map<String, dynamic> json) {
//     message = json['message'];
//     data = Data.fromJson(json['data']);
//     status = json['status'];
//   }

//   Map<String, dynamic> toJson() {
//     final _data = <String, dynamic>{};
//     _data['message'] = message;
//     _data['data'] = data.toJson();
//     _data['status'] = status;
//     return _data;
//   }
// }

// class Data {
//   Data({
//     required this.studentId,
//     required this.email,
//     required this.fullName,
//     // required this.grade,
//     required this.phoneNumber,
//     required this.imagePath,
//     required this.schoolId,
//     required this.gradeId,
//   });
//   late final int studentId;
//   late final String email;
//   late final String fullName;
//   // late final int grade;
//   late final String phoneNumber;
//   late final String imagePath;
//   late final int schoolId;
//   late final int gradeId;

//   Data.fromJson(Map<String, dynamic> json) {
//     studentId = json['studentId'];
//     email = json['email'];
//     fullName = json['fullName'];
//     // grade = json['grade'];
//     phoneNumber = json['phoneNumber'];
//     imagePath = json['imagePath'];
//     schoolId = json['schoolId'];
//     gradeId = json['gradeId'];
//   }

//   Map<String, dynamic> toJson() {
//     final _data = <String, dynamic>{};
//     _data['studentId'] = studentId;
//     _data['email'] = email;
//     _data['fullName'] = fullName;
//     // _data['grade'] = grade;
//     _data['phoneNumber'] = phoneNumber;
//     _data['imagePath'] = imagePath;
//     _data['schoolId'] = schoolId;
//     _data['gradeId'] = gradeId;
//     return _data;
//   }
// }

class Subjects {
  Subjects({
    required this.message,
    required this.data,
    required this.status,
  });
  late final String message;
  late final List<Data> data;
  late final String status;

  Subjects.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = List.from(json['data']).map((e) => Data.fromJson(e)).toList();
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['message'] = message;
    _data['data'] = data.map((e) => e.toJson()).toList();
    _data['status'] = status;
    return _data;
  }
}

class Data {
  Data({
    required this.subjectId,
    required this.subjectName,
    required this.gradeId,
  });
  late final int subjectId;
  late final String subjectName;
  late final int gradeId;

  Data.fromJson(Map<String, dynamic> json) {
    subjectId = json['subjectId'];
    subjectName = json['subjectName'];
    gradeId = json['gradeId'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['subjectId'] = subjectId;
    _data['subjectName'] = subjectName;
    _data['gradeId'] = gradeId;
    return _data;
  }
}

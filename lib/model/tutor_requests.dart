class TutorRequests {
  TutorRequests({
    required this.message,
    required this.data,
    required this.status,
  });
  late final String message;
  late final List<Data> data;
  late final String status;

  TutorRequests.fromJson(Map<String, dynamic> json) {
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
    required this.tutorRequestId,
    required this.title,
    required this.description,
    required this.status,
    required this.studentId,
    required this.subjectId,
    required this.gradeId,
    this.createAt,
  });
  late final int tutorRequestId;
  late final String title;
  late final String description;
  late final String status;
  late final int studentId;
  late final int subjectId;
  late final int gradeId;
  late final String? createAt;

  Data.fromJson(Map<String, dynamic> json) {
    tutorRequestId = json['tutorRequestId'];
    title = json['title'];
    description = json['description'];
    status = json['status'];
    studentId = json['studentId'];
    subjectId = json['subjectId'];
    gradeId = json['gradeId'];
    createAt = json['createAt'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['tutorRequestId'] = tutorRequestId;
    _data['title'] = title;
    _data['description'] = description;
    _data['status'] = status;
    _data['studentId'] = studentId;
    _data['subjectId'] = subjectId;
    _data['gradeId'] = gradeId;
    _data['createAt'] = createAt;
    return _data;
  }
}

// class TutorRequests {
//   TutorRequests({
//     required this.message,
//     required this.data,
//     required this.status,
//   });
//   late final String message;
//   late final List<Data> data;
//   late final String status;

//   TutorRequests.fromJson(Map<String, dynamic> json) {
//     message = json['message'];
//     data = List.from(json['data']).map((e) => Data.fromJson(e)).toList();
//     status = json['status'];
//   }

//   Map<String, dynamic> toJson() {
//     final _data = <String, dynamic>{};
//     _data['message'] = message;
//     _data['data'] = data.map((e) => e.toJson()).toList();
//     _data['status'] = status;
//     return _data;
//   }
// }

// class Data {
//   Data({
//     required this.tutorRequestId,
//     required this.title,
//     required this.description,
//     required this.status,
//     required this.studentId,
//     required this.subjectId,
//     required this.gradeId,
//     this.createAt,
//   });
//   late final int tutorRequestId;
//   late final String title;
//   late final String description;
//   late final String status;
//   late final int studentId;
//   late final int subjectId;
//   late final int gradeId;
//   late final String? createAt;

//   Data.fromJson(Map<String, dynamic> json) {
//     tutorRequestId = json['tutorRequestId'];
//     title = json['title'];
//     description = json['description'];
//     status = json['status'];
//     studentId = json['studentId'];
//     subjectId = json['subjectId'];
//     gradeId = json['gradeId'];
//     createAt = json['createAt'];
//   }

//   Map<String, dynamic> toJson() {
//     final _data = <String, dynamic>{};
//     _data['tutorRequestId'] = tutorRequestId;
//     _data['title'] = title;
//     _data['description'] = description;
//     _data['status'] = status;
//     _data['studentId'] = studentId;
//     _data['subjectId'] = subjectId;
//     _data['gradeId'] = gradeId;
//     _data['createAt'] = createAt;
//     return _data;
//   }
// }

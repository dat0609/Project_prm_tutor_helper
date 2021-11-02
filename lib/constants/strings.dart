class Strings {
  // ignore: constant_identifier_names
  static const String courses_url =
      "https://tutorhelper20210920193710.azurewebsites.net/api/v1/courses";

  // ignore: non_constant_identifier_names
  static String courses_get_url(int id) {
    return "https://tutorhelper20210920193710.azurewebsites.net/api/v1/courses/$id";
  }

  // ignore: non_constant_identifier_names
  static String courses_get_url_student_id(int id) {
    return "https://tutorhelper20210920193710.azurewebsites.net/api/v1/courses/query?s=$id";
  }

  // ignore: constant_identifier_names
  static const String tutors_url =
      "https://tutorhelper20210920193710.azurewebsites.net/api/v1/tutors?PageSize=1000";

  // ignore: non_constant_identifier_names
  static String tutors_get_url(int id) {
    return "https://tutorhelper20210920193710.azurewebsites.net/api/v1/tutors/$id";
  }

  // ignore: constant_identifier_names
  static const String tutorrequests_url =
      "https://tutorhelper20210920193710.azurewebsites.net/api/v1/tutor-requests?PageSize=1000";

  // ignore: non_constant_identifier_names
  static String tutorrequests_get_url(int id) {
    return "https://tutorhelper20210920193710.azurewebsites.net/api/v1/tutor-requests/$id";
  }

  static const String createCourses =
      "https://tutorhelper20210920193710.azurewebsites.net/api/v1/courses";

  // ignore: non_constant_identifier_names
  static String student_signin_url =
      "https://tutorhelper20210920193710.azurewebsites.net/api/v1/auth/sign-in-student";

  // ignore: non_constant_identifier_names
  static String tutor_signin_url =
      "https://tutorhelper20210920193710.azurewebsites.net/api/v1/auth/sign-in-tutor";

  // ignore: constant_identifier_names
  static const String class_url =
      "https://tutorhelper20210920193710.azurewebsites.net/api/v1/classes";

  // ignore: non_constant_identifier_names
  static String class_for_calendar_url =
      "https://tutorhelper20210920193710.azurewebsites.net/api/v1/classes?PageSize=1000";

  // ignore: non_constant_identifier_names
  static String class_get_url(int id) {
    return "https://tutorhelper20210920193710.azurewebsites.net/api/v1/classess/$id";
  }

  // ignore: non_constant_identifier_names
  static String get_student_by_id(int id) {
    return "https://tutorhelper20210920193710.azurewebsites.net/api/v1/students/$id";
  }

  // ignore: constant_identifier_names
  static const String request_url =
      "https://tutorhelper20210920193710.azurewebsites.net/api/v1/tutor-requests";

  // ignore: constant_identifier_names
  static const String student_url =
      "https://tutorhelper20210920193710.azurewebsites.net/api/v1/students";

  // ignore: non_constant_identifier_names
  static String subject_url =
      "https://tutorhelper20210920193710.azurewebsites.net/api/v1/subjects?PageSize=500";

  // ignore: non_constant_identifier_names
  static String student_get_url(int id) {
    return "https://tutorhelper20210920193710.azurewebsites.net/api/v1/students/$id";
  }

  // ignore: non_constant_identifier_names
  static String get_subject_by_grade_id(int gradeId) {
    return "https://tutorhelper20210920193710.azurewebsites.net/api/v1/subjects?s=$gradeId&PageSize=50";
  }

  // ignore: non_constant_identifier_names
  static String get_tutorrequests_by_subject_id_url(int subjectid) {
    return "https://tutorhelper20210920193710.azurewebsites.net/api/v1/tutor-requests?s=$subjectid&PageSize=10000";
  }
}

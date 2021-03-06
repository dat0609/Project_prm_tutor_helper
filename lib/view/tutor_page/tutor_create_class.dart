import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:tutor_helper/api/api_management.dart';
import 'package:tutor_helper/presenter/date_time_format.dart';
import 'package:tutor_helper/view/tutor_page/tutor_management.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:day_picker/day_picker.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class CreateClass extends StatefulWidget {
  const CreateClass({Key? key}) : super(key: key);

  @override
  _CreateClassState createState() => _CreateClassState();
}

class _CreateClassState extends State<CreateClass> {
  final List<DayInWeek> _days = [
    DayInWeek("Sun"),
    DayInWeek("Mon"),
    DayInWeek("Tue"),
    DayInWeek("Wed"),
    DayInWeek("Thu"),
    DayInWeek("Fri"),
    DayInWeek("Sat"),
  ];

  final descriptionController = TextEditingController();
  // ignore: non_constant_identifier_names
  var data_from_course_detail = Get.arguments;
  final storage = const FlutterSecureStorage();
  DateTime selectedStartDate = DateTime.now();
  DateTime selectedEndDate = DateTime.now();
  String startTimeChanged = '';
  String startTimeToValidate = '';
  String startTimeSaved = '';
  String endTimeChanged = '';
  String endTimeToValidate = '';
  String endTimeSaved = '';
  List<int> weekdateData = [];
  List<List<String>> classDateTimeData = [];
  String title = "";
  String description = "";

  _startDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedStartDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.parse("2100-01-01"),
    );
    if (picked != null && picked != selectedStartDate) {
      setState(() {
        selectedStartDate = picked;
      });
    }
  }

  _endDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedEndDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.parse("2100-01-01"),
    );
    if (picked != null && picked != selectedEndDate) {
      setState(() {
        selectedEndDate = picked;
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      _navigator(),
      _upper(),
      _under(),
    ]);
  }

  AppBar _navigator() {
    return AppBar(
      title: const Text("Create Class"),
    );
  }

  Widget _upper() {
    return Material(
      type: MaterialType.transparency,
      child: Container(
        margin: const EdgeInsets.only(top: 75),
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        height: 800,
        width: 500,
        decoration: const BoxDecoration(
          color: Color(0xFFF9F9FB),
        ),
        child: Column(
          children: [
            Row(
              children: const [
                Text(
                  "Description",
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
            TextFormField(
              keyboardType: TextInputType.multiline,
              maxLines: 5,
              onChanged: (value) {
                description = value;
              },
            ),
            Wrap(children: const [
              Text(
                "Choose Time for Class",
                style: TextStyle(
                    fontSize: 25,
                    color: Colors.black,
                    fontWeight: FontWeight.w900),
              )
            ]),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Start Date:",
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(
                  width: 200,
                  child: ElevatedButton(
                    onPressed: () => _startDate(context),
                    child: Text(
                      "${selectedStartDate.toLocal()}".split(' ')[0],
                      style: const TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(primary: Colors.white),
                  ),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "End Date:",
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(
                  width: 200,
                  child: ElevatedButton(
                    onPressed: () => _endDate(context),
                    child: Text(
                      "${selectedEndDate.toLocal()}".split(' ')[0],
                      style: const TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(primary: Colors.white),
                  ),
                ),
              ],
            ),
            Wrap(
              children: [
                SelectWeekDays(
                  days: _days,
                  border: false,
                  boxDecoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      colors: [Color(0xFF1DACE0), Color(0xFF1DACE0)],
                      tileMode: TileMode.repeated,
                    ),
                  ),
                  onSelect: (List<String> values) {
                    weekdateData.clear();
                    Map<String, int> weekday = {
                      "Mon": 1,
                      "Tue": 2,
                      "Wed": 3,
                      "Thu": 4,
                      "Fri": 5,
                      "Sat": 6,
                      "Sun": 7,
                    };
                    var entryList = weekday.entries.toList();
                    for (int i = 0; i < values.length; i++) {
                      for (int k = 0; k < weekday.length; k++) {
                        if (values[i] == entryList[k].key) {
                          weekdateData.add(entryList[k].value);
                          break;
                        }
                      }
                    }
                  },
                ),
              ],
            ),
            Wrap(
              children: [
                DateTimePicker(
                  type: DateTimePickerType.time,
                  timePickerEntryModeInput: true,
                  initialValue: '',
                  icon: const Icon(Icons.access_time),
                  timeLabelText: "Start Time",
                  use24HourFormat: true,
                  locale: const Locale('vi', 'VN'),
                  onChanged: (val) => setState(() => startTimeChanged = val),
                  validator: (val) {
                    setState(() => startTimeToValidate = val ?? '');
                    return null;
                  },
                  onSaved: (val) => setState(() => startTimeSaved = val ?? ''),
                ),
              ],
            ),
            Wrap(
              children: [
                DateTimePicker(
                  type: DateTimePickerType.time,
                  timePickerEntryModeInput: true,
                  initialValue: '',
                  icon: const Icon(Icons.access_time),
                  timeLabelText: "End Time",
                  use24HourFormat: true,
                  locale: const Locale('vi', 'VN'),
                  onChanged: (val) => setState(() => endTimeChanged = val),
                  validator: (val) {
                    setState(() => endTimeToValidate = val ?? '');
                    return null;
                  },
                  onSaved: (val) => setState(() => endTimeSaved = val ?? ''),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Container _under() {
    return Container(
      margin: const EdgeInsets.only(top: 630),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TextButton(
              onPressed: () {
                classDateTimeData.clear();
                for (int i = 0; i < weekdateData.length; i++) {
                  List<List<String>> dateTimeData =
                      DateTimeTutor.getDaysInBetween(
                          "${selectedStartDate.toLocal()}".split(' ')[0],
                          "${selectedEndDate.toLocal()}".split(' ')[0],
                          weekdateData[i],
                          startTimeChanged,
                          endTimeChanged);
                  for (int k = 0; k < dateTimeData.length; k++) {
                    classDateTimeData.add(dateTimeData[k]);
                  }
                }
                Alert(
                    context: context,
                    type: AlertType.warning,
                    title: "Create Class",
                    desc: "Are you sure you want to Create this Class?",
                    buttons: [
                      DialogButton(
                          onPressed: () => Get.back(),
                          child: const Text("Cancel")),
                      DialogButton(
                          onPressed: () {
                            for (int i = 0; i < classDateTimeData.length; i++) {
                              var date = classDateTimeData[i][0].split("T");
                              String dateStr = date[0];

                              API_Management().createClass(
                                  data_from_course_detail["token"],
                                  data_from_course_detail["courseid"],
                                  "Class of " +
                                      data_from_course_detail["title"]
                                          .toString() +
                                      " at $dateStr",
                                  description,
                                  classDateTimeData[i][0],
                                  classDateTimeData[i][1],
                                  data_from_course_detail["tutorid"],
                                  data_from_course_detail["studentid"]);
                            }
                            Alert(
                                context: context,
                                type: AlertType.success,
                                title: "Class Created!",
                                desc:
                                    "The class has been Created successfully!",
                                buttons: [
                                  DialogButton(
                                      onPressed: () => Get.offAll(
                                          () => const TutorManagement()),
                                      child: const Text("OK")),
                                ]).show();
                          },
                          child: const Text("Create")),
                    ]).show();
              },
              child: const Text(
                "Create Class",
                style: TextStyle(color: Colors.white),
              ),
              style: TextButton.styleFrom(
                backgroundColor: Colors.cyan,
                textStyle: const TextStyle(fontSize: 20),
              ))
        ],
      ),
    );
  }
}

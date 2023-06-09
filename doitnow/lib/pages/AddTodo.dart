// ignore_for_file: unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'HomePage.dart';

class AddTodoPage extends StatefulWidget {
  AddTodoPage({Key? key, required this.switchState}) : super(key: key);

  final bool switchState;
  @override
  _AddTodoPageState createState() => _AddTodoPageState(switchState);
}

DateTime selectedDate = DateTime.now();

class _AddTodoPageState extends State<AddTodoPage> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  String category = "";
  bool switchStatus = false;
  bool isImportant = false;

  _AddTodoPageState(bool switchState) {
    this.switchStatus = switchState;
  }

  Widget importantCheckbox() {
    return Row(
      children: [
        Checkbox(
          value: isImportant,
          onChanged: (value) {
            setState(() {
              isImportant = value!;
            });
          },
        ),
        Text(
          "Important",
          style: TextStyle(
            color: switchStatus ? Colors.white : Colors.black87,
            fontSize: 16.5,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: switchStatus ? Colors.black87 : Colors.white,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(
                height: 30,
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (builder) => HomePage()));
                },
                icon: Icon(
                  Icons.home,
                  color: switchStatus ? Colors.white : Colors.black87,
                  size: 28,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Create Todo",
                      style: TextStyle(
                          fontSize: 33,
                          color: switchStatus ? Colors.white : Colors.black87,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 4),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    label("Task Title"),
                    SizedBox(
                      height: 12,
                    ),
                    title(),
                    SizedBox(
                      height: 25,
                    ),
                    label("Description"),
                    SizedBox(
                      height: 12,
                    ),
                    description(),
                    SizedBox(
                      height: 25,
                    ),
                    label("Is it important?"),
                    SizedBox(
                      height: 12,
                    ),
                    importantCheckbox(), // Add the important checkbox
                    SizedBox(
                      height: 25,
                    ),
                    label("When are you planning the Todo"),
                    SizedBox(
                      height: 200,
                      child: CupertinoDatePicker(
                        mode: CupertinoDatePickerMode.dateAndTime,
                        initialDateTime: DateTime.now(),
                        onDateTimeChanged: (DateTime newDateTime) {
                          selectedDate =
                              newDateTime; // Update selected date and time
                        },
                        use24hFormat: false,
                        minuteInterval: 1,
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    label("Todo Category:"),
                    SizedBox(
                      height: 25,
                    ),
                    Wrap(
                      runSpacing: 10,
                      children: [
                        categorySelect("Gym", 0xfff29732),
                        SizedBox(
                          width: 20,
                        ),
                        categorySelect("BITS", 0xff00A800),
                        SizedBox(
                          width: 20,
                        ),
                        categorySelect("Food", 0xffff6d6e),
                        SizedBox(
                          width: 20,
                        ),
                        categorySelect("Work", 0xff234ebd),
                        SizedBox(
                          width: 20,
                        ),
                        categorySelect("Swimming", 0xffad32f9),
                      ],
                    ),
                    SizedBox(
                      width: 50,
                      height: 25,
                    ),
                    button(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget button() {
    return InkWell(
        onTap: () {
          final FirebaseAuth auth = FirebaseAuth.instance;
          final User? user = auth.currentUser;
          final uid = user!.uid;
          FirebaseFirestore.instance.collection("Todo").add({
            "title": _titleController.text,
            "description": _descriptionController.text,
            "category": category,
            "date": selectedDate.millisecondsSinceEpoch,
            "isCompleted": false,
            "isImportant": isImportant, // Add the isImportant field
            "uid": uid,
            "visible": true,
          });
          Navigator.pop(context);
        },
        child: Container(
          height: 56,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 29, 224, 235),
                Color.fromARGB(255, 5, 94, 146),
                Color.fromARGB(255, 21, 68, 130)
              ],
            ),
          ),
          child: Center(
            child: Text(
              "Create",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ));
  }

  Widget categorySelect(String label, int color) {
    return InkWell(
        onTap: () {
          setState(() {
            category = label;
          });
        },
        child: Chip(
            backgroundColor: category == label
                ? (switchStatus ? Colors.black : Colors.grey)
                : Color(color),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            label: Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            )));
  }

  Widget description() {
    return Container(
      height: 150,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: switchStatus ? Color(0xff2a2e3d) : Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.blueAccent),
      ),
      child: TextFormField(
        controller: _descriptionController,
        style: TextStyle(
          color: switchStatus ? Colors.grey : Colors.black,
          fontSize: 17,
        ),
        maxLines: null,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Description",
          hintStyle: TextStyle(
            color: switchStatus ? Colors.grey : Colors.black,
            fontSize: 17,
          ),
          contentPadding: EdgeInsets.only(
            left: 20,
            right: 20,
          ),
        ),
      ),
    );
  }

  Widget title() {
    return Container(
      height: 55,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: switchStatus ? Color(0xff2a2e3d) : Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.blue),
      ),
      child: TextFormField(
        controller: _titleController,
        style: TextStyle(
          color: switchStatus ? Colors.grey : Colors.black,
          fontSize: 17,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Task Title",
          hintStyle: TextStyle(
            color: switchStatus ? Colors.grey : Colors.black,
            fontSize: 17,
          ),
          contentPadding: EdgeInsets.only(
            left: 20,
            right: 20,
          ),
        ),
      ),
    );
  }

  Widget label(String label) {
    return Text(
      label,
      style: TextStyle(
          color: switchStatus ? Colors.white : Colors.black87,
          fontWeight: FontWeight.w600,
          fontSize: 16.5,
          letterSpacing: 0.2),
    );
  }
}

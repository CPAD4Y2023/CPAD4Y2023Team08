import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:doitnow/Service/Auth_Service.dart';
import 'package:doitnow/pages/AddTodo.dart';
import 'package:doitnow/pages/SignInPage.dart';
import 'package:doitnow/pages/TodoCard.dart';
import 'package:doitnow/pages/ViewData.dart';
import 'package:intl/intl.dart';
import 'package:grouped_list/grouped_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AuthClass authClass = AuthClass();
  bool _switchvalue = false;
  bool _value = false;
  Map<String, bool> _categoriesFilter = {
    'BITS': true,
    'Work': true,
    'Gym': true,
    'Food': true,
    'Swimming': true,
  };
  DateTime _selectedDate = DateTime.now();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final Stream<QuerySnapshot> _todos = FirebaseFirestore.instance
      .collection('Todo')
      .where("uid", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore.instance
        .collection('Todo')
        .get()
        .then((value) => value.docs.forEach((element) {
              FirebaseFirestore.instance
                  .collection('Todo')
                  .doc(element.id)
                  .update({'visible': true});
            }));
    return Scaffold(
      backgroundColor: _switchvalue ? Colors.black87 : Colors.white,
      appBar: AppBar(
        backgroundColor: _switchvalue ? Colors.black87 : Colors.white,
        actions: [
          IconButton(
              icon: Icon(
                Icons.filter_list,
                color: _switchvalue ? Colors.white : Colors.black87,
              ),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Filter ToDo'),
                        content: StatefulBuilder(
                          builder:
                              (BuildContext context, StateSetter setState) {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SwitchListTile(
                                  title: Text('BITS'),
                                  value: _categoriesFilter['BITS']!,
                                  onChanged: (bool value) {
                                    updateVisible(value, 'BITS');
                                    setState(() {
                                      _categoriesFilter['BITS'] = value;
                                    });
                                  },
                                ),
                                SwitchListTile(
                                  title: Text('Work'),
                                  value: _categoriesFilter['Work']!,
                                  onChanged: (bool value) {
                                    updateVisible(value, 'Work');
                                    setState(() {
                                      _categoriesFilter['Work'] = value;
                                    });
                                  },
                                ),
                                SwitchListTile(
                                  title: Text('Gym'),
                                  value: _categoriesFilter['Gym']!,
                                  onChanged: (bool value) {
                                    updateVisible(value, 'Gym');
                                    setState(() {
                                      _categoriesFilter['Gym'] = value;
                                    });
                                  },
                                ),
                                SwitchListTile(
                                  title: Text('Food'),
                                  value: _categoriesFilter['Food']!,
                                  onChanged: (bool value) {
                                    updateVisible(value, 'Food');
                                    setState(() {
                                      _categoriesFilter['Food'] = value;
                                    });
                                  },
                                ),
                                SwitchListTile(
                                  title: Text('Swimming'),
                                  value: _categoriesFilter['Swimming']!,
                                  onChanged: (bool value) {
                                    updateVisible(value, 'Swimsming');
                                    setState(() {
                                      _categoriesFilter['Swimming'] = value;
                                    });
                                  },
                                ),
                              ],
                            );
                          },
                        ),
                      );
                    });
              }),
          IconButton(
            icon: !_switchvalue
                ? Icon(Icons.light_mode, color: Colors.yellow)
                : Icon(Icons.dark_mode, color: Colors.yellow),
            onPressed: () async {
              setState(() {
                _switchvalue = !_switchvalue;
              });
            },
          ),
          IconButton(
              icon: Icon(Icons.logout,
                  color: _switchvalue ? Colors.white : Colors.black87),
              onPressed: () async {
                await authClass.logout();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (builder) => SignInPage()),
                    (route) => false);
              }),
        ],
        bottom: PreferredSize(
          child: Align(
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.all(15.0),
              child: GestureDetector(
                onTap: () {
                  _selectDate(context);
                },
                child: Text(
                  DateFormat('EEEE, MMMM d, yyyy').format(_selectedDate),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: _switchvalue ? Colors.white : Colors.black87,
                  ),
                ),
              ),
            ),
          ),
          preferredSize: Size.fromHeight(35),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: _switchvalue ? Colors.black87 : Colors.white,
        items: [
          BottomNavigationBarItem(
            icon: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (builder) => AddTodoPage(
                              switchState: _switchvalue,
                            )));
              },
              child: Container(
                height: 52,
                width: 52,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(255, 2, 53, 95),
                      Color.fromARGB(255, 24, 87, 197),
                    ],
                  ),
                ),
                child: Icon(
                  Icons.add,
                  size: 32,
                  color: Colors.white,
                ),
              ),
            ),
            label: "Add To-do",
          ),
          BottomNavigationBarItem(
            icon: InkWell(
              onTap: () async {
                await FirebaseFirestore.instance
                    .collection('Todo')
                    .get()
                    .then((value) => value.docs.forEach((element) {
                          FirebaseFirestore.instance
                              .collection('Todo')
                              .doc(element.id)
                              .delete();
                        }));
              },
              child: Container(
                height: 52,
                width: 52,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(255, 2, 53, 95),
                      Color.fromARGB(255, 24, 87, 197),
                    ],
                  ),
                ),
                child: Icon(
                  Icons.delete,
                  size: 32,
                  color: Colors.white,
                ),
              ),
            ),
            label: "Remove To-do",
          ),
        ],
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: _todos,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            final filteredTodos = snapshot.data!.docs
                .where((doc) =>
                    _categoriesFilter[doc['category']] == true &&
                    _isSameDate(doc['date']))
                .toList();
            return Padding(
                padding: const EdgeInsets.all(13.0),
                child: GroupedListView<dynamic, String>(
                    elements: filteredTodos,
                    groupBy: (todo) =>
                        todo['isCompleted'] ? 'Incomplete' : 'Complete',
                    groupHeaderBuilder: (todo) => Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text(
                            todo['isCompleted'] ? 'Complete' : 'Incomplete',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color:
                                  _switchvalue ? Colors.white : Colors.black87,
                            ),
                          ),
                        ),
                    indexedItemBuilder: (context, snapshot, int index) {
                      Map<String, dynamic> todo =
                          snapshot.data() as Map<String, dynamic>;
                      String id = snapshot.id;
                      IconData iconData = Icons.list_alt_rounded;
                      Color iconColor = Colors.black;
                      switch (todo['category']) {
                        case 'Work':
                          iconData = Icons.work;
                          iconColor = Colors.blue;
                          break;
                        case 'Gym':
                          iconData = Icons.fitness_center;
                          iconColor = Colors.red;
                          break;
                        case 'BITS':
                          iconData = Icons.school;
                          iconColor = Colors.green;
                          break;
                        case 'Food':
                          iconData = Icons.fastfood;
                          iconColor = Colors.blue;
                          break;
                        case 'Design':
                          iconData = Icons.pool;
                          iconColor = Colors.purple;
                          break;
                      }

                      return Visibility(
                          visible: todo['visible'] == true,
                          child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (builder) => ViewData(
                                              todo: todo,
                                              id: id,
                                              switchState: _switchvalue,
                                            )));
                              },
                              child: Row(
                                children: [
                                  SizedBox(
                                    height: 100,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Theme(
                                      child: Transform.scale(
                                        scale: 1.5,
                                        child: Checkbox(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          activeColor: Color(0xff6cf8a9),
                                          checkColor: Color(0xff0e3e26),
                                          value: todo["isCompleted"] as bool,
                                          onChanged: (value) {
                                            FirebaseFirestore.instance
                                                .collection("Todo")
                                                .doc(id)
                                                .update({"isCompleted": value});
                                          },
                                        ),
                                      ),
                                      data: ThemeData(
                                        primarySwatch: Colors.blue,
                                        unselectedWidgetColor:
                                            Color(0xff5e616a),
                                      ),
                                    ),
                                  ),
                                  TodoCard(
                                      title: todo["title"] == null
                                          ? "No Title"
                                          : todo["title"],
                                      iconBgColor: Colors.white,
                                      iconColor: iconColor,
                                      iconData: iconData,
                                      switchState: _switchvalue,
                                      isImportant: todo["isImportant"],
                                      time: todo["date"] == null
                                          ? "No Date"
                                          : DateFormat('dd/MM/yyyy, HH:mm')
                                              .format(DateTime
                                                  .fromMillisecondsSinceEpoch(
                                                      todo["date"]))),
                                ],
                              )));
                    }));
          }),
    );
  }

  bool _isSameDate(int? dateInMillis) {
    final todoDate = DateTime.fromMillisecondsSinceEpoch(dateInMillis ?? 0);
    final selectedDate =
        DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day);
    return todoDate.year == selectedDate.year &&
        todoDate.month == selectedDate.month &&
        todoDate.day == selectedDate.day;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2010),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void updateVisible(bool value, String category) {
    FirebaseFirestore.instance
        .collection("Todo")
        .where("category", isEqualTo: category)
        .get()
        .then((todos) {
      todos.docs.forEach((element) {
        FirebaseFirestore.instance
            .collection("Todo")
            .doc(element.id)
            .update({"visible": value});
      });
    });
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:momento/Service/Auth_Service.dart';
import 'package:momento/pages/AddTodo.dart';
import 'package:momento/pages/SignUpPage.dart';
import 'package:momento/pages/TodoCard.dart';
import 'package:momento/pages/ViewData.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AuthClass authClass = AuthClass();
  final Stream<QuerySnapshot> _todos =
      FirebaseFirestore.instance.collection('Todo').snapshots();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: Text('Todo List'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: () async {
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
          ),
          IconButton(
              icon: Icon(Icons.logout),
              onPressed: () async {
                await authClass.logout();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (builder) => SignUpPage()),
                    (route) => false);
              }),
        ],
        bottom: PreferredSize(
          child: Align(
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.all(15.0),
              child: Text(
                DateFormat('EEEE, MMMM d, yyyy').format(DateTime.now()),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          preferredSize: Size.fromHeight(35),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black87,
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                size: 32,
                color: Colors.white,
              ),
              title: Container()),
          BottomNavigationBarItem(
            icon: InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (builder) => AddTodoPage()));
              },
              child: Container(
                height: 52,
                width: 52,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      Colors.indigoAccent,
                      Colors.purple,
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
            title: Container(),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.settings,
              size: 32,
              color: Colors.white,
            ),
            title: Container(),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: _todos,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> todo =
                      snapshot.data!.docs[index].data() as Map<String, dynamic>;
                  String id = snapshot.data!.docs[index].id;
                  IconData iconData = Icons.list_alt_rounded;
                  Color iconColor = Colors.black;
                  switch (todo['category']) {
                    case 'Work':
                      iconData = Icons.work;
                      iconColor = Colors.blue;
                      break;
                    case 'Workout':
                      iconData = Icons.fitness_center;
                      iconColor = Colors.yellow;
                      break;
                    case 'Study':
                      iconData = Icons.school;
                      iconColor = Colors.green;
                      break;
                    case 'Food':
                      iconData = Icons.fastfood;
                      iconColor = Colors.red;
                      break;
                    case 'Design':
                      iconData = Icons.brush;
                      iconColor = Colors.purple;
                      break;
                  }

                  return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (builder) => ViewData(
                                      todo: todo,
                                      id: id,
                                    )));
                      },
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Theme(
                              child: Transform.scale(
                                scale: 1.5,
                                child: Checkbox(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
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
                                unselectedWidgetColor: Color(0xff5e616a),
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
                              time: todo["date"] == null
                                  ? "No Date"
                                  : DateFormat('dd/MM/yyyy, HH:mm').format(
                                      DateTime.fromMillisecondsSinceEpoch(
                                          todo["date"]))),
                        ],
                      ));
                });
          }),
    );
  }
}

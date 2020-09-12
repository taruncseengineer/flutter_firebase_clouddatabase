import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DataBase App',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: DataBaseApp(),
    );
  }
}

class DataBaseApp extends StatefulWidget {
  @override
  _DataBaseAppState createState() => _DataBaseAppState();
}

class _DataBaseAppState extends State<DataBaseApp> {
  String name;
  String age;

  CollectionReference reference =
      FirebaseFirestore.instance.collection('userData');

  Future<void> createDataBase() {
    CollectionReference reference =
        FirebaseFirestore.instance.collection('userData');
    return reference
        .add({
          "name": name,
          "age": age,
        })
        .then((value) => print("name is $name and age is $age"))
        .catchError((e) {
          print("Somethimg Went Wrong");
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("DataBaseApp"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    titlePadding: EdgeInsets.all(20),
                    title: Text("Upload Data"),
                    content: Column(
                      children: [
                        TextField(
                          decoration: InputDecoration(
                            hintText: "Enter Your Name",
                          ),
                          onChanged: (val) {
                            setState(() {
                              name = val;
                            });
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextField(
                          decoration: InputDecoration(
                            hintText: "Enter your age",
                          ),
                          onChanged: (val) {
                            setState(() {
                              age = val;
                            });
                          },
                        ),
                      ],
                    ),
                    actions: [
                      FlatButton(
                          onPressed: () {
                            setState(() {
                              createDataBase();
                            });
                            Navigator.of(context).pop();
                          },
                          child: Text("Add"))
                    ],
                  );
                });
          }),
      body: StreamBuilder<QuerySnapshot>(
        stream: reference.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }
          return ListView(
              children: snapshot.data.docs.map((DocumentSnapshot document) {
            return new ListTile(
              title: Text(document.data()['name']),
              leading: CircleAvatar(
                child: Text(document.data()['age'].toString()),
              ),
            );
          }).toList());
        },
      ),
    );
  }
}

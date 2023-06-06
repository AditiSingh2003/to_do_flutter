import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'home.dart';

class AddTodo extends StatefulWidget {
  const AddTodo({super.key});

  @override
  State<AddTodo> createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

addtasktodatabase() async{
  final FirebaseAuth auth = FirebaseAuth.instance;
  final user = auth.currentUser;
  final uid = user!.uid;
  var time = DateTime.now();

  await FirebaseFirestore.instance.collection('tasks').doc(uid).collection('userTasks').doc(time.toString()).set({
    'title': titleController.text,
    'description': descriptionController.text,
    'time': time.toString(),
  });
  Fluttertoast.showToast(msg: 'Task Added Successfully');
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[700],
        title: const Text('Add Todo'),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: [
            SizedBox(height: 50.0),
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                labelStyle: TextStyle(
                  color: Colors.grey[700],
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              )
            ),
            SizedBox(height: 10.0),
             TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                labelStyle: TextStyle(
                  color: Colors.grey[700],
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              )
            ),
            SizedBox(height: 35.0),
            ElevatedButton(
              onPressed: () {
                addtasktodatabase();
                Navigator.push(context, MaterialPageRoute(builder: (context) => const Home()));
              },
              child: Text('Add Todo'),
              style: ElevatedButton.styleFrom(
                primary: Colors.grey[700],
                padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 10.0),
                textStyle: TextStyle(
                  fontSize: 20.0,
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}

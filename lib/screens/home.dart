import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:to_do_gfg/screens/authscreen.dart';
import 'AddTodo.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String uid = '';

  @override
  void initState() {
    super.initState();
      getuid();
    }
    getuid() async{
      final FirebaseAuth auth = FirebaseAuth.instance;
      final user = auth.currentUser;
      setState(() {
        uid = user!.uid;
      });
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar : AppBar(
        backgroundColor: Colors.grey[700],
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(child: Container()),
            Text('Todo'),
            Text('List' , style: TextStyle(color: Colors.blue),),
            Expanded(child: Container()),
            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => const AuthScreen()));
              },
              child: Container(
                child: Icon(Icons.logout),
              ),
            )
          ],
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: StreamBuilder(stream: FirebaseFirestore.instance.collection('tasks').doc(uid).collection('userTasks').snapshots(),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(child: CircularProgressIndicator());
          }
          else{
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index){
                return Card(
                  child: ListTile(
                    title: Text(snapshot.data!.docs[index]['title']),
                    subtitle: Text(snapshot.data!.docs[index]['description']),
                    trailing: IconButton(
                      onPressed: (){
                        FirebaseFirestore.instance.collection('tasks').doc(uid).collection('userTasks').doc(snapshot.data!.docs[index]['time']).delete();
                      },
                      icon: Icon(Icons.delete),
                    ),
                  ),
                );
              },
            );
          }
        },
         ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
           Navigator.push(context, MaterialPageRoute(builder: (context) => const AddTodo()));
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.grey[700],
      ),
    );
  }
}
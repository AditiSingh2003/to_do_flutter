import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'home.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({Key? key}) : super(key: key);

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>(); //constant key for form
  var _email = ''; //variable for email
  var _password = ''; //variable for password
  var _username = ''; //variable for username
  bool _islogin = true; //variable for login
  bool _successlog = false;
  bool _successsign = false;

  startauthentication() async{ //function for authentication asynchrnously is used to make the function run in background that wont effect the workng of the app
    final isValid = _formKey.currentState!.validate(); //validate the form as checks for currentstate of the form
    FocusScope.of(context).unfocus(); //unfocus the form

    if(isValid){ //if form is valid
      _formKey.currentState!.save(); //save the form
      submitform(_email, _password, _username); //call the submitform function
    }
  }

  submitform(String email , String password, String username) async{
    final auth = FirebaseAuth.instance; //instance of firebase auth
    UserCredential authResult; //variable for user credential

    try{
      if(_islogin){ //if user is login
        print('login');
        authResult = await auth.signInWithEmailAndPassword(email: email, password: password); //sign in with email and password
        _successlog = true;
      }
      else{
        authResult = await auth.createUserWithEmailAndPassword(email: email, password: password); // sign up with email and password
        String uid = authResult.user!.uid; // variable for user id
        await FirebaseFirestore.instance.collection('users').doc(uid).set({ // set the data in Firebase
          'username' : username, // username
          'email' : email, // email
          'password' : password, // password
        });
        _successsign = true;
      }
    }
    catch(error){
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: ListView(
        children: <Widget>[
          Padding(padding: EdgeInsets.all(10.0),
            child: Form(
              key: _formKey,
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  validator: (value){ //validator for email
                    if(value!.isEmpty || !value.contains("@") ){ //if email is empty or not contains @
                      return 'Please enter a valid email address'; //return the message
                    } //else
                    return null; //return null
                  },
                  onSaved: (value){ //save the value
                    _email = value!; //email
                  },
                  keyboardType: TextInputType.emailAddress,
                  key: ValueKey('email'),
                  decoration: InputDecoration(
                    labelText:'Email' ,
                    hintText:"Enter your E-mail",
                    labelStyle: GoogleFonts.roboto(),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    )
                  ),
                ),
                  SizedBox(height: 10,),
                  if(!_islogin) //if user is not login
                  TextFormField(
                    onSaved: (value){
                      _username = value!;
                    },
                    keyboardType: TextInputType.emailAddress,
                    key: ValueKey('usename'),
                    decoration: InputDecoration(
                        labelText:'Username' ,
                        hintText:"Enter your username",
                        labelStyle: GoogleFonts.roboto(),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        )
                    ),
                  ),
                SizedBox(height: 10,),
                TextFormField(
                  obscureText: true,
                  validator: (value){
                    if(value!.isEmpty || value.length < 7){
                      return 'Please enter a password with 7 or more characters';
                    }
                    return null;
                  },
                  onSaved: (value){
                    _password = value!;
                  },
                  keyboardType: TextInputType.emailAddress,
                  key: ValueKey('password'),
                  decoration: InputDecoration(
                      labelText:'Password' ,
                      hintText:"Enter your Password",
                      labelStyle: GoogleFonts.roboto(),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      )
                  ),
                ),
                SizedBox(height: 10,),
                Container(
                  height: 60,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.lightBlue,
                  ),
                  child: ElevatedButton(
                  onPressed: () {
                    startauthentication();
                    if (_successlog == true) {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const Home()));
                    }
                    else if(_successsign == true){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const Home()));
                    }
                    else if(_successsign == false)
                    {
                      //ToDo: show alret dialog of wrong password
                    }
                    else if(_successsign == false)
                    {
                      //Todo: show alert dialog of not signed in
                    }
                  },
                  child: _islogin == true ? Text(
                    'Login',
                    style: GoogleFonts.roboto(
                      color: Colors.white,
                      fontSize: 18.0,
                    ),
                  ) : Text(
                    'SignUp',
                    style: GoogleFonts.roboto(
                      color: Colors.white,
                      fontSize: 18.0,
                    ),
                  ),
                ),
                ),
                SizedBox(height: 10,),
                Container(
                  child: TextButton(
                    onPressed: (){
                      setState(() {
                        _islogin = !_islogin;
                      });
                    },
                    child: Text(
                      _islogin ? 'Create new account' : ' I already has an account',
                      style: GoogleFonts.roboto(
                        color: Colors.blue,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                )
              ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


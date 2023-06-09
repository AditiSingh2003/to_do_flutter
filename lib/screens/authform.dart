import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quickalert/quickalert.dart';
import 'home.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({Key? key}) : super(key: key);

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  Color hexToColor(String hexColor) {
  final hexCode = hexColor.replaceAll('#', '');
  return Color(int.parse('FF$hexCode', radix: 16));
  }

  void showAlertlog(){
    QuickAlert.show(
        context: context,
        text: "The credentials doesn't match",
        type: QuickAlertType.error,
    );
  }

  void showAlertlogdone(){
    QuickAlert.show(
      context: context,
      text: 'Successfully Loged In',
      type: QuickAlertType.success,
    );
  }

  void showAlertsigndone(){
    QuickAlert.show(
      context: context,
      text: 'Registered Successfully',
      type: QuickAlertType.success,
    );
  }

  final _formKey = GlobalKey<FormState>(); //constant key for form
  var _email = ''; //variable for email
  var _password = ''; //variable for password
  var _username = ''; //variable for username
  bool _islogin = true; //variable for login


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
        Navigator.push(context, MaterialPageRoute(builder: (context) => const Home()));
        showAlertlogdone();
      }
      else{
        authResult = await auth.createUserWithEmailAndPassword(email: email, password: password); // sign up with email and password
        String uid = authResult.user!.uid; // variable for user id
        await FirebaseFirestore.instance.collection('users').doc(uid).set(
            { // set the data in Firebase
              'username': username, // username
              'email': email, // email
              'password': password, // password
            }
        );
        Navigator.push(context, MaterialPageRoute(builder: (context) => const Home()));
        showAlertsigndone();
      }
    }
    catch(error){
      showAlertlog();
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
  return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: const AssetImage('assets/try.png'),
          fit: BoxFit.cover,
        )
      ),
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height *0.02,right: 35,left: 35),
      child: ListView(
        children: <Widget>[
          Container(
            child: Text('Welcome!',style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
          ),
          SizedBox(height: 10,),
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
                    validator: (value){ //validator for email
                      if(value!.isEmpty ){ //if email is empty or not contains @
                        return 'Please enter a Username'; //return the message
                      } //else
                      return null; //return null
                    },
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
                    style: ElevatedButton.styleFrom(
                    primary: hexToColor('#2A364E'),
                    onPrimary: Colors.white,
                  ),
                  onPressed: () {
                    startauthentication();
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
                        color: Colors.black,
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

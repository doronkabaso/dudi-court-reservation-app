import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/authentication.dart';
import 'package:flutter_firebase_auth/home.dart';
import 'package:flutter_firebase_auth/signup.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_firebase_auth/login.dart';
import 'package:flutter_firebase_auth/screens/login_with_google.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StatefulWrapper(
      onInit: () {
        // _getThingsOnStartup(context).then((value) {
        //   print('a user was loaded automatically for testing purposes');
        // });
      },
      child: Scaffold(
        body: ListView(
          padding: EdgeInsets.all(8.0),
          children: <Widget>[
            SizedBox(height: 80),
            // logo
            Column(
              children: [
                Image.asset('assets/icon_sela.jpeg', height: 80, width: 80,),
                SizedBox(height: 50),
                Text(
                  '!איזה כיף שחזרת',
                  style: TextStyle(fontSize: 24),
                ),
              ],
            ),

            SizedBox(
              height: 50,
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: LoginForm(),
            ),

            SizedBox(height: 20),

            Row(
              children: <Widget>[
                SizedBox(width: 30),
                GestureDetector(
                  onTap: () {
                    // Navigator.pushNamed(context, '/signup');
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Signup()));
                  },
                  child: Text('הרשמה',
                      style: TextStyle(fontSize: 20, color: Colors.blue)),
                ),
                SizedBox(width: 30),
                Text('?אין לך משתמש',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20)),
              ],
            ),
            SizedBox(width: 30),
            ElevatedButton(onPressed: () async {
              UserCredential userCredential = await signInWithGoogle();
              if (userCredential.user!.emailVerified) {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => Home(uid: userCredential.user!.uid)));
              }
            }, child: Text("Login with google")),
          ],
        ),
      ),
    );
  }

  // Future _getThingsOnStartup(context) async {
  //   AuthenticationHelper()
  //       .signIn(email: 'sharonbello@hotmail.com', password: 'q1w2e3r4')
  //       .then((result) {
  //     Navigator.pushReplacement(context,
  //         MaterialPageRoute(builder: (context) => Home(uid: result!)));
  //   });
  //   await Future.delayed(Duration(seconds: 2));
  // }


  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // userEmail = googleUser.email;

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}



class StatefulWrapper extends StatefulWidget {
  final Function onInit;
  final Widget child;

  const StatefulWrapper({required this.onInit, required this.child});

  @override
  _StatefulWrapperState createState() => _StatefulWrapperState();
}

class _StatefulWrapperState extends State<StatefulWrapper> {

  @override
  void initState() {
    if(widget.onInit != null) {
      widget.onInit();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

class LoginForm extends StatefulWidget {
  LoginForm({Key? key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();

  String? email;
  String? password;
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          // email
          TextFormField(
            // initialValue: 'Input text',
            textDirection: TextDirection.rtl,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.email_outlined),
              labelText: 'אימייל',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  const Radius.circular(100.0),
                ),
              ),
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'שדה זה הוא חובה';
              }
              return null;
            },
            onSaved: (val) {
              email = val;
            },
          ),
          SizedBox(
            height: 20,
          ),

          // password
          TextFormField(
            // initialValue: 'Input text',
            textDirection: TextDirection.rtl,
            decoration: InputDecoration(
              labelText: 'סיסמא',
              prefixIcon: Icon(Icons.lock_outline),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  const Radius.circular(100.0),
                ),
              ),
              suffixIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
                child: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                ),
              ),
            ),
            obscureText: _obscureText,
            onSaved: (val) {
              password = val;
            },
            validator: (value) {
              if (value!.isEmpty) {
                return 'שדה זה הוא חובה';
              }
              return null;
            },
          ),

          SizedBox(height: 30),

          SizedBox(
            height: 54,
            width: 184,
            child: ElevatedButton(
              onPressed: () {
                // Respond to button press

                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();

                  AuthenticationHelper()
                      .signIn(email: email!.trim(), password: password!.trim())
                      .then((result) {
                    if (result != null) {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => Home(uid: result)));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                          "הכניסה נכשלה. אנא נסה/י שוב",
                          style: TextStyle(fontSize: 16),
                        ),
                      ));
                    }
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(24.0)))),
              child: Text(
                'כניסה',
                style: TextStyle(fontSize: 24),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

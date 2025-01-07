import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/authentication.dart';
import 'package:flutter_firebase_auth/home.dart';

class Signup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StatefulWrapper(
      onInit: () {
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
              ],
            ),

            SizedBox(
              height: 50,
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SignupForm(),
            ),
          ],
        ),
      ),
    );
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

class SignupForm extends StatefulWidget {
  SignupForm({Key? key}) : super(key: key);

  @override
  _SignupFormState createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _formKey = GlobalKey<FormState>();

  String? email;
  String? password;
  String? name;
  bool _obscureText = false;

  bool agree = false;

  final pass = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    var border = OutlineInputBorder(
      borderRadius: BorderRadius.all(
        const Radius.circular(100.0),
      ),
    );
    var space = SizedBox(height: 10);
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          // email
          TextFormField(
            textDirection: TextDirection.rtl,
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.email_outlined),
                labelText: 'אימייל',
                border: border),
            validator: (value) {
              if (value!.isEmpty) {
                return 'שדה זה הוא חובה';
              }
              return null;
            },
            onSaved: (val) {
              email = val;
            },
            keyboardType: TextInputType.emailAddress,
          ),

          space,

          // password
          TextFormField(
            controller: pass,
            textDirection: TextDirection.rtl,
            decoration: InputDecoration(
              labelText: 'סיסמא',
              prefixIcon: Icon(Icons.lock_outline),
              border: border,
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
            onSaved: (val) {
              password = val;
            },
            obscureText: !_obscureText,
            validator: (value) {
              if (value!.isEmpty) {
                return 'שדה זה הוא חובה';
              }
              return null;
            },
          ),
          space,
          // confirm passwords
          TextFormField(
            textDirection: TextDirection.rtl,
            decoration: InputDecoration(
              labelText: 'הקלד/י שוב את הסיסמא',
              prefixIcon: Icon(Icons.lock_outline),
              border: border,
            ),
            obscureText: true,
            validator: (value) {
              if (value != pass.text) {
                return 'סיסמא לא זהה';
              }
              return null;
            },
          ),
          space,
          // name
          TextFormField(
            textDirection: TextDirection.rtl,
            decoration: InputDecoration(
              labelText: 'שם מלא',
              prefixIcon: Icon(Icons.account_circle),
              border: border,
            ),
            onSaved: (val) {
              name = val;
            },
            validator: (value) {
              if (value!.isEmpty) {
                return 'שדה זה הוא חובה';
              }
              return null;
            },
          ),

          Row(
            children: <Widget>[
              Checkbox(
                onChanged: (_) {
                  setState(() {
                    agree = !agree;
                  });
                },
                value: agree,
              ),
              Flexible(
                child: Text(
                    'בלחיצה על כפתור הרשמה אני מאשר/ת את תנאי השימוש והפרטיות'),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),

          // signUP button
          SizedBox(
            height: 50,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();

                  AuthenticationHelper()
                      .signUp(email: email!.trim(), password: password!.trim())
                      .then((result) {
                    print("result " + result.toString());
                    if (result != null && result.toString() != 'weak-password' && result.toString() != 'email-already-in-use') {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => Home(uid: result)));
                    } else {
                      String errorNotification = "";
                      if (result == 'weak-password') {
                        errorNotification = 'הסיסמה חייבת להיות לפחות 6 תווים';
                      } else if (result == 'email-already-in-use') {
                        errorNotification = 'כתובת המייל כבר רשומה';
                      } else {
                        errorNotification = result.toString();
                      }
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                          errorNotification,
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
              child: Text('הרשמה'),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/home.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginWithGoogle extends StatefulWidget {
  const LoginWithGoogle({Key? key}) : super(key: key);

  @override
  _LoginWithGoogleState createState() => _LoginWithGoogleState();
}

class _LoginWithGoogleState extends State<LoginWithGoogle> {
  String userEmail = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login With Google"),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/courts_top_view_sela2.jpeg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [Text("User Email: ", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)), Text(userEmail)],
            //   ),
            // ),
            ElevatedButton(onPressed: () async {
              UserCredential userCredential = await signInWithGoogle();
              print(userCredential);
              if (userCredential.user!.emailVerified) {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => Home(uid: userCredential.user!.uid)));
              }

              setState(() {});
            }, child: Text("Login with google")),

            ElevatedButton(onPressed: () async {
              await FirebaseAuth.instance.signOut();
              userEmail = "";
              await GoogleSignIn().signOut();
              setState(() {

              });
            }, child: Text("Logout"))
          ],
        ),
      ),
    );
  }

  Future<UserCredential> signInWithGoogle() async {
    print("signInWithGoogle");
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    userEmail = googleUser.email;

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
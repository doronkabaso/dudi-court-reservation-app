// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_firebase_auth/login.dart';
// import 'package:flutter_firebase_auth/screens/login_with_google.dart';
// import 'package:flutter_firebase_auth/screens/login_with_phone.dart';
//
// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Login',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: HomeScreen(),
//     );
//   }
// }
//
// class HomeScreen extends StatelessWidget {
//   const HomeScreen({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: Text("Select Option"),
//       ),
//       body: Container(
//         width: MediaQuery.of(context).size.width,
//         decoration: BoxDecoration(
//           image: DecorationImage(
//             image: AssetImage("assets/courts_top_view_sela2.jpeg"),
//             fit: BoxFit.cover,
//           ),
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             ElevatedButton(
//                 onPressed: () {
//                   Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginWithGoogle()));
//                 },
//                 child: Text("Login with google")),
//             ElevatedButton(
//                 onPressed: () {
//                   Navigator.of(context).push(MaterialPageRoute(builder: (context) => Login()));
//                 },
//                 child: Text("Login with email (anonymous)")),
//
//             // ElevatedButton(
//             //     onPressed: () {
//             //       Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginWithFacebook()));
//             //     },
//             //     child: Text("Login with facebook")),
//
//             // ElevatedButton(
//             //     onPressed: () {
//             //       Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginWithPhone()));
//             //     },
//             //     child: Text("Login with Phone")),
//
//             // ElevatedButton(
//             //     onPressed: () {
//             //       Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginWithTwitter()));
//             //     },
//             //     child: Text("Login with Twitter"))
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'login.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'הזמנת מגרשים',
      home: Login(),
    );
  }
}

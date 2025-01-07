import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/home.dart';
import 'package:flutter_firebase_auth/reservation_form.dart';
import 'package:flutter_firebase_auth/screens/login_with_google.dart';
import 'package:flutter_firebase_auth/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MemberSportCenter extends StatefulWidget {
  final String uid;
  const MemberSportCenter({required this.uid});

  @override
  State<MemberSportCenter> createState() => _MemberSportCenterState();
}

class _MemberSportCenterState extends State<MemberSportCenter> {
  @override
  initState() {
    // hasMembership(widget.uid);
  }
  @override
  Widget build(BuildContext context) {
    const appTitle = 'מנוי מרכז הספורט באוניברסיטה';
    final memberNumberCtrl = TextEditingController();
    const vipMemberNumber = '55555';
    Database.getSportCenterMembers().then((result) {
      var members = (result as Map)["members"].cast<String>();
      if (members.contains(widget.uid)) {
        memberNumberCtrl.text = vipMemberNumber;
      }
    });
    return WillPopScope(
      onWillPop: () async {
        return Navigator.canPop(context);
      },
      child: MaterialApp(
        title: appTitle,
        home: Scaffold(
          appBar: AppBar(
            title: const Text(appTitle),
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.home),
                tooltip: 'Home',
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => Home(uid: widget.uid!)));
                },
              ),
            ],
          ),
          endDrawer: Drawer(
            child: ListView(
              // Important: Remove any padding from the ListView.
              padding: EdgeInsets.zero,
              children: [
                const DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                  ),
                  child: Text('הזמנת מגרשים - האקדמיה לטניס של דודי סלג'),
                ),
                ListTile(
                  leading: Icon(
                    Icons.home,
                  ),
                  title: const Text('Home'),
                  onTap: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => Home(uid: widget.uid!)));
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.timer,
                  ),
                  title: const Text('New Reservation'),
                  onTap: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => ReservationForm(uid: widget.uid)));
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.logout,
                  ),
                  title: const Text('logout'),
                  onTap: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => LoginWithGoogle()));
                  },
                ),
              ],
            ),
          ),
          body:Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                SizedBox(height: 20.0,),
                TextFormField(
                    textDirection: TextDirection.rtl,
                    controller: memberNumberCtrl,
                    decoration: InputDecoration(
                    labelText: 'מספר מנוי של מרכז הספורט באוניברסיטה',
                    border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      const Radius.circular(100.0),
                      ),
                    ),
                  ),
                ),
                ElevatedButton(onPressed: () async {
                  if (memberNumberCtrl.text == vipMemberNumber) {
                    Database.getSportCenterMembers().then((result) {
                      var members = (result as Map)["members"].cast<String>();
                      if (!members.contains(widget.uid)) {
                        final FirebaseAuth auth = FirebaseAuth.instance;
                        final User user = auth.currentUser!;
                        // print(get email from uid);
                        members.add(user.uid.toString());
                        Map<String, dynamic> data = {
                          "members": members
                        };
                        Database.addOrUpdateWithId(
                            "sport_center_members", 'ksaAp1oIHwpb6eH6Z5Ig', data);
                        Fluttertoast.showToast(
                            msg: "המייל הוסף למערכת וזכאי לקבל הנחה בהזמנת מגרש",
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.green,
                            textColor: Colors.white,
                            fontSize: 16.0
                        );
                      } else {
                        Fluttertoast.showToast(
                            msg: "המייל כבר קיים כבר במערכת וזכאי לקבל הנחה בהזמנת מגרש",
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.green,
                            textColor: Colors.white,
                            fontSize: 16.0
                        );
                      }
                    });
                  } else {
                    Fluttertoast.showToast(
                        msg: "מספר המנוי לקבלת הנחה אינו נכון",
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.green,
                        textColor: Colors.green,
                        fontSize: 16.0
                    );
                  }
                }, child: Text("אישור")),
              ]
        ),
      ),
      )
      )
    );
  }
}


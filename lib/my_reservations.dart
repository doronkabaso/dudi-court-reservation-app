import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/home.dart';
import 'package:flutter_firebase_auth/login.dart';
import 'package:flutter_firebase_auth/models/reservation.dart';
import 'package:flutter_firebase_auth/reservation_form.dart';
import 'package:flutter_firebase_auth/reservation_tile.dart';
import 'package:flutter_firebase_auth/screens/login_with_google.dart';
import 'package:flutter_firebase_auth/services/database.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MyRservations extends StatefulWidget {
  final String uid;
  const MyRservations({required this.uid});

  @override
  State<MyRservations> createState() => _MyRservationsState();
}

class _MyRservationsState extends State<MyRservations> {
  //inside string use '${widget.uid}'
  List<Reservation> reservations = [];

  @override
  initState() {
    getReservations(widget.uid);
  }
  @override
  Widget build(BuildContext context) {
    const appTitle = 'ההזמנות שלי';
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
          body: ListView.builder(
            itemCount: reservations.length,
            itemBuilder: (context, index) {
              Reservation _reservation = new Reservation(reservations[index].startHour, reservations[index].endHour, reservations[index].courtNumber, reservations[index].date);
              return ReservationTile(reservation: _reservation, deleteReservation: _deleteReservation, index: index);
              }
            ),
          ),
        ),
    );
  }

  void _deleteReservation(int index) {
    showAlertDialog(context, index, reservations);
  }
  void getReservations(String uid) {
    Database.getAllEntries(uid).then((result) {
        List<Reservation> mReservations = [];
        print((result as Map<String, dynamic>)["reservations"]);
        List<dynamic> res = ((result as Map<String, dynamic>)["reservations"]) as List<dynamic>;
        res = new List.from(res.reversed);
        res.forEach((reservation) {
          Reservation _reservation = new Reservation(reservation["startHour"], reservation["endHour"], reservation["courtNumber"], reservation["date"]);
          mReservations.add(_reservation);
        });
        setState(() {
          reservations = mReservations;
        });
    });
  }

  showAlertDialog(BuildContext context, int index, List<dynamic> reservations) {
    // set up the buttons
    Widget cancelButton = FloatingActionButton(
      child: Text("כן"),
      onPressed:  () {
        List<dynamic> mReservations = [];
        int idx = 0;
        reservations.forEach( (element) {
          if (idx != index) {
            mReservations.add({
              "startHour": element.startHour,
              "endHour": element.endHour,
              "courtNumber": element.courtNumber,
              "date": element.date.toString()
            });
          }
          idx = idx + 1;
        });
        Map<String, dynamic> data = {
          "reservations": mReservations
        };

        Database.addOrUpdateWithId("reservations", widget.uid, data);
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => MyRservations(uid: widget.uid!)));
        Fluttertoast.showToast(
            msg: "הביטול בבדיקה הודעת הזיכוי תישלח למייל תוך 3 ימי עסקים",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0
        );
      },
    );
    Widget continueButton = FloatingActionButton(
      child: Text("לא"),
      onPressed:  () {
        Navigator.of(context).pop();
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("ביטול הזמנה"),
      content: Text("האם את/ה בטוח/ה שברצונך לבטל את ההזמנה?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

}


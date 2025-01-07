import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/login.dart';
import 'package:flutter_firebase_auth/member_sport_center.dart';
import 'package:flutter_firebase_auth/my_reservations.dart';
import 'package:flutter_firebase_auth/reservation_form.dart';

class Home extends StatelessWidget {
  final String uid;
  List<String> reservationList = [];
  Home({super.key, required this.uid});

  @override
  Widget build(BuildContext context) {
    const appTitle = 'דודי סלע - הזמנת מגרשים';
    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(
          title: Image.asset('assets/icon_sela.jpeg', height: 55, width: 55),
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
                  child: Text(' הזמנת מגרשים - האקדמיה לטניס של דודי סלע'),
                ),
                ListTile(
                  leading: Icon(
                    Icons.timer,
                  ),
                  title: const Text('הזמנת מגרש'),
                  onTap: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => ReservationForm(uid: uid)));
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.timer,
                  ),
                  title: const Text('ההזמנות שלי'),
                  onTap: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => MyRservations(uid: uid)));
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.logout,
                  ),
                  title: const Text('יציאה'),
                  onTap: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => Login()));
                  },
                ),
              ],
            ),
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
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Expanded(
                  flex: 2, // 10%
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size.fromHeight(40), // fromHeight use double.infinity as width and 40 is the height
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => MyRservations(uid: uid)));
                    } ,
                    child: const Text(
                      'ההזמנות שלי',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                Spacer(),
                Expanded(
                  flex: 2, // 10%
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size.fromHeight(40), // fromHeight use double.infinity as width and 40 is the height
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => ReservationForm(uid: uid)));
                    },
                    child: const Text(
                      'הזמנת מגרש',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                Spacer(),
                Expanded(
                  flex: 2, // 10%
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size.fromHeight(40), // fromHeight use double.infinity as width and 40 is the height
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => MemberSportCenter(uid: uid)));
                    },
                    child: const Text(
                      'מנוי מרכז הספורט',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                Spacer(),
                Expanded(
                  flex: 6, // 40%
                  child: Text('האקדמיה לטניס של דודי סלע \nDudi Sela Tennis Academy',
                      textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 15)),
                )
              ]
          ),
        )
      ),
    );
  }
}
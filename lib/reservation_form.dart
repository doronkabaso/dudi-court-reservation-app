import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/custom_button.dart';
import 'package:flutter_firebase_auth/login.dart';
import 'package:flutter_firebase_auth/my_reservations.dart';
import 'package:flutter_firebase_auth/screens/login_with_google.dart';
import 'package:flutter_firebase_auth/services/database.dart';
import 'package:flutter_firebase_auth/home.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pay/pay.dart';

class ReservationForm extends StatefulWidget {

  final String uid;
  const ReservationForm({super.key, required this.uid});
  @override
  State<StatefulWidget> createState() => _ReservationFormState();

}

class _ReservationFormState extends State<ReservationForm> {

  @override
  void initState() {
    Database.getCourtsData().then((result) {
      setState(() {
        startHrs = (result as Map)["start_time"].cast<int>();
        endHrs = (result as Map)["end_time"].cast<int>();
        iEndHrs = (result as Map)["end_time"].cast<int>();
      });
    });
    super.initState();
  }
  int indexSelectedCourtNumber = -1;
  int indexSelectedStartHour = -1;
  int indexSelectedEndHour = -1;
  int courtNumCtrl = 0;
  int startHrCrtl = 0;
  int endHrCtrl = 0;
  bool isDisabledDate = false;
  bool isVipMember = false;
  String paymentTotal = '0';
  var startHrs = [];
  var endHrs = [];
  var iEndHrs = [];
  var courtNumbers = [];
  DateTime selectedDate = DateTime.now();
  String fSelectedDate = DateTime.now().toLocal().toString().split(' ')[0];
  @override
  Widget build(BuildContext context) {
    const appTitle = 'הזמנת מגרש';
    Future<void> _selectDate(BuildContext context) async {
      final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: DateTime(2015, 8),
          lastDate: DateTime(2101));
      if (picked != null && picked != selectedDate) {
        fSelectedDate = picked.toLocal().toString().split(' ')[0];
        setState(() {
          selectedDate = picked;
        });
        setState(() {
          fSelectedDate = fSelectedDate;
        });

        filterBySelectedDate();
        filterCourtNumber();
        // unsetSelections();

      }
    }
    filterBySelectedDate();
    Database.getSportCenterMembers().then((result) {
      var members = (result as Map)["members"].cast<String>();
      if (members.contains(widget.uid)) {
        setState(() {
          isVipMember = true;
        });
      }
    });
    var _paymentItems = [
      PaymentItem(
        label: 'Total',
        amount: ((endHrCtrl-startHrCrtl)*100).toString(),
        status: PaymentItemStatus.final_price,
      )
    ];

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
                    child: Text('Drawer Header'),
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
                    title: const Text('My Reservations'),
                    onTap: () {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => MyRservations(uid: widget.uid)));
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
            body: Container(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    SizedBox(height: 20.0,),
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 16),
                        child: Text(fSelectedDate, textAlign: TextAlign.left, textDirection: TextDirection.rtl, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18))
                    ),
                    ElevatedButton(
                      onPressed: () => _selectDate(context),
                      child: Text(':או בחר תאריך'),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 16),
                        child: Text('שעת התחלה:', textAlign: TextAlign.left, textDirection: TextDirection.rtl, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18))
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 16),
                      child: Wrap(
                          children: startHrs
                              .map((e) => CustomButton(label: e.toString(), onPress: selectedStartHour, indexButton: startHrs.indexOf(e), pressAttention: indexSelectedStartHour==startHrs.indexOf(e))).toList()
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 16),
                        child: Text('שעת סיום:', textAlign: TextAlign.left, textDirection: TextDirection.rtl, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18))
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 16),
                      child: Wrap(
                          children: endHrs
                              .map((e) => CustomButton(label: e.toString(), onPress: selectedEndHour, indexButton: endHrs.indexOf(e), pressAttention: indexSelectedEndHour==endHrs.indexOf(e))).toList()
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 16),
                        child: Text('מגרש:', textAlign: TextAlign.left, textDirection: TextDirection.rtl, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18))
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 16),
                      child: Wrap(
                          children: courtNumbers
                              .map((e) => CustomButton(label: e.toString(), onPress: selectedCourtNumber, indexButton: courtNumbers.indexOf(e), pressAttention: indexSelectedCourtNumber==courtNumbers.indexOf(e))).toList()
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 16),
                        child: Text('המחיר להזמנת המגרש הוא: ' + paymentTotal + ' שקלים ', textAlign: TextAlign.left, textDirection: TextDirection.rtl, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18))
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 16),
                      child: Container(
                        child: orderButton(_paymentItems)
                      ),
                    ),

                  ],
                ),
              ),
            )
          )
      ),
    );
  }

  void filterBySelectedDate() {
    Database.getCourtsData().then((result) {
      var _startHrs = (result as Map)["start_time"].cast<int>();
      //get all reservations
      Database.getAllDocumentsEntries().then((result) {
        if (result != null) {
          List<dynamic> res = [];
          result.entries.toList().forEach((e) =>
              res.addAll(((e.value as Map<String, dynamic>)["reservations"]) as List<dynamic>)
          );
          res.forEach((reservation) {
            if (reservation["date"] == fSelectedDate) {
              _startHrs.remove(fSelectedDate);
            }
          });
        }
        setState(() {
          startHrs = _startHrs;
        });
      });
    });
  }

  void unsetSelections() {
    setState(() => indexSelectedStartHour = -1);
    setState(() => indexSelectedEndHour = -1);
    setState(() => indexSelectedCourtNumber = -1);
  }
  void selectedStartHour(String label, int indexButton) {
      if (indexSelectedStartHour != indexButton) {
        setState(() => indexSelectedStartHour = indexButton);
        setState(() => startHrCrtl = int.parse(label));

        var _endHrs = [];
        iEndHrs.forEach((element) {
          if (element > int.parse(label)) {
            _endHrs.add(element);
          }
        });
        setState(() => endHrs = _endHrs);
      }
  }
  void selectedEndHour(String label, int indexButton) {
    if (indexSelectedEndHour != indexButton) {
      setState(() => indexSelectedEndHour = indexButton);
      setState(() => endHrCtrl = int.parse(label));
      //filter court numbers
      filterCourtNumber();
    }
  }

  void filterCourtNumber() {
    Database.getCourtsData().then((result) {
      var _courtNumbers = (result as Map)["court_numbers"].cast<int>();
      //get all reservations
      Database.getAllDocumentsEntries().then((result) {
        if (result != null) {
          List<dynamic> res = [];
          result.entries.toList().forEach((e) =>
              res.addAll(((e.value as Map<String, dynamic>)["reservations"]) as List<dynamic>)
          );
          res.forEach((reservation) {
            if (reservation["date"] == fSelectedDate &&
                reservation["startHour"] == startHrCrtl) {
              //filter reserved court number
              _courtNumbers.remove(reservation["courtNumber"]);
            }
          });
        }
        setState(() {
          courtNumbers = _courtNumbers;
        });
      });
    });
  }
  void selectedCourtNumber(String label, int indexButton) {
    if (indexSelectedCourtNumber != indexButton) {
      setState(() => indexSelectedCourtNumber = indexButton);
      setState(() => courtNumCtrl = int.parse(label));
    }
  }

  void updateCourtReserved() {
    Database.getAllEntries(widget.uid).then((result) {
      List<dynamic> mReservations = [];
      if (result != null) {
        List<dynamic> res = ((result as Map<String,
            dynamic>)["reservations"]) as List<dynamic>;
        res.forEach((reservation) {
          mReservations.add({
            "startHour": reservation["startHour"],
            "endHour": reservation["endHour"],
            "courtNumber": reservation["courtNumber"],
            "date": reservation["date"]
          });
        });
      }
      mReservations.add({
        "startHour": startHrCrtl,
        "endHour": endHrCtrl,
        "courtNumber": courtNumCtrl,
        "date": selectedDate.toLocal().toString().split(' ')[0]
      });
      Map<String, dynamic> data = {
        "reservations": mReservations
      };
      Database.addOrUpdateWithId(
          "reservations", widget.uid, data);
      Fluttertoast.showToast(
          msg: "המגרש הוזמן",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0
      );
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => MyRservations(uid: widget.uid!)));
    });
  }
  void onGooglePayResult(dynamic paymentResult) {
    // Send the resulting Google Pay token to your server / PSP
    updateCourtReserved();
  }

  Widget orderButton(dynamic _paymentItems) {
    var _paymentTotal = ((endHrCtrl-startHrCrtl)*100).toString();
    if (isVipMember) {
      _paymentTotal = ((endHrCtrl-startHrCrtl)*80).toString();
      _paymentItems[0] = PaymentItem(
        label: 'Total',
        amount: _paymentTotal,
        status: PaymentItemStatus.final_price,
      );
    }
    setState(() {
      paymentTotal= _paymentTotal;
    });
    if (int.parse(paymentTotal)<0) {
      setState(() {
        paymentTotal="0";
      });
    }
    return (indexSelectedCourtNumber != -1 && indexSelectedStartHour != -1 && indexSelectedEndHour != -1 && startHrCrtl<endHrCtrl)
        ? 
    Container(
      alignment: Alignment.center,
      child: GooglePayButton(
                paymentConfigurationAsset: 'google_pay.json',
                paymentItems: _paymentItems,
                type: GooglePayButtonType.order,
                margin: const EdgeInsets.only(top: 15.0),
                onPaymentResult: onGooglePayResult,
                loadingIndicator: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
    )
        : Text('כל השדות הם חובה');
  }
}

// ElevatedButton(
// onPressed: () {
// if (indexSelectedDate != -1 && indexSelectedCourtNumber != -1 && indexSelectedStartHour != -1 && indexSelectedEndHour != -1 && startHrCrtl<endHrCtrl) {
// return
// updateCourtReserved();
// } else {
// Fluttertoast.showToast(
// msg: "הזמנת המגרש נכשלה",
// toastLength: Toast.LENGTH_LONG,
// gravity: ToastGravity.BOTTOM,
// timeInSecForIosWeb: 1,
// backgroundColor: Colors.red,
// textColor: Colors.white,
// fontSize: 16.0
// );
// };
// },
// ),
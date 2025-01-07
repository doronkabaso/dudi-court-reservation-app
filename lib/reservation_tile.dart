import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/reservation.dart';

class ReservationTile extends StatelessWidget {
  final Reservation? reservation;
  final Function? deleteReservation;
  final int? index;
  ReservationTile({this.reservation, this.deleteReservation, this.index});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 8.0),
        child: Card(
          margin: EdgeInsets.fromLTRB(20, 6, 20, 0),
          child: ListTile(
            title: Text(reservation!.date),
            subtitle: Text(reservation!.endHour.toString()  + ' <- ' + reservation!.startHour.toString() + ' שעה ' + "\n" +
                reservation!.courtNumber.toString() + ':מגרש'
                 ),
            trailing: IconButton(
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
              onPressed: (){
                deleteReservation!(index);
                // widget.function
                // setState(() {
                //   colors.removeAt(index);
                // });
              },
            ),
          ),
        ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:international_phone_input/international_phone_input.dart';
import 'package:thesis/models/Booking.dart';
import 'package:thesis/models/Restaurant.dart';
import 'package:thesis/repositories/DineEasyRepository.dart';
import 'package:thesis/widgets/DEDropDownButton.dart';

class ReservePopUp extends StatefulWidget {
  final Restaurant _restaurant;

  ReservePopUp(this._restaurant);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ReservePopUpState(_restaurant);
  }
}

class ReservePopUpState extends State<ReservePopUp> {
  String phoneNumber;
  String phoneIsoCode;
  String confirmedNumber = '';
  final _dineEasyRepository = DineEasyRepository();

  void onPhoneNumberChange(String number, String internationalizedPhoneNumber, String isoCode) {
    print(number);
    setState(() {
      phoneNumber = number;
      phoneIsoCode = isoCode;
    });
  }

  void onValidPhoneNumber(String number, String internationalizedPhoneNumber, String isoCode) {
    setState(() {
      confirmedNumber = internationalizedPhoneNumber;
    });
  }

  final Restaurant _restaurant;
  TextEditingController _nrOfPeopleController;
  TextEditingController _nameController;
  int selectedTime;

  Future<Booking> reservationFuture = null;

  ReservePopUpState(this._restaurant);

  @override
  void initState() {
    super.initState();
    selectedTime = _restaurant.availableTimes.first;
    _nrOfPeopleController = TextEditingController(text: '2');
    _nameController = TextEditingController(text: "Jmeno");
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_restaurant.name),
      content: SingleChildScrollView(child: Builder(
        builder: (BuildContext context) {
          if (reservationFuture == null) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: "Name"),
                ),
                InternationalPhoneInput(
                    onPhoneNumberChange: onPhoneNumberChange,
                    initialPhoneNumber: phoneNumber,
                    initialSelection: phoneIsoCode,
                    enabledCountries: ['+45', '+420'],
                    decoration: InputDecoration(labelText: "Phone Number")),
                TextField(
                  decoration: InputDecoration(labelText: "Number of people"),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    WhitelistingTextInputFormatter.digitsOnly //TODO add min max formater
                  ], // Only numbers can be enteredmbers can b
                  maxLength: 2,
                  controller: _nrOfPeopleController,
                ),
                //TODO figure out better way to cast this
                DEDropDownButton("Time of reservation", selectedTime, _restaurant.availableTimes, <any>(Object i) {
                  int s = int.parse(i.toString());
                  return "${s ~/ 60}:${s % 60}";
                })
              ],
            );
          }
          return FutureBuilder(
            future: reservationFuture,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Theme.of(context).accentColor),
                );
              }
              if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              }

              return Text("Reservation sucessfull");
            },
          );
        },
      )),
      actions: reservationFuture == null
          ? <Widget>[
              FlatButton(
                child: Text("Cancel"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text("Reserve"),
                onPressed: () {
                  setState(() {
                    reservationFuture = _dineEasyRepository.makeReservation(phoneNumber, _nameController.value, _nrOfPeopleController.value, selectedTime);
                    //TODO solve case when widget is closed
                  });
                },
              )
            ]
          : <Widget>[
              FlatButton(
                child: Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
    );
  }
}

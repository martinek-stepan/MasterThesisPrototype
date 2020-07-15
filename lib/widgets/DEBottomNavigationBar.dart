import 'package:flutter/material.dart';
import 'package:thesis/screens/DEBookingsScreen.dart';
import 'package:thesis/screens/DERestaurantsScreen.dart';
import 'package:thesis/screens/DEUserScreen.dart';

// Bottom Navigation Bar, show main navigation routes with current one highlighted and clean navigator when of them is pressed or pop last if current is pressed
class DEBottomNavigationBar extends StatelessWidget {
  final int _currentIndex;
  final bool backOnSameIndex;

  DEBottomNavigationBar(this._currentIndex, {this.backOnSameIndex = false});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (index) {
        if (index == _currentIndex) {
          if (backOnSameIndex) {
            Navigator.pop(context);
          }
          return;
        }
        switch (index) {
          case 0:
            Navigator.of(context).pushNamedAndRemoveUntil(DEBookingsScreen.routeName, (Route<dynamic> route) => false);
            break;
          case 1:
            Navigator.of(context).pushNamedAndRemoveUntil(DERestaurantsScreen.routeName, (Route<dynamic> route) => false);
            break;
          case 2:
            Navigator.of(context).pushNamedAndRemoveUntil(DEUserScreen.routeName, (Route<dynamic> route) => false);
            break;
        }
      },
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today),
          title: Text('Bookings'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.restaurant),
          title: Text('Restaurants'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle),
          title: Text('Profile'),
        ),
      ],
    );
  }
}

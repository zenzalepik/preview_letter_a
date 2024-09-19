import 'package:flutter/material.dart';
import 'package:letter_a/pages/user/client/home/home_page.dart';
import 'package:letter_a/pages/user/client/info/info_page.dart';
import 'package:letter_a/pages/user/client/message/list_message_page.dart';
import 'package:letter_a/pages/user/client/profile/profile_client_page.dart';
import 'package:letter_a/pages/user/client/statistik/statistik_page.dart';
import 'package:letter_a/styles/colors_style.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 2;

  static List<Widget> _widgetOptions = <Widget>[
    // Isi dengan widget halaman untuk setiap tab
    InfoPage(),
    StatistikPage(),
    HomePage(),
    ListMessagePage(),
    MyProfileClientPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'Info',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Stat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Message',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: LColors.primary,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}

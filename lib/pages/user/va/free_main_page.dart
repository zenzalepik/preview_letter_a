import 'package:flutter/material.dart';
import 'package:letter_a/pages/user/client/home/home_page.dart';
import 'package:letter_a/pages/user/client/info/info_page.dart';
import 'package:letter_a/pages/user/client/message/list_message_page.dart';
import 'package:letter_a/pages/user/client/profile/profile_client_page.dart';
import 'package:letter_a/pages/user/client/statistik/statistik_page.dart';
import 'package:letter_a/pages/user/va/home/free_home_page.dart';
import 'package:letter_a/pages/user/va/info/free_info_page.dart';
import 'package:letter_a/pages/user/va/message/free_list_message_page.dart';
import 'package:letter_a/pages/user/va/profile/free_profile_page.dart';
import 'package:letter_a/pages/user/va/statistik/free_statistik_page.dart';
import 'package:letter_a/styles/colors_style.dart';

class FreeMainPage extends StatefulWidget {
  final String index;
  FreeMainPage({Key? key, this.index = ''}) : super(key: key);

  @override
  _FreeMainPageState createState() => _FreeMainPageState();
}

class _FreeMainPageState extends State<FreeMainPage> {
  int _selectedIndex = 2;

  @override
  void initState() {
    super.initState();
    widget.index == ''
        ? _selectedIndex = 2
        : _selectedIndex = int.parse(widget.index);
  }

  static List<Widget> _widgetOptions = <Widget>[
    // Isi dengan widget halaman untuk setiap tab
    FreeInfoPage(),
    FreeStatistikPage(),
    FreeHomePage(),
    FreeListMessagePage(),
    FreeMyProfilePage(),
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

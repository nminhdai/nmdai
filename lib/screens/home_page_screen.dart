import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_todo_app/screens/create_note_screen.dart';
import 'package:flutter_firebase_todo_app/screens/documents_screen.dart';
import 'package:flutter_firebase_todo_app/screens/notes_screen.dart';
import 'package:flutter_firebase_todo_app/screens/user_info_screen.dart';
import 'package:get/get.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({Key key, User user})
      : _user = user,
        super(key: key);

  final User _user;
  @override
  _HomePageScreenState createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 1) {
        Get.to(() => CreateNote());
        _selectedIndex = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black12,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text('Event'),
                Icon(Icons.arrow_drop_down),
              ],
            ),
            IconButton(
              icon: Icon(Icons.account_circle_outlined),
              onPressed: () {
                Get.to(() => UserInfoScreen(user: widget._user));
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        backgroundColor: Colors.black87,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 32, color: Colors.white),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Container(
              height: 52,
              width: 52,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    Colors.indigoAccent,
                    Colors.purple,
                  ],
                ),
              ),
              child: Icon(
                Icons.add,
                size: 32,
                color: Colors.white,
              ),
            ),
            label: "Add",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.file_present, size: 30, color: Colors.white),
            label: "Setting",
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
      body: _selectedIndex == 0 ? MyNotes() : DocumentsScreen(),
    );
  }
}

Widget a() {
  return DefaultTabController(
    length: 3,
    child: Scaffold(
      body: TabBarView(
        children: [
          MyNotes(),
          CreateNote(),
          DocumentsScreen(), // alternative TaskManager()
        ],
      ),
      bottomNavigationBar: TabBar(
        //indicatorColor: Theme.of(context).primaryColor,
        //labelColor: Theme.of(context).primaryColor,
        tabs: [
          Tab(icon: Icon(Icons.home)),
          Tab(icon: Icon(Icons.add)),
          Tab(icon: Icon(Icons.file_present)),
        ],
      ),
    ),
  );
}

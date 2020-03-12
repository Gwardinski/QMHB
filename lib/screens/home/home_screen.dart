import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/screens/library/library_screen.dart';
import 'package:qmhb/screens/play/play_screen.dart';
import 'package:qmhb/screens/questions/questions_page.dart';
import 'package:qmhb/services/database.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  List<Widget> pages = [
    LibraryScreen(),
    QuestionsScreen(),
    PlayScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider(
          create: (BuildContext context) => DatabaseService().questions,
        ),
      ],
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          body: pages.elementAt(_selectedIndex),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.amber[800],
            onTap: _onItemTapped,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                title: Text('Home'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.library_books),
                title: Text('Questions'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.play_arrow),
                title: Text('Play'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:qmhb/screens/explore_screen/explore_screen.dart';
import 'package:qmhb/screens/library/library_screen.dart';
import 'package:qmhb/screens/play/play_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  List<Widget> pages = [
    ExploreScreen(),
    PlayScreen(),
    LibraryScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: pages.elementAt(_selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.amber[800],
          onTap: _onItemTapped,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              title: Text('Explore'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.play_arrow),
              title: Text('Play'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text('Library'),
            ),
          ],
        ),
      ),
    );
  }
}

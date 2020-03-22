import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/models/user_model.dart';
import 'package:qmhb/screens/authentication/authentication_screen.dart';
import 'package:qmhb/screens/explore_screen/explore_screen.dart';
import 'package:qmhb/screens/library/library_screen.dart';
import 'package:qmhb/screens/play/play_screen.dart';
import 'package:qmhb/services/database.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  List<Widget> pages = [
    LibraryScreen(),
    ExploreScreen(),
    PlayScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isAuthenticated = Provider.of<UserDataStateModel>(context).isAuthenticated;
    return isAuthenticated != true
        ? AuthenticationScreen()
        : UserListener(
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
                      title: Text('Library'),
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.search),
                      title: Text('Explore'),
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

class UserListener extends StatefulWidget {
  final child;
  UserListener({
    @required this.child,
  });

  @override
  _UserListenerState createState() => _UserListenerState();
}

class _UserListenerState extends State<UserListener> {
  UserDataStateModel _userDataStateModel;
  DatabaseService _databaseService;
  @override
  Widget build(BuildContext context) {
    _userDataStateModel = Provider.of<UserDataStateModel>(context);
    _databaseService = Provider.of<DatabaseService>(context);
    UserModel userModel = _userDataStateModel.user;
    String lastUpdated = _userDataStateModel.lastUpdated;
    return StreamBuilder(
      stream: DatabaseService().getUserStream(userModel.uid),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          UserModel newUserModel = snapshot.data;
          UserModel currentUserModel = _userDataStateModel.user;
          bool hasUpdated = newUserModel.lastUpdated != lastUpdated;
          if (hasUpdated) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _updateRecentActivity(
                newUserModel: newUserModel,
                currentUserModel: currentUserModel,
              );
              _userDataStateModel.updateCurrentUser(newUserModel);
            });
          }
          // call _updateRecentActivity on first time loading app ?
        }
        return widget.child;
      },
    );
  }

  _updateRecentActivity({UserModel newUserModel, UserModel currentUserModel}) async {
    if (newUserModel.recentQuizIds != currentUserModel.recentQuizIds) {
      _userDataStateModel.recentQuizzes = await _databaseService.getQuizzesByIds(
        newUserModel.recentQuizIds,
      );
    }
    if (newUserModel.recentRoundIds != currentUserModel.recentRoundIds) {
      _userDataStateModel.recentRounds = await _databaseService.getRoundsByIds(
        newUserModel.recentRoundIds,
      );
    }
    if (newUserModel.recentQuestionIds != currentUserModel.recentQuestionIds) {
      _userDataStateModel.recentQuestions = await _databaseService.getQuestionsByIds(
        newUserModel.recentQuestionIds,
      );
    }
  }
}

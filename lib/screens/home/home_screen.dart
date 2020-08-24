import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/get_it.dart';
import 'package:qmhb/models/state_models/app_size.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/models/user_model.dart';
import 'package:qmhb/screens/explore_screen/explore_screen.dart';
import 'package:qmhb/screens/home/widgets/main_nav_button.dart';
import 'package:qmhb/screens/library/library_screen.dart';
import 'package:qmhb/screens/play/play_screen.dart';
import 'package:qmhb/services/authentication_service.dart';

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
  final AuthenticationService _authService = AuthenticationService();
  final globalKey = GlobalKey<ScaffoldState>();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    autoSignIn();
  }

  void autoSignIn() async {
    UserModel userModel = await _authService.autoSignIn();
    if (userModel != null) {
      final userDataStateModel = Provider.of<UserDataStateModel>(context);
      userDataStateModel.updateCurrentUser(userModel);
      final snackBar = SnackBar(content: Text('Signed In'));
      globalKey.currentState.showSnackBar(snackBar);
    } else {
      UserModel userModel = await _authService.signInWithEmailAndPassword(
        email: "g1@test.com",
        password: "qqqqqqqqqq",
      );
      if (userModel != null) {
        final userDataStateModel = Provider.of<UserDataStateModel>(context);
        userDataStateModel.updateCurrentUser(userModel);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    bool useLargeLayout = MediaQuery.of(context).size.width > 800;
    getIt<AppSize>().updateSize(useLargeLayout);
    return MultiProvider(
      providers: [],
      child: useLargeLayout
          ? Scaffold(
              key: globalKey,
              body: Row(
                children: [
                  useLargeLayout
                      ? Container(
                          width: 200,
                          padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                          color: Theme.of(context).primaryColor,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                height: 128,
                              ),
                              MainNavigationButton(
                                title: "Library",
                                icon: Icons.home,
                                isSelected: _selectedIndex == 0,
                                onPressed: () {
                                  _onItemTapped(0);
                                },
                              ),
                              MainNavigationButton(
                                title: "Explore",
                                icon: Icons.search,
                                isSelected: _selectedIndex == 1,
                                onPressed: () {
                                  _onItemTapped(1);
                                },
                              ),
                              MainNavigationButton(
                                title: "Play",
                                icon: Icons.play_arrow,
                                isSelected: _selectedIndex == 2,
                                onPressed: () {
                                  _onItemTapped(2);
                                },
                              ),
                            ],
                          ),
                        )
                      : null,
                  Expanded(child: pages.elementAt(_selectedIndex))
                ],
              ),
            )
          : DefaultTabController(
              length: 3,
              child: Scaffold(
                body: pages.elementAt(_selectedIndex),
                bottomNavigationBar: BottomNavigationBar(
                  currentIndex: _selectedIndex,
                  selectedItemColor: Theme.of(context).accentColor,
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

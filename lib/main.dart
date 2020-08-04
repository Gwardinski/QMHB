import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/screens/home/home_screen.dart';
import 'package:qmhb/services/database.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserDataStateModel>(
          create: (BuildContext context) => UserDataStateModel(),
        ),
        ChangeNotifierProvider<RecentActivityStateModel>(
          create: (BuildContext context) => RecentActivityStateModel(),
        ),
        Provider<DatabaseService>(
          create: (BuildContext context) => DatabaseService(),
        ),
      ],
      child: MaterialApp(
        title: 'QMHB Demo',
        theme: ThemeData.dark().copyWith(
          accentColor: Color(0xffFFA630),
        ),
        home: HomeScreen(),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/state_models/authentication_state_model.dart';
import 'package:qmhb/screens/home/auth_wrapper.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthenticationStateModel>(
          create: (BuildContext context) => AuthenticationStateModel(),
        ),
      ],
      child: MaterialApp(
        title: 'QMHB Demo',
        theme: ThemeData.dark(),
        home: AuthWrapper(),
      ),
    );
  }
}

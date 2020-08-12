import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/get_it.dart';
import 'package:qmhb/models/state_models/app_size.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/screens/home/home_screen.dart';
import 'package:qmhb/services/database.dart';
import 'package:qmhb/services/question_collection_service.dart';
import 'package:qmhb/services/quiz_colection_service.dart';
import 'package:qmhb/services/round_collection_service.dart';
import 'package:qmhb/services/user_collection_service.dart';

void main() {
  getIt.registerSingleton<AppSize>(AppSize());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserDataStateModel>(
          create: (BuildContext context) => UserDataStateModel(),
        ),
        Provider<DatabaseService>(
          create: (BuildContext context) => DatabaseService(),
        ),
        Provider<UserCollectionService>(
          create: (BuildContext context) => UserCollectionService(),
        ),
        Provider<QuestionCollectionService>(
          create: (BuildContext context) => QuestionCollectionService(),
        ),
        Provider<RoundCollectionService>(
          create: (BuildContext context) => RoundCollectionService(),
        ),
        Provider<QuizCollectionService>(
          create: (BuildContext context) => QuizCollectionService(),
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

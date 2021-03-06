import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/get_it.dart';
import 'package:qmhb/models/state_models/app_size.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/pages/home/home_page.dart';
import 'package:qmhb/services/explore_service.dart';
import 'package:qmhb/services/http_service.dart';
import 'package:qmhb/services/navigation_service.dart';
import 'package:qmhb/services/question_service.dart';
import 'package:qmhb/services/quiz_service.dart';
import 'package:qmhb/services/refresh_service.dart';
import 'package:qmhb/services/round_service.dart';
import 'package:qmhb/services/storage.dart';
import 'package:qmhb/services/user_service.dart';
import 'package:qmhb/shared/widgets/loading_spinner.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  getIt.registerSingleton<AppSize>(AppSize());
  runApp(InitialiserWidget());
}

class InitialiserWidget extends StatelessWidget {
  _init() async {
    final localStorageService = LocalStorageService();
    await localStorageService.init();
    return localStorageService;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        accentColor: Color(0xffFFA630),
      ),
      home: FutureBuilder(
        future: _init(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return MyApp(
              localStorageService: snapshot.data,
            );
          }
          return LoadingSpinnerHourGlass();
        },
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  final LocalStorageService localStorageService;

  MyApp({
    this.localStorageService,
  });

  @override
  Widget build(BuildContext context) {
    final NavigationService navigationService = NavigationService();
    final HttpService httpService = HttpService();
    final UserDataStateModel userDataStateModel = UserDataStateModel(
      localStorageService: localStorageService,
    );
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserDataStateModel>(
          create: (BuildContext context) => userDataStateModel,
        ),
        Provider<UserService>(
          create: (BuildContext context) => UserService(
            httpService: httpService,
            userDataStateModel: userDataStateModel,
          ),
        ),
        Provider<NavigationService>(
          create: (BuildContext context) => navigationService,
        ),
        Provider<RefreshService>(
          create: (BuildContext context) => RefreshService(),
        ),
        Provider<QuestionService>(
          create: (BuildContext context) => QuestionService(
            httpService: httpService,
          ),
        ),
        Provider<RoundService>(
          create: (BuildContext context) => RoundService(
            httpService: httpService,
          ),
        ),
        Provider<QuizService>(
          create: (BuildContext context) => QuizService(
            httpService: httpService,
          ),
        ),
        Provider<ExploreService>(
          create: (BuildContext context) => ExploreService(
            httpService: httpService,
          ),
        ),
      ],
      child: HomePage(),
    );
  }
}

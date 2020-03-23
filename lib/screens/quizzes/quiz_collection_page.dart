import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/quiz_model.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/screens/quizzes/quiz_add_page.dart';
import 'package:qmhb/screens/quizzes/quiz_list_item.dart';
import 'package:qmhb/services/database.dart';
import 'package:qmhb/shared/widgets/loading_spinner.dart';

class QuizCollectionPage extends StatefulWidget {
  @override
  _QuizCollectionPageState createState() => _QuizCollectionPageState();
}

class _QuizCollectionPageState extends State<QuizCollectionPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final user = Provider.of<UserDataStateModel>(context).user;
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Quizzes"),
        actions: <Widget>[
          FlatButton(
            child: Text('Create New Quiz'),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => QuizAddPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: DatabaseService().getQuizzesByIds(user.quizIds),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: LoadingSpinnerHourGlass(),
            );
          }
          if (snapshot.hasError == true) {
            return Center(
              child: Text("Could not load content :("),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data.length ?? 0,
            scrollDirection: Axis.vertical,
            itemBuilder: (BuildContext context, int index) {
              bool isEven = index.isEven;
              QuizModel quizModel = snapshot.data[index];
              return QuizListItem(
                quizModel: quizModel,
                isEven: isEven,
              );
            },
          );
        },
      ),
    );
  }
}

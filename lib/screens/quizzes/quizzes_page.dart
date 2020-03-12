import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/quiz_model.dart';
import 'package:qmhb/models/state_models/authentication_state_model.dart';
import 'package:qmhb/services/database.dart';
import 'package:qmhb/shared/widgets/loading_spinner.dart';

class QuizzesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthenticationStateModel>(context).user;
    return Scaffold(
      appBar: AppBar(
        title: Text("Quizzes"),
      ),
      body: FutureBuilder(
        future: DatabaseService().getUsersQuizzes(user.quizIds),
        builder: (BuildContext context, AsyncSnapshot<List<QuizModel>> snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error.toString());
            return Container(
              child: Text("err"),
            );
          }
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return Text(snapshot.data[index].title);
              },
            );
          } else {
            return LoadingSpinnerHourGlass();
          }
        },
      ),
    );
  }
}

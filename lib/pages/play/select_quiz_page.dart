import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/quiz_model.dart';
import 'package:qmhb/services/quiz_service.dart';
import 'package:qmhb/shared/widgets/error_message.dart';
import 'package:qmhb/shared/widgets/loading_spinner.dart';
import 'package:qmhb/shared/widgets/quiz_list_item/quiz_list_item.dart';

class SelectQuizToPlayPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text("Select Quiz"),
        ),
        body: Column(
          children: [
            Expanded(
              child: FutureBuilder(
                future: Provider.of<QuizService>(context).getUserQuizzes(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: LoadingSpinnerHourGlass(),
                    );
                  }
                  if (snapshot.hasError == true) {
                    return ErrorMessage(message: "An error occured loading your Quizzes");
                  }
                  return snapshot.data.length > 0
                      ? ListView.separated(
                          separatorBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: EdgeInsets.only(bottom: 8),
                            );
                          },
                          itemCount: snapshot.data.length ?? 0,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (BuildContext context, int index) {
                            QuizModel quizModel = snapshot.data[index];
                            return QuizListItem(
                              quizModel: quizModel,
                              play: true,
                            );
                          },
                        )
                      : Padding(
                          padding: EdgeInsets.only(top: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "You have not created any Quizzes. Head to the Library tab to create your own or head to the explore tab to save a pre-created Quiz",
                              ),
                            ],
                          ),
                        );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
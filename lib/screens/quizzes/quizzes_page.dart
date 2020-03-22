import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/services/database.dart';
import 'package:qmhb/shared/widgets/loading_spinner.dart';
import 'package:qmhb/shared/widgets/star_rating.dart';

class QuizzesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserDataStateModel>(context).user;
    return Scaffold(
      appBar: AppBar(
        title: Text("Quizzes"),
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
              return Container(
                height: 120,
                padding: EdgeInsets.all(8),
                color: isEven ? Colors.grey[100] : Colors.grey[400],
                child: Row(
                  children: [
                    Container(
                      height: 104,
                      width: 104,
                      color: Colors.blue,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        right: 8,
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            "yo",
                            maxLines: 2,
                          ),
                          Text("yo"),
                          Text("yo"),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          StarRatingRow(
                            rating: 5,
                          ),
                          Text("yo"),
                          Text("yo"),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

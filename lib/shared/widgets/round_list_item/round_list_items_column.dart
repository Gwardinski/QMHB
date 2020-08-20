import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/question_model.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/screens/library/rounds/round_editor_page.dart';
import 'package:qmhb/screens/library/widgets/round_editor.dart';
import 'package:qmhb/services/round_collection_service.dart';
import 'package:qmhb/shared/widgets/loading_spinner.dart';
import 'package:qmhb/shared/widgets/round_list_item/round_list_item.dart';

class RoundListItemsColumn extends StatelessWidget {
  RoundListItemsColumn({
    Key key,
    @required this.rounds,
  }) : super(key: key);

  final rounds;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (BuildContext context, int index) {
        return Padding(
          padding: EdgeInsets.only(bottom: 8),
        );
      },
      itemCount: rounds.length ?? 0,
      scrollDirection: Axis.vertical,
      itemBuilder: (BuildContext context, int index) {
        RoundModel roundModel = rounds[index];
        return RoundListItem(
          roundModel: roundModel,
        );
      },
    );
  }
}

// todo move all below to own file
class UserRoundSidebar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserDataStateModel>(context).user;
    return Container(
      width: 256,
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(
            color: Colors.grey,
            width: 1.0,
          ),
        ),
      ),
      child: Column(
        children: [
          UserRoundSidebarTitle(),
          UserRoundSidebarNewRound(),
          Expanded(
            child: StreamBuilder(
              stream: RoundCollectionService().getRoundsCreatedByUser(
                userId: user.uid,
              ),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: LoadingSpinnerHourGlass(),
                  );
                }
                if (snapshot.hasError == true) {
                  print(snapshot.error);
                  return Center(
                    child: Text("Can't load your Rounds"),
                  );
                }
                return snapshot.data.length > 0
                    ? ListView.builder(
                        itemCount: snapshot.data.length ?? 0,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (BuildContext context, int index) {
                          return UserRoundSidebarItem(roundModel: snapshot.data[index]);
                        },
                      )
                    : Container();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class UserRoundSidebarTitle extends StatelessWidget {
  const UserRoundSidebarTitle({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      padding: EdgeInsets.all(16),
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Your Rounds:",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class UserRoundSidebarNewRound extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => RoundEditorPage(
              type: RoundEditorType.ADD,
            ),
          ),
        );
      },
      child: Container(
        height: 64,
        padding: EdgeInsets.all(16),
        child: Center(
          child: Row(
            children: [
              Icon(
                Icons.add,
              ),
              Container(
                padding: EdgeInsets.only(left: 16),
                child: Text(
                  "New Round",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UserRoundSidebarItem extends StatelessWidget {
  const UserRoundSidebarItem({
    @required this.roundModel,
  });

  final RoundModel roundModel;

  @override
  Widget build(BuildContext context) {
    return DragTarget<QuestionModel>(
      onWillAccept: (question) => !roundModel.questionIds.contains(question.id),
      onAccept: (question) {
        RoundCollectionService().addQuestionToRound(roundModel, question);
      },
      builder: (context, canditates, rejects) {
        return InkWell(
          onTap: () {
            print("todo - Update view with just the question in this round");
          },
          child: Container(
            height: 64,
            padding: EdgeInsets.all(16),
            child: Center(
              child: Container(
                width: double.infinity,
                child: Text(
                  roundModel.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

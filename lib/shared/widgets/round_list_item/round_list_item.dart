import 'package:flutter/material.dart';
import 'package:qmhb/get_it.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/models/state_models/app_size.dart';
import 'package:qmhb/pages/details/round/round_details_page.dart';
import 'package:qmhb/shared/widgets/drag_feedback.dart';
import 'package:qmhb/shared/widgets/list_item/list_item_background_image.dart';
import 'package:qmhb/shared/widgets/list_item/list_item_details.dart';
import 'package:qmhb/shared/widgets/round_list_item/round_list_item_action.dart';

class DraggableRoundListItem extends StatelessWidget {
  final RoundModel roundModel;
  final Function onDragStarted;
  final Function onDragEnd;

  DraggableRoundListItem({
    Key key,
    @required this.roundModel,
    @required this.onDragStarted,
    @required this.onDragEnd,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Draggable<RoundModel>(
      onDragStarted: onDragStarted,
      onDragEnd: onDragEnd,
      dragAnchor: DragAnchor.pointer,
      data: roundModel,
      feedback: DragFeedback(
        title: roundModel.title,
      ),
      child: RoundListItem(
        roundModel: roundModel,
      ),
    );
  }
}

class RoundListItem extends StatelessWidget {
  final RoundModel roundModel;

  RoundListItem({
    Key key,
    @required this.roundModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => RoundDetailsPage(
              roundModel: roundModel,
            ),
          ),
        );
      },
      child: Container(
        height: 112,
        child: Stack(
          children: [
            ItemBackgroundImage(imageUrl: roundModel.imageUrl),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                height: 112,
                width: 64,
                color: Theme.of(context).canvasColor,
              ),
            ),
            Container(
              height: 112,
              margin: EdgeInsets.fromLTRB(16, 8, 0, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ListItemDetails(
                    title: roundModel.title,
                    description: roundModel.description,
                    info1Title: "Points: ",
                    info1Value: roundModel.totalPoints.toString(),
                    info2Title: "Questions: ",
                    info2Value: roundModel.questions.length.toString(),
                    info3Title: null,
                    info3Value: null,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: getIt<AppSize>().lOnly16),
                    child: RoundListItemAction(
                      roundModel: roundModel,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

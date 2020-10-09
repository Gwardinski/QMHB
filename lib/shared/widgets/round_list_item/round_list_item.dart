import 'package:flutter/material.dart';
import 'package:qmhb/get_it.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/models/state_models/app_size.dart';
import 'package:qmhb/screens/details/round/round_details_page.dart';
import 'package:qmhb/shared/widgets/drag_feedback.dart';
import 'package:qmhb/shared/widgets/round_list_item/round_list_item_action.dart';
import 'package:qmhb/shared/widgets/round_list_item/round_list_item_details.dart';

enum RoundOptions { save, edit, delete, details, addToQuiz, publish }

class RoundListItem extends StatefulWidget {
  final RoundModel roundModel;
  final bool canDrag;

  RoundListItem({
    Key key,
    @required this.roundModel,
    this.canDrag = false,
  }) : super(key: key);

  @override
  _RoundListItemState createState() => _RoundListItemState();
}

class _RoundListItemState extends State<RoundListItem> {
  @override
  Widget build(BuildContext context) {
    final listItemContent = RoundListItemContent(
      roundModel: widget.roundModel,
      viewQuestionDetails: _viewRoundDetails,
    );
    return widget.canDrag
        ? Draggable<RoundModel>(
            dragAnchor: DragAnchor.pointer,
            data: widget.roundModel,
            feedback: DragFeedback(
              title: widget.roundModel.title,
            ),
            child: listItemContent,
          )
        : listItemContent;
  }

  _viewRoundDetails() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => RoundDetailsPage(
          roundModel: widget.roundModel,
        ),
      ),
    );
  }
}

class RoundListItemContent extends StatelessWidget {
  const RoundListItemContent({
    Key key,
    @required this.roundModel,
    @required this.viewQuestionDetails,
  }) : super(key: key);

  final RoundModel roundModel;
  final viewQuestionDetails;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        viewQuestionDetails();
      },
      child: Container(
        color: Theme.of(context).cardColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: getIt<AppSize>().rSpacingSm),
            ),
            RoundListItemDetails(
              roundModel: roundModel,
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
    );
  }
}

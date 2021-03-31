import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/pages/details/round/round_details_dialog.dart';
import 'package:qmhb/pages/details/round/round_details_page.dart';
import 'package:qmhb/pages/library/widgets/add_item_into_item_button.dart';
import 'package:qmhb/services/navigation_service.dart';
import 'package:qmhb/services/round_service.dart';
import 'package:qmhb/shared/widgets/list_item/list_item_background_image.dart';
import 'package:qmhb/shared/widgets/list_item/list_item_details.dart';
import 'package:qmhb/shared/widgets/round_list_item/round_list_item_action.dart';

class RoundListItemShell extends StatelessWidget {
  final RoundModel round;
  final Widget action;

  RoundListItemShell({
    Key key,
    @required this.round,
    this.action,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 112,
      child: Stack(
        children: [
          ItemBackgroundImage(imageUrl: round.imageUrl),
          ListItemDetails(
            title: round.title,
            description: round.description,
            info1Title: "Points: ",
            info1Value: round.totalPoints.toString(),
            info2Title: "Questions: ",
            info2Value: round.questions.length.toString(),
            info3Title: null,
            info3Value: null,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: action != null
                ? action
                : Container(
                    width: 64,
                  ),
          ),
        ],
      ),
    );
  }
}

class RoundListItemWithSelect extends StatelessWidget {
  final RoundModel round;
  final Function containsItem;
  final Function onTap;

  RoundListItemWithSelect({
    Key key,
    @required this.round,
    @required this.containsItem,
    @required this.onTap,
  }) : super(key: key);

  void _showNestedItems(context) {
    RoundService service = Provider.of<RoundService>(context, listen: false);
    String token = Provider.of<UserDataStateModel>(context, listen: false).token;
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return RoundDetailsDialog(
          round: round,
          future: service.getRound(
            id: round.id,
            token: token,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _showNestedItems(context),
      child: RoundListItemShell(
        round: round,
        action: AddItemIntoItemButton(
          contains: containsItem,
          onTap: onTap,
        ),
      ),
    );
  }
}

class RoundListItemWithAction extends StatelessWidget {
  final RoundModel round;

  RoundListItemWithAction({
    Key key,
    @required this.round,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Provider.of<NavigationService>(context, listen: false).push(
          RoundDetailsPage(
            initialValue: round,
          ),
        );
      },
      child: RoundListItemShell(
        round: round,
        action: RoundListItemAction(
          round: round,
        ),
      ),
    );
  }
}

class DraggableRoundListItemWithAction extends StatelessWidget {
  final RoundModel round;
  final Function onDragStarted;
  final Function onDragEnd;

  DraggableRoundListItemWithAction({
    Key key,
    @required this.round,
    @required this.onDragStarted,
    @required this.onDragEnd,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Draggable<RoundModel>(
      onDragStarted: onDragStarted,
      onDragEnd: onDragEnd,
      dragAnchor: DragAnchor.pointer,
      data: round,
      feedback: Material(
        child: Container(
          height: 112,
          width: 320,
          child: RoundListItemShell(
            round: round,
          ),
        ),
      ),
      child: RoundListItemWithAction(
        round: round,
      ),
    );
  }
}

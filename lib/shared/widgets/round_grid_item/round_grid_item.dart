import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/pages/details/round/round_details_dialog.dart';
import 'package:qmhb/pages/details/round/round_details_page.dart';
import 'package:qmhb/pages/library/widgets/add_item_into_item_button.dart';
import 'package:qmhb/services/navigation_service.dart';
import 'package:qmhb/services/round_service.dart';
import 'package:qmhb/shared/widgets/grid_item/grid_item.dart';
import 'package:qmhb/shared/widgets/round_list_item/round_list_item_action.dart';

class RoundGridItem extends StatelessWidget {
  final RoundModel round;
  final Widget action;

  RoundGridItem({
    Key key,
    @required this.round,
    @required this.action,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridItem(
      type: GridItemType.ROUND,
      title: round.title,
      description: round.description,
      imageUrl: round.imageUrl,
      points: round.totalPoints,
      number: round.questions.length,
      action: action,
    );
  }
}

class RoundGridItemDraggableWithAction extends StatelessWidget {
  final RoundModel round;
  final Function onDragStarted;
  final Function onDragEnd;

  RoundGridItemDraggableWithAction({
    Key key,
    @required this.round,
    @required this.onDragStarted,
    @required this.onDragEnd,
  }) : super(key: key);

  void _navigateToDetails(context) {
    Provider.of<NavigationService>(context, listen: false).push(
      RoundDetailsPage(
        initialValue: round,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _navigateToDetails(context),
      child: Draggable(
        onDragStarted: onDragStarted,
        onDragEnd: onDragEnd,
        dragAnchor: DragAnchor.pointer,
        data: round,
        feedback: Material(
          child: Container(
            height: 64,
            width: 128,
            child: Center(
              child: Text(round.title),
            ),
          ),
        ),
        child: RoundGridItem(
          round: round,
          action: RoundListItemAction(
            round: round,
          ),
        ),
      ),
    );
  }
}

class RoundGridItemWithAction extends StatelessWidget {
  final RoundModel round;

  RoundGridItemWithAction({
    Key key,
    @required this.round,
  }) : super(key: key);

  void _navigateToDetails(context) {
    Provider.of<NavigationService>(context, listen: false).push(
      RoundDetailsPage(
        initialValue: round,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _navigateToDetails(context),
      child: RoundGridItem(
        round: round,
        action: RoundListItemAction(
          round: round,
        ),
      ),
    );
  }
}

class RoundGridItemWithSelect extends StatelessWidget {
  final RoundModel round;
  final Function containsItem;
  final Function onTap;

  RoundGridItemWithSelect({
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
      child: RoundGridItem(
        round: round,
        action: AddItemIntoItemButton(
          contains: containsItem,
          onTap: onTap,
        ),
      ),
    );
  }
}

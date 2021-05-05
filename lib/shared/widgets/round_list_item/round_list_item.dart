import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/pages/details/round/round_details_dialog.dart';
import 'package:qmhb/pages/details/round/round_details_page.dart';
import 'package:qmhb/pages/library/widgets/add_item_into_item_button.dart';
import 'package:qmhb/services/navigation_service.dart';
import 'package:qmhb/services/round_service.dart';
import 'package:qmhb/shared/widgets/list_item/list_item.dart';
import 'package:qmhb/shared/widgets/round_list_item/round_list_item_action.dart';

class RoundListItem extends StatelessWidget {
  final RoundModel round;
  final Widget action;

  RoundListItem({
    Key key,
    this.round,
    this.action,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListItem(
      title: round.title,
      description: round.description,
      imageUrl: round.imageUrl,
      points: round.totalPoints,
      number: round.questions.length,
      infoTitle1: " Questions",
      infoTitle2: " Pts",
      action: action,
    );
  }
}

class RoundListItemWithAction extends StatelessWidget {
  final RoundModel round;

  RoundListItemWithAction({
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
      child: RoundListItem(
        round: round,
        action: RoundListItemAction(
          round: round,
        ),
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
      child: RoundListItem(
        round: round,
        action: AddItemIntoItemButton(
          contains: containsItem,
          onTap: onTap,
        ),
      ),
    );
  }
}

class RoundListItemWithSelectAndReorder extends StatelessWidget {
  final RoundModel round;
  final Function containsItem;
  final Function onTap;

  RoundListItemWithSelectAndReorder({
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
      child: Row(
        children: [
          Flexible(
            child: RoundListItem(
              round: round,
              action: AddItemIntoItemButton(
                contains: containsItem,
                onTap: onTap,
              ),
            ),
          ),
          Container(
            width: 32,
          )
        ],
      ),
    );
  }
}

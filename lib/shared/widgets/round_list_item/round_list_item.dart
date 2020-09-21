import 'package:flutter/material.dart';
import 'package:qmhb/get_it.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/models/state_models/app_size.dart';
import 'package:qmhb/screens/library/rounds/round_details_page.dart';
import 'package:qmhb/shared/widgets/round_list_item/round_list_item_action.dart';
import 'package:qmhb/shared/widgets/round_list_item/round_list_item_details.dart';

enum RoundOptions { save, edit, delete, details, addToQuiz, publish }

class RoundListItem extends StatefulWidget {
  final RoundModel roundModel;

  RoundListItem({
    Key key,
    @required this.roundModel,
  }) : super(key: key);

  @override
  _RoundListItemState createState() => _RoundListItemState();
}

class _RoundListItemState extends State<RoundListItem> {
  @override
  Widget build(BuildContext context) {
    return Draggable<RoundModel>(
      dragAnchor: DragAnchor.pointer,
      data: widget.roundModel,
      feedback: Material(
        child: Container(
          padding: EdgeInsets.all(16),
          height: 64,
          width: 256,
          color: Colors.grey,
          child: Center(
            child: Text(
              widget.roundModel.title,
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
        ),
      ),
      child: InkWell(
        onTap: _viewRoundDetails,
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: getIt<AppSize>().rSpacingSm),
              ),
              RoundListItemDetails(
                roundModel: widget.roundModel,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: getIt<AppSize>().lOnly16),
                child: RoundListItemAction(
                  roundModel: widget.roundModel,
                ),
              ),
            ],
          ),
        ),
      ),
    );
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

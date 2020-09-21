import 'package:flutter/material.dart';
import 'package:qmhb/shared/widgets/round_list_item/round_list_item.dart';

class RoundListItemAction extends StatelessWidget {
  const RoundListItemAction({
    Key key,
    @required this.onTap,
  }) : super(key: key);

  final onTap;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(100),
      child: Material(
        color: Colors.transparent,
        child: PopupMenuButton<RoundOptions>(
          padding: EdgeInsets.zero,
          tooltip: "Round Actions",
          onSelected: (result) {
            onTap(result);
          },
          child: Container(
            width: 64,
            height: 64,
            child: Icon(Icons.more_vert),
          ),
          itemBuilder: (BuildContext context) => <PopupMenuEntry<RoundOptions>>[
            PopupMenuItem<RoundOptions>(
              value: RoundOptions.addToQuiz,
              child: Text("Add to Quiz"),
            ),
            PopupMenuItem<RoundOptions>(
              value: RoundOptions.edit,
              child: Text("Edit"),
            ),
            PopupMenuItem<RoundOptions>(
              value: RoundOptions.delete,
              child: Text("Delete"),
            ),
            // PopupMenuItem<RoundOptions>(
            //   value: RoundOptions.save,
            //   child: Text("Save To Collection"),
            // ),
            // PopupMenuItem<RoundOptions>(
            //   value: RoundOptions.publish,
            //   child: Text("Publish"),
            // ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/screens/library/rounds/round_editor_page.dart';
import 'package:qmhb/screens/library/widgets/round_editor.dart';
import 'package:qmhb/shared/widgets/button_primary.dart';
import 'package:qmhb/shared/widgets/round_list_item/round_list_item.dart';
import 'package:responsive_grid/responsive_grid.dart';

class RoundListItemGrid extends StatelessWidget {
  RoundListItemGrid({
    Key key,
    @required this.rounds,
  }) : super(key: key);

  final List<RoundModel> rounds;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(52, 32, 0, 0),
              child: ButtonPrimary(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => RoundEditorPage(
                        type: RoundEditorType.ADD,
                      ),
                    ),
                  );
                },
                text: "Create New",
                // TODO hide when used in explore tab
              ),
            ),
          ],
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.all(32),
            child: ResponsiveGridList(
                desiredItemWidth: 400,
                minSpacing: 16,
                children: rounds.map((RoundModel roundModel) {
                  return RoundListItem(
                    roundModel: roundModel,
                  );
                }).toList()),
          ),
        ),
      ],
    );
  }
}

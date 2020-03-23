import 'package:flutter/material.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/screens/rounds/round_details_page.dart';
import 'package:qmhb/shared/widgets/highlights/summarys/summary_tile.dart';

class RoundListItem extends StatelessWidget {
  const RoundListItem({
    Key key,
    @required this.roundModel,
    @required this.isEven,
  }) : super(key: key);

  final RoundModel roundModel;
  final bool isEven;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
        height: 120,
        color: isEven ? Color(0xff3b3b3b) : Color(0xff545454),
        child: Row(
          children: [
            SummaryTile(
              line1: "",
              line2: "Questions",
              line2Value: roundModel.questionIds.length,
              line3: "Total Points",
              line3Value: roundModel.totalPoints,
              onTap: () {},
            ),
            Padding(padding: EdgeInsets.only(right: 8)),
            Expanded(
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(8),
                    width: double.infinity,
                    child: Text(
                      roundModel.title,
                      maxLines: 2,
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(8),
                    width: double.infinity,
                    child: Text(
                      roundModel.description,
                      maxLines: 2,
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

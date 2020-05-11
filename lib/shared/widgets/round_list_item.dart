import 'package:flutter/material.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/screens/library/rounds/round_details_page.dart';
import 'package:qmhb/shared/widgets/highlights/summarys/summary_tile.dart';

class RoundListItem extends StatelessWidget {
  const RoundListItem({
    Key key,
    @required this.roundModel,
  }) : super(key: key);

  final RoundModel roundModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      padding: EdgeInsets.all(16),
      child: GestureDetector(
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
          color: Colors.transparent,
          height: 120,
          child: Row(
            children: [
              IgnorePointer(
                child: SummaryTile(
                  line1: "",
                  line2: "Questions",
                  line2Value: roundModel.questionIds.length,
                  line3: "Total Points",
                  line3Value: roundModel.totalPoints,
                  onTap: () {},
                ),
              ),
              Padding(padding: EdgeInsets.only(right: 8)),
              Expanded(
                child: Container(
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:qmhb/screens/rounds/rounds_page.dart';
import 'package:qmhb/shared/widgets/summarys/summary_content.dart';
import 'package:qmhb/shared/widgets/summarys/summary_footer.dart';
import 'package:qmhb/shared/widgets/summarys/summary_header.dart';

class RoundRow extends StatelessWidget {
  const RoundRow({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SummaryRowHeader(
          title: "Rounds",
          buttonText: "See All",
          buttonFunction: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => RoundsScreen(),
              ),
            );
          },
        ),
        SummaryContentList(),
        SummaryRowFooter(),
      ],
    );
  }
}

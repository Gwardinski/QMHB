import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/screens/library/rounds/round_collection_page.dart';
import 'package:qmhb/services/round_collection_service.dart';
import 'package:qmhb/shared/widgets/highlights/highlight_row.dart';
import 'package:qmhb/shared/widgets/highlights/no_collection.dart';
import 'package:qmhb/shared/widgets/highlights/summarys/summary_footer.dart';
import 'package:qmhb/shared/widgets/highlights/summarys/summary_header.dart';

class RecentRoundsRow extends StatelessWidget {
  RecentRoundsRow({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SummaryRowHeader(
          headerTitle: 'Rounds',
          primaryHeaderButtonText: 'See All',
          primaryHeaderButtonFunction: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => RoundCollectionPage(),
              ),
            );
          },
        ),
        StreamBuilder(
            stream: Provider.of<RoundCollectionService>(context).getRecentRoundStream(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(
                  height: 128,
                  width: 128,
                  child: Text("loading"),
                );
              }
              if (snapshot.hasError) {
                return Container(
                  height: 128,
                  width: 128,
                  child: Text("err"),
                );
              }
              return (snapshot.data.length == 0)
                  ? Row(
                      children: [
                        Expanded(child: NoCollection(type: NoCollectionType.ROUND)),
                      ],
                    )
                  : HighlightRow(
                      rounds: snapshot.data,
                    );
            }),
        SummaryRowFooter(),
      ],
    );
  }
}

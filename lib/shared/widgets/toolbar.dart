import 'package:flutter/material.dart';
import 'package:qmhb/shared/widgets/app_bar_button.dart';

class Toolbar extends StatelessWidget {
  const Toolbar({
    Key key,
    @required this.onUpdateSearchString,
    @required this.onUpdateFilter,
    @required this.onUpdateSort,
    @required this.results,
    this.initialString,
    this.hintText = 'Search...',
  }) : super(key: key);

  final Function onUpdateSearchString;
  final Function onUpdateFilter;
  final Function onUpdateSort;
  final String initialString;
  final String results;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Flexible(
              child: Container(
                height: 64,
                constraints: BoxConstraints(
                  maxWidth: 600,
                ),
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: TextFormField(
                  initialValue: initialString,
                  decoration: InputDecoration(
                    icon: Icon(Icons.search),
                    hintText: hintText,
                  ),
                  onChanged: onUpdateSearchString,
                ),
              ),
            ),
            AppBarButton(
              title: "Filters",
              leftIcon: Icons.sort,
              onTap: () {},
            ),
            AppBarButton(
              title: "Sort by",
              onTap: () {},
            ),
            Container(
              height: 32,
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text("$results results"),
                ],
              ),
            )
          ],
        ),
        Row(
          children: [],
        )
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/pages/explore_page/explore_page.dart';
import 'package:qmhb/pages/library/library_page.dart';
import 'package:qmhb/services/navigation_service.dart';

class BottomMenu extends StatelessWidget {
  const BottomMenu({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final navigationService = Provider.of<NavigationService>(context);
    return Container(
      height: 60,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            width: 1.0,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                navigationService.push(LibraryPage());
              },
              child: Container(
                height: 64,
                child: Icon(Icons.home),
                // isSelected: navigationService.isCurrent(LibraryPage),
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () {
                navigationService.push(ExplorePage());
              },
              child: Container(
                height: 64,
                child: Icon(Icons.search),
                // isSelected: navigationService.isCurrent(ExplorePage),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

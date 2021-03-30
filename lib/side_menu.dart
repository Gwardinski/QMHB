import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/pages/explore_page/explore_page.dart';
import 'package:qmhb/pages/home/widgets/main_nav_button.dart';
import 'package:qmhb/pages/library/library_page.dart';
import 'package:qmhb/services/navigation_service.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final navigationService = Provider.of<NavigationService>(context);
    return Container(
      width: 200,
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(
            width: 1.0,
          ),
        ),
        color: Colors.black26,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 56,
          ),
          MainNavigationButton(
            title: "Library",
            icon: Icons.home,
            isSelected: navigationService.isCurrent(LibraryPage),
            onPressed: () {
              navigationService.push(LibraryPage());
            },
          ),
          MainNavigationButton(
            title: "Explore",
            icon: Icons.search,
            isSelected: navigationService.isCurrent(ExplorePage),
            onPressed: () {
              navigationService.push(ExplorePage());
            },
          ),
        ],
      ),
    );
  }
}

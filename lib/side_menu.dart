import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/state_models/app_size.dart';
import 'package:qmhb/pages/explore_page/explore_page.dart';
import 'package:qmhb/pages/library/library_page.dart';
import 'package:qmhb/services/navigation_service.dart';

import 'get_it.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final navigationService = Provider.of<NavigationService>(context);
    return SafeArea(
      child: Container(
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
              child: Center(
                child: Text(
                  "QuizFlow",
                  style: TextStyle(
                    fontSize: 24,
                  ),
                ),
              ),
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
            Divider(),
            SubNavigationButton(
              title: "Quizzes",
              onPressed: () {},
            ),
            SubNavigationButton(
              title: "Rounds",
              onPressed: () {},
            ),
            SubNavigationButton(
              title: "Questions",
              onPressed: () {},
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  MainNavigationButton(
                    title: "Settings",
                    icon: Icons.settings,
                    isSelected: navigationService.isCurrent(ExplorePage),
                    onPressed: () {
                      navigationService.push(ExplorePage());
                    },
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

class MainNavigationButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final Function onPressed;
  final bool isSelected;

  MainNavigationButton({
    @required this.title,
    @required this.icon,
    @required this.onPressed,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextButton(
        onPressed: () {
          onPressed();
        },
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                icon,
                size: 24,
                color:
                    isSelected ? Theme.of(context).accentColor : Theme.of(context).selectedRowColor,
              ),
              Padding(padding: EdgeInsets.all(getIt<AppSize>().spacingMd)),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  color: isSelected
                      ? Theme.of(context).accentColor
                      : Theme.of(context).selectedRowColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SubNavigationButton extends StatelessWidget {
  final String title;
  final Function onPressed;
  final bool isSelected;

  SubNavigationButton({
    @required this.title,
    @required this.onPressed,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextButton(
        onPressed: () {
          onPressed();
        },
        child: Padding(
          padding: EdgeInsets.fromLTRB(24, 8, 8, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  color: isSelected
                      ? Theme.of(context).accentColor
                      : Theme.of(context).selectedRowColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

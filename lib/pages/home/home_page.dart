import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/bottom_menu.dart';
import 'package:qmhb/models/state_models/app_size.dart';
import 'package:qmhb/pages/explore_page/explore_page.dart';
import 'package:qmhb/pages/library/library_page.dart';
import 'package:qmhb/services/navigation_service.dart';
import 'package:qmhb/side_menu.dart';

import '../../get_it.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool useLargeLayout = MediaQuery.of(context).size.width > 800.0;
    getIt<AppSize>().updateSize(useLargeLayout);
    return Scaffold(
      body: Row(
        children: [
          useLargeLayout ? SideMenu() : Container(),
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: MaterialApp(
                    debugShowCheckedModeBanner: false,
                    navigatorKey: Provider.of<NavigationService>(context).navigatorKey,
                    theme: ThemeData.dark().copyWith(
                      accentColor: Color(0xffFFA630),
                    ),
                    home: LibraryPage(),
                  ),
                ),
                useLargeLayout ? Container() : BottomMenu(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

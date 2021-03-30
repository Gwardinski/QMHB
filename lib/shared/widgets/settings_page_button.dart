import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/pages/settings/settings_page.dart';
import 'package:qmhb/services/navigation_service.dart';

class SettingsPageButton extends StatelessWidget {
  const SettingsPageButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.settings),
      onPressed: () async {
        Provider.of<NavigationService>(context, listen: false).push(
          SettingsPage(),
        );
      },
    );
  }
}

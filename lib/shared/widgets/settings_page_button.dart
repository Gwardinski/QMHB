import 'package:flutter/material.dart';
import 'package:qmhb/screens/settings/settings_page.dart';

class SettingsPageButton extends StatelessWidget {
  const SettingsPageButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.settings),
      onPressed: () async {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => SettingsPage(),
          ),
        );
      },
    );
  }
}

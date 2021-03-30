import 'package:qmhb/get_it.dart';
import 'package:flutter/material.dart';
import 'package:qmhb/models/state_models/app_size.dart';

class SummaryRowFooter extends StatelessWidget {
  const SummaryRowFooter({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: getIt<AppSize>().rSpacingSm),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey,
            width: 1.0,
          ),
        ),
      ),
    );
  }
}

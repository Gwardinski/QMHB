import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingSpinnerHourGlass extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SpinKitPouringHourglass(
        color: Theme.of(context).accentColor,
        size: 40,
      ),
      // child: CircularProgressIndicator(),
    );
  }
}

class LoadingSpinnerSmall extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SpinKitRing(
        color: Theme.of(context).accentColor,
        size: 24,
      ),
      // child: CircularProgressIndicator(),
    );
  }
}

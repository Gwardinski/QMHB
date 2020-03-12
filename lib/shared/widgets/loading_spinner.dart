import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingSpinnerHourGlass extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: SpinKitPouringHourglass(
          color: Color(0xffFFA630),
          size: 50,
        ),
      ),
    );
  }
}

class LoadingSpinnerMusic extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: SpinKitWave(
          color: Color(0xffFFA630),
          size: 40,
        ),
      ),
    );
  }
}

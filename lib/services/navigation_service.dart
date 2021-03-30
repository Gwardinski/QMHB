import 'package:flutter/material.dart';

class NavigationService {
  final navigatorKey = GlobalKey<NavigatorState>();

  bool isCurrent(page) {
    return false;
  }

  void push(page) {
    navigatorKey.currentState.push(
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => page,
      ),
    );
  }

  void pushNamed(page) {
    navigatorKey.currentState.pushNamed(page);
  }

  void pushReplace(page) {
    navigatorKey.currentState.pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => page,
      ),
    );
  }

  void pop() {
    navigatorKey.currentState.pop();
  }
}

import 'package:flutter/material.dart';

class NavigationService {
  final navigatorKey = GlobalKey<NavigatorState>();

  // TODO - finish this
  List<Key> pageHistory = [];

  bool isCurrent(Type page) {
    return false;
  }

  bool isRoot() {
    return pageHistory.length == 0;
  }

  void push(Widget page) {
    pageHistory.add(page.key);
    navigatorKey.currentState.push(
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => page,
      ),
    );
  }

  void pushNamed(page) {
    pageHistory.add(page.key);
    navigatorKey.currentState.pushNamed(page);
  }

  void pushReplace(page) {
    pageHistory.remove(pageHistory[pageHistory.length - 1]);
    pageHistory.add(page.key);
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

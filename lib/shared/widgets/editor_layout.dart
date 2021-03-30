import 'package:flutter/material.dart';
import 'package:qmhb/shared/widgets/loading_spinner.dart';

class EditorLayout extends StatelessWidget {
  EditorLayout({
    @required this.topMenu,
    @required this.pageView,
    @required this.isLoading,
    this.sidemenu,
  });

  final Widget topMenu;
  final Widget pageView;
  final bool isLoading;
  final Widget sidemenu;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        sidemenu != null ? sidemenu : Container(),
        Expanded(
          child: Column(
            children: [
              topMenu,
              Expanded(
                child: Stack(
                  children: [
                    pageView,
                    isLoading
                        ? Container(
                            width: double.infinity,
                            color: Colors.black.withOpacity(0.5),
                            child: Center(
                              child: LoadingSpinnerHourGlass(),
                            ),
                          )
                        : Container(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

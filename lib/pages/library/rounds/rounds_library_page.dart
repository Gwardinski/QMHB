import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/models/state_models/app_size.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/pages/library/quizzes/quizzes_library_sidebar.dart';
import 'package:qmhb/pages/library/rounds/editor/round_editor_page.dart';
import 'package:qmhb/services/navigation_service.dart';
import 'package:qmhb/services/refresh_service.dart';
import 'package:qmhb/services/round_service.dart';
import 'package:qmhb/shared/widgets/app_bar_button.dart';
import 'package:qmhb/shared/widgets/round_list_item/round_list_item.dart';
import 'package:qmhb/shared/widgets/toolbar.dart';

import '../../../get_it.dart';

class RoundsLibraryPage extends StatefulWidget {
  @override
  _RoundsLibraryPageState createState() => _RoundsLibraryPageState();
}

class _RoundsLibraryPageState extends State<RoundsLibraryPage> {
  final canDrag = getIt<AppSize>().isLarge;
  RoundService _roundService;
  RefreshService _refreshService;
  RoundModel _selectedRound;
  List<RoundModel> _rounds = [];
  StreamSubscription _subscription;

  void _setSelectedRound(RoundModel round) => setState(() => _selectedRound = round);

  @override
  void initState() {
    super.initState();
    _roundService = Provider.of<RoundService>(context, listen: false);
    _refreshService = Provider.of<RefreshService>(context, listen: false);
    _subscription?.cancel();
    _subscription = _refreshService.roundListener.listen((event) {
      _getRounds();
    });
    _refreshService.roundRefresh();
  }

  @override
  void dispose() {
    super.dispose();
    _subscription?.cancel();
  }

  _getRounds() async {
    final token = Provider.of<UserDataStateModel>(context, listen: false).token;
    final rounds = await _roundService.getUserRounds(token: token);
    setState(() {
      _rounds = [];
      _rounds = rounds;
    });
  }

  void _createRound() async {
    Provider.of<NavigationService>(context, listen: false).push(
      RoundEditorPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool useLandscape = MediaQuery.of(context).size.width > 800.0;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("Your Rounds"),
        actions: [
          AppBarButton(
            title: "New",
            leftIcon: Icons.add,
            onTap: _createRound,
          ),
        ],
      ),
      body: Row(
        children: [
          canDrag ? QuizzesLibrarySidebar(selectedRound: _selectedRound) : Container(),
          Expanded(
            child: Column(
              children: [
                Toolbar(
                  onUpdateSearchString: (s) => print(s),
                  noOfResults: _rounds.length,
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _rounds.length ?? 0,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (BuildContext context, int index) {
                      return useLandscape
                          ? DraggableRoundListItemWithAction(
                              round: _rounds[index],
                              onDragStarted: () => _setSelectedRound(_rounds[index]),
                              onDragEnd: (val) => _setSelectedRound(null),
                            )
                          : RoundListItemWithAction(
                              round: _rounds[index],
                            );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

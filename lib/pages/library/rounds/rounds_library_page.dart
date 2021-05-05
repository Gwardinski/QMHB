import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/models/state_models/app_size.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/pages/library/quizzes/quizzes_library_sidebar.dart';
import 'package:qmhb/pages/library/rounds/editor/round_editor_page.dart';
import 'package:qmhb/services/navigation_service.dart';
import 'package:qmhb/services/round_service.dart';
import 'package:qmhb/services/refresh_service.dart';
import 'package:qmhb/shared/widgets/app_bar_button.dart';
import 'package:qmhb/shared/widgets/error_message.dart';
import 'package:qmhb/shared/widgets/grid_item/grid_item.dart';
import 'package:qmhb/shared/widgets/page_wrapper.dart';
import 'package:qmhb/shared/widgets/round_grid_item/round_grid_item.dart';
import 'package:qmhb/shared/widgets/round_list_item/round_list_item.dart';
import 'package:qmhb/shared/widgets/toolbar.dart';

import '../../../get_it.dart';

class RoundsLibraryPage extends StatefulWidget {
  @override
  _RoundsLibraryPageState createState() => _RoundsLibraryPageState();
}

class _RoundsLibraryPageState extends State<RoundsLibraryPage> {
  RoundModel _selectedRound;

  void _setSelectedRound(RoundModel round) => setState(() => _selectedRound = round);

  void _createRound() async {
    Provider.of<NavigationService>(context, listen: false).push(
      RoundEditorPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isLandscape = getIt<AppSize>().isLarge ?? false;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        backgroundColor: Colors.transparent,
        title: Text("Your Rounds"),
        actions: [
          isLandscape
              ? Container()
              : AppBarButton(
                  title: "New",
                  leftIcon: Icons.add,
                  onTap: _createRound,
                ),
        ],
      ),
      body: Row(
        children: [
          isLandscape ? QuizzesLibrarySidebar(selectedRound: _selectedRound) : Container(),
          Expanded(
            child: StreamBuilder<bool>(
              stream: Provider.of<RefreshService>(context, listen: false).roundListener,
              builder: (context, streamSnapshot) {
                return FutureBuilder<List<RoundModel>>(
                  future: Provider.of<RoundService>(context).getUserRounds(
                    limit: 8,
                    sortBy: 'lastUpdated',
                    token: Provider.of<UserDataStateModel>(context).token,
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return ErrorMessage(
                        message: "An error occured loading your Rounds",
                      );
                    }
                    return Column(
                      children: [
                        Toolbar(
                          onUpdateSearchString: (s) => print(s),
                          onUpdateFilter: () {},
                          onUpdateSort: () {},
                          results: snapshot.data?.length?.toString() ?? 'loading',
                        ),
                        Expanded(
                          child: isLandscape
                              ? GridView.builder(
                                  itemCount: (snapshot.data?.length ?? 0) + 1,
                                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: 160,
                                    childAspectRatio: 1,
                                    crossAxisSpacing: 16,
                                    mainAxisSpacing: 16,
                                  ),
                                  padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
                                  itemBuilder: (BuildContext context, int index) {
                                    if (index == 0) {
                                      return GridItemNew(
                                        title: "New Round",
                                        description: "",
                                        onTap: _createRound,
                                      );
                                    }
                                    return RoundGridItemDraggableWithAction(
                                      round: snapshot.data[index - 1],
                                      onDragStarted: () => _setSelectedRound(
                                        snapshot.data[index - 1],
                                      ),
                                      onDragEnd: (val) => _setSelectedRound(null),
                                    );
                                  },
                                )
                              : ListView.builder(
                                  itemCount: snapshot.data.length ?? 0,
                                  scrollDirection: Axis.vertical,
                                  itemBuilder: (BuildContext context, int index) {
                                    return RoundListItemWithAction(
                                      round: snapshot.data[index],
                                    );
                                  },
                                ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

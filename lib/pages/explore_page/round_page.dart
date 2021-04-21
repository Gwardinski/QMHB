import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/models/state_models/app_size.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/pages/library/quizzes/quizzes_library_sidebar.dart';
import 'package:qmhb/services/round_service.dart';
import 'package:qmhb/services/refresh_service.dart';
import 'package:qmhb/shared/widgets/error_message.dart';
import 'package:qmhb/shared/widgets/round_grid_item/round_grid_item.dart';
import 'package:qmhb/shared/widgets/round_list_item/round_list_item.dart';
import 'package:qmhb/shared/widgets/toolbar.dart';

import '../../get_it.dart';

class RoundPage extends StatefulWidget {
  final List<RoundModel> initialData;
  final String searchString;
  final String selectedCategory;
  final String sortBy;

  RoundPage({
    @required this.initialData,
    @required this.searchString,
    @required this.selectedCategory,
    @required this.sortBy,
  });

  @override
  _RoundPageState createState() => _RoundPageState();
}

class _RoundPageState extends State<RoundPage> {
  RoundModel _selectedRound;
  void _setSelectedRound(RoundModel round) => setState(() => _selectedRound = round);

  @override
  Widget build(BuildContext context) {
    bool isLandscape = getIt<AppSize>().isLarge ?? false;
    return Row(
      children: [
        isLandscape ? QuizzesLibrarySidebar(selectedRound: _selectedRound) : Container(),
        Expanded(
          child: Column(
            children: [
              Toolbar(
                onUpdateSearchString: (s) => print(s),
                initialValue: widget.searchString,
              ),
              Expanded(
                child: StreamBuilder<bool>(
                  stream: Provider.of<RefreshService>(context, listen: false).roundListener,
                  builder: (context, streamSnapshot) {
                    return FutureBuilder<List<RoundModel>>(
                      initialData: widget.initialData,
                      future: Provider.of<RoundService>(context).getAllRounds(
                        limit: 30,
                        selectedCategory: widget.selectedCategory,
                        searchString: widget.searchString,
                        sortBy: widget.sortBy,
                        token: Provider.of<UserDataStateModel>(context).token,
                      ),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return ErrorMessage(
                            message: "An error occured loading Rounds",
                          );
                        }
                        return Column(
                          children: [
                            SearchDetails(number: snapshot.data?.length ?? 0),
                            Expanded(
                              child: isLandscape
                                  ? GridView.builder(
                                      itemCount: snapshot.data?.length ?? 0,
                                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                                        maxCrossAxisExtent: 160,
                                        childAspectRatio: 1,
                                        crossAxisSpacing: 16,
                                        mainAxisSpacing: 16,
                                      ),
                                      padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
                                      itemBuilder: (BuildContext context, int index) {
                                        return RoundGridItemDraggableWithAction(
                                          round: snapshot.data[index],
                                          onDragStarted: () =>
                                              _setSelectedRound(snapshot.data[index]),
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
        ),
      ],
    );
  }
}

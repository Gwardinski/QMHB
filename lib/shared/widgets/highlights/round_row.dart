import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/models/state_models/app_size.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/pages/library/rounds/rounds_library_page.dart';
import 'package:qmhb/services/navigation_service.dart';
import 'package:qmhb/services/round_service.dart';
import 'package:qmhb/shared/widgets/error_message.dart';
import 'package:qmhb/shared/widgets/highlights/summarys/summary_footer.dart';
import 'package:qmhb/shared/widgets/highlights/summarys/summary_header.dart';
import 'package:qmhb/shared/widgets/loading_spinner.dart';
import 'package:qmhb/shared/widgets/round_grid_item/round_grid_item.dart';
import 'package:qmhb/shared/widgets/round_list_item/round_list_item_action.dart';

import '../../../get_it.dart';

class RoundRow extends StatelessWidget {
  final Future future;

  RoundRow({
    Key key,
    @required this.future,
  }) : super(key: key);

  _navigate(context) {
    Provider.of<NavigationService>(context, listen: false).push(
      RoundsLibraryPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 240,
      child: FutureBuilder<Object>(
        future: future,
        builder: (context, snapshot) {
          return Column(
            children: [
              SummaryRowHeader(
                headerTitle: 'Rounds',
                headerTitleButtonFunction: () {
                  _navigate(context);
                },
                primaryHeaderButtonText: 'See All',
                primaryHeaderButtonFunction: () {
                  _navigate(context);
                },
              ),
              Container(
                height: 140,
                child: FutureBuilder(
                  future: Provider.of<RoundService>(context).getUserRounds(
                    limit: 8,
                    orderBy: 'lastUpdated',
                    token: Provider.of<UserDataStateModel>(context).token,
                  ),
                  builder: (BuildContext context, AsyncSnapshot<List<RoundModel>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return LoadingSpinnerHourGlass();
                    }
                    if (snapshot.hasError) {
                      return ErrorMessage(message: "Could not load Rounds. Please refresh.");
                    }
                    return ListView.separated(
                      itemCount: snapshot.data?.length ?? 0,
                      scrollDirection: Axis.horizontal,
                      separatorBuilder: (BuildContext context, int index) => Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        final paddingSize = getIt<AppSize>().rSpacingMd;
                        EdgeInsets padding = index == 0
                            ? EdgeInsets.only(left: paddingSize)
                            : index == (snapshot.data.length - 1)
                                ? EdgeInsets.only(right: paddingSize)
                                : EdgeInsets.all(0);
                        RoundModel round = snapshot.data[index];
                        return Container(
                          padding: padding,
                          child: RoundGridItem(
                            round: round,
                            action: RoundListItemAction(round: round),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              SummaryRowFooter(),
            ],
          );
        },
      ),
    );
  }
}

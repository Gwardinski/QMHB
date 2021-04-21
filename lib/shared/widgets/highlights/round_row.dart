import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/featured_rounds_model.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/models/state_models/app_size.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/pages/library/rounds/rounds_library_page.dart';
import 'package:qmhb/services/explore_service.dart';
import 'package:qmhb/services/navigation_service.dart';
import 'package:qmhb/services/round_service.dart';
import 'package:qmhb/shared/widgets/error_message.dart';
import 'package:qmhb/shared/widgets/highlights/summarys/summary_footer.dart';
import 'package:qmhb/shared/widgets/highlights/summarys/summary_header.dart';
import 'package:qmhb/shared/widgets/loading_spinner.dart';
import 'package:qmhb/shared/widgets/round_grid_item/round_grid_item.dart';
import 'package:qmhb/shared/widgets/round_list_item/round_list_item_action.dart';

import '../../../get_it.dart';

class LibraryRoundRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<RoundModel>>(
      future: Provider.of<RoundService>(context).getUserRounds(
        limit: 8,
        sortBy: 'lastUpdated',
        token: Provider.of<UserDataStateModel>(context).token,
      ),
      builder: (context, snapshot) {
        return RoundRow(
          title: 'Your Rounds',
          onNavigate: () => Provider.of<NavigationService>(context, listen: false).push(
            RoundsLibraryPage(),
          ),
          isLoading: snapshot.connectionState == ConnectionState.waiting,
          hasError: snapshot.hasError,
          errorMessage: "Could not load your Rounds. Please refresh.",
          roundModels: snapshot.data,
        );
      },
    );
  }
}

class FeaturedRoundRow extends StatelessWidget {
  final String featNo;
  final Function onNavigate;

  FeaturedRoundRow({
    Key key,
    @required this.featNo,
    @required this.onNavigate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FeaturedRounds>(
      future: Provider.of<ExploreService>(context).getFeaturedRounds(
        token: Provider.of<UserDataStateModel>(context).token,
        featNo: featNo,
      ),
      builder: (context, snapshot) {
        return RoundRow(
          title: snapshot.data?.title ?? 'Featured Rounds',
          description: snapshot.data?.description ?? 'Featured Rounds',
          onNavigate: () => onNavigate(data: snapshot.data),
          isLoading: snapshot.connectionState == ConnectionState.waiting,
          hasError: snapshot.hasError,
          errorMessage: "Could not load featured Rounds. Please refresh.",
          roundModels: snapshot.data?.roundModels,
        );
      },
    );
  }
}

class RoundRow extends StatelessWidget {
  final String title;
  final String description;
  final Function onNavigate;
  final bool isLoading;
  final bool hasError;
  final String errorMessage;
  final List<RoundModel> roundModels;

  const RoundRow({
    Key key,
    @required this.title,
    this.description,
    @required this.onNavigate,
    @required this.isLoading,
    @required this.hasError,
    @required this.errorMessage,
    @required this.roundModels,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 240,
      child: Column(
        children: [
          SummaryRowHeader(
            headerTitle: title,
            headerDescription: description,
            headerTitleButtonFunction: onNavigate,
            primaryHeaderButtonText: 'View All',
            primaryHeaderButtonFunction: onNavigate,
          ),
          Container(
            height: 140,
            child: isLoading
                ? LoadingSpinnerHourGlass()
                : hasError
                    ? ErrorMessage(message: errorMessage)
                    : ListView.separated(
                        itemCount: roundModels.length ?? 0,
                        scrollDirection: Axis.horizontal,
                        separatorBuilder: (BuildContext context, int index) => Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          final paddingSize = getIt<AppSize>().rSpacingMd;
                          EdgeInsets padding = index == 0
                              ? EdgeInsets.only(left: paddingSize)
                              : index == (roundModels.length - 1)
                                  ? EdgeInsets.only(right: paddingSize)
                                  : EdgeInsets.all(0);
                          RoundModel round = roundModels[index];
                          return Container(
                            padding: padding,
                            child: RoundGridItem(
                              round: round,
                              action: RoundListItemAction(round: round),
                            ),
                          );
                        },
                      ),
          ),
          SummaryRowFooter(),
        ],
      ),
    );
  }
}

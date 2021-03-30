import 'package:flutter/material.dart';
import 'package:qmhb/models/state_models/app_size.dart';
import 'package:qmhb/pages/details/widgets/details_header_banner_image.dart';
import 'package:qmhb/pages/details/widgets/details_header_image_and_title.dart';
import 'package:qmhb/shared/widgets/details/info_column.dart';

import '../../../get_it.dart';

class DetailsHeader extends StatelessWidget {
  final String type;
  final String title;
  final String description;
  final String imageUrl;
  final String info1Title;
  final String info2Title;
  final String info3Title;
  final String info1Value;
  final String info2Value;
  final String info3Value;

  DetailsHeader({
    this.type,
    this.title,
    this.description,
    this.imageUrl,
    this.info1Title,
    this.info2Title,
    this.info3Title,
    this.info1Value,
    this.info2Value,
    this.info3Value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Stack(
          children: [
            DetailsHeaderBannerImage(imageUrl: imageUrl),
            DetailsHeaderImageAndTitle(
              type: type,
              title: title,
              imageUrl: imageUrl,
            ),
            Column(
              children: [
                Padding(padding: EdgeInsets.only(top: 240)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Flexible(
                      fit: FlexFit.tight,
                      child: InfoColumn(
                        title: info1Title,
                        value: info1Value,
                      ),
                    ),
                    Flexible(
                      fit: FlexFit.loose,
                      child: InfoColumn(
                        title: info2Title,
                        value: info2Value,
                      ),
                    ),
                    Flexible(
                      fit: FlexFit.tight,
                      child: InfoColumn(
                        title: info3Title,
                        value: info3Value,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    32,
                    description != null ? getIt<AppSize>().spacingLg : getIt<AppSize>().spacingSm,
                    32,
                    description != null ? 24 : 0,
                  ),
                  child: Text(
                    description ?? '',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ],
    );
  }
}

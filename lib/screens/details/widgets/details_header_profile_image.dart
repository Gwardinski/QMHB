import 'package:flutter/material.dart';
import 'package:qmhb/models/state_models/app_size.dart';

import '../../../get_it.dart';

class DetailsHeaderProfileImage extends StatelessWidget {
  const DetailsHeaderProfileImage({
    @required this.imageURL,
  });

  final String imageURL;

  @override
  Widget build(BuildContext context) {
    return imageURL != null
        ? Container(
            height: 200,
            margin: EdgeInsets.only(right: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 128,
                  width: 128,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(getIt<AppSize>().borderRadius),
                    ),
                    border: Border.all(color: Theme.of(context).accentColor),
                    image: imageURL != null
                        ? DecorationImage(
                            fit: BoxFit.cover,
                            alignment: Alignment.center,
                            matchTextDirection: true,
                            repeat: ImageRepeat.noRepeat,
                            image: NetworkImage(imageURL),
                          )
                        : null,
                  ),
                ),
              ],
            ),
          )
        : Container();
  }
}

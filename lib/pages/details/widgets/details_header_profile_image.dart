import 'package:flutter/material.dart';
import 'package:qmhb/models/state_models/app_size.dart';

import '../../../get_it.dart';

class DetailsHeaderProfileImage extends StatelessWidget {
  const DetailsHeaderProfileImage({
    @required this.imageUrl,
  });

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return imageUrl != null
        ? Container(
            height: 200,
            margin: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 140,
                  width: 140,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(getIt<AppSize>().borderRadius),
                    ),
                    border: Border.all(color: Theme.of(context).accentColor),
                    image: imageUrl != null
                        ? DecorationImage(
                            fit: BoxFit.cover,
                            alignment: Alignment.center,
                            matchTextDirection: true,
                            repeat: ImageRepeat.noRepeat,
                            image: NetworkImage(imageUrl),
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

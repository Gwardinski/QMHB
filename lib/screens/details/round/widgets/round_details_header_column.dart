import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/models/state_models/app_size.dart';
import 'package:qmhb/screens/library/rounds/round_editor_page.dart';
import 'package:qmhb/shared/widgets/button_text.dart';
import 'package:qmhb/shared/widgets/details/info_column.dart';
import 'package:qmhb/shared/widgets/image_switcher.dart';

import '../../../../get_it.dart';

class RoundDetailsHeaderColumn extends StatefulWidget {
  const RoundDetailsHeaderColumn({
    Key key,
    this.roundModel,
  }) : super(key: key);

  final RoundModel roundModel;

  @override
  _RoundDetailsHeaderColumnState createState() => _RoundDetailsHeaderColumnState();
}

class _RoundDetailsHeaderColumnState extends State<RoundDetailsHeaderColumn> {
  bool isExpanded = false;

  expandImage(bool expand) {
    setState(() {
      isExpanded = expand;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        (widget.roundModel.imageURL != null)
            ? GestureDetector(
                onVerticalDragUpdate: (details) {
                  if (details.delta.dy > 0)
                    expandImage(true);
                  else
                    expandImage(false);
                },
                onTap: () {
                  expandImage(true);
                },
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 250),
                  width: double.infinity,
                  height: isExpanded ? 300 : 120,
                  margin: EdgeInsets.only(bottom: 32),
                  child: ImageSwitcher(
                    fileImage: null,
                    networkImage: widget.roundModel.imageURL,
                  ),
                ),
              )
            : Container(height: 32),
        Text(
          "Round",
          style: TextStyle(
            fontSize: 12,
          ),
        ),
        Text(
          widget.roundModel.title,
          style: TextStyle(
            fontSize: 32,
          ),
        ),
        Padding(padding: EdgeInsets.only(bottom: getIt<AppSize>().spacingLg)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InfoColumn(title: "Questions", value: widget.roundModel.questionIds.length.toString()),
            InfoColumn(title: "Points", value: widget.roundModel.totalPoints.toString()),
            InfoColumn(
              title: "Created",
              value: DateFormat('d-MM-y').format(widget.roundModel.createdAt),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(
            16,
            widget.roundModel.description != null
                ? getIt<AppSize>().spacingLg
                : getIt<AppSize>().spacingSm,
            16,
            widget.roundModel.description != null ? 24 : 0,
          ),
          child: widget.roundModel.description != null
              ? Text(
                  widget.roundModel.description,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                )
              : ButtonText(
                  text: "Edit Round Details",
                  type: ButtonTextType.SECONDARY,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => RoundEditorPage(
                          type: RoundEditorType.EDIT,
                          roundModel: widget.roundModel,
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

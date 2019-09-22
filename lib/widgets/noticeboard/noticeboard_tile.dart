import 'package:discover_deep_cove/util/date_util.dart';
import 'package:discover_deep_cove/util/hex_color.dart';
import 'package:discover_deep_cove/util/screen.dart';
import 'package:discover_deep_cove/widgets/misc/text/body_text.dart';
import 'package:discover_deep_cove/widgets/misc/text/sub_heading.dart';
import 'package:flutter/material.dart';

class NoticeTile extends StatelessWidget {
  final String title;
  final DateTime date;
  final String desc;
  final bool isUrgent;
  final bool hasMore;
  final bool hasDivider;
  final VoidCallback onTap;

  NoticeTile({
    this.title,
    this.date,
    this.desc,
    this.isUrgent,
    this.hasMore,
    this.hasDivider,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: isUrgent
          ? BoxDecoration(
              border: Border(left: BorderSide(color: Colors.red, width: 5)),
            )
          : null,
      child: GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            child: Column(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Divider(color: Colors.transparent, height: 1),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width: Screen.width(context, percentage: 80),
                              child: SubHeading(
                                title,
                                size: Screen.isTablet(context)
                                    ? 30
                                    : Screen.isSmall(context) ? 16 : 18,
                                align: TextAlign.left,
                              ),
                            ),
                            Text(
                              DateUtil.formatDate(date),
                              style: TextStyle(
                                color: HexColor("FF999999"),
                                fontSize: Screen.isTablet(context)
                                    ? 30
                                    : Screen.isSmall(context) ? 12 : 14,
                              ),
                            ),
                          ],
                        ),
                        hasMore
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: BodyText(
                                  "MORE",
                                  size: Screen.isTablet(context)
                                      ? 30
                                      : Screen.isSmall(context) ? 12 : 14,
                                ),
                              )
                            : Container(),
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  desc,
                  style: TextStyle(
                    color: HexColor("FF999999"),
                    fontSize: Screen.isTablet(context)
                        ? 30
                        : Screen.isSmall(context) ? 14 : 16,
                  ),
                  textAlign: TextAlign.left,
                ),
                SizedBox(
                  height: 20,
                ),
                hasDivider
                    ? Divider(color: HexColor("FF777777"), height: 1)
                    : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

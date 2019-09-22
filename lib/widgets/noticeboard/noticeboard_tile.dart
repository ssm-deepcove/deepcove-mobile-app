import 'package:discover_deep_cove/util/hex_color.dart';
import 'package:discover_deep_cove/util/screen.dart';
import 'package:discover_deep_cove/util/date_util.dart';
import 'package:discover_deep_cove/widgets/misc/text/body_text.dart';
import 'package:discover_deep_cove/widgets/misc/text/sub_heading.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NoticeTile extends StatelessWidget {
  final String title;
  final DateTime date;
  final String desc;
  final bool isUrgent;
  final bool hasMore;
  final VoidCallback onTap;

  static const String TH = "\u1d57\u02b0";
  static const String ND = "\u207f\u1d48";
  static const String RD = "\u02b3\u1d48";
  static const String ST = "\u02e2\u1d57";

  NoticeTile(
      {this.title,
      this.date,
      this.desc,
      this.isUrgent,
      this.hasMore,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: Column(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SubHeading(
                            title,
                          ),
                          Text(
                            DateUtil.formatDate(date),
                            style: TextStyle(
                              color: HexColor("FF777777"),
                              fontSize: Screen.isTablet(context)
                                  ? 30
                                  : Screen.isSmall(context) ? 12 : 14,
                            ),
                          ),
                        ],
                      ),
                      isUrgent
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                FontAwesomeIcons.exclamationTriangle,
                                color: Colors.red,
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
              BodyText(
                desc,
                align: TextAlign.left,
              ),
              SizedBox(
                height: 15,
              ),
              hasMore
                  ? BodyText(
                      'Tap for more info',
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}

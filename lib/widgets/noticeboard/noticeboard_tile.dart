import 'package:discover_deep_cove/util/hex_color.dart';
import 'package:discover_deep_cove/util/screen.dart';
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

  static const String TH = "\u1d57\u02b0";
  static const String ND = "\u207f\u1d48";
  static const String RD = "\u02b3\u1d48";
  static const String ST = "\u02e2\u1d57";

  NoticeTile({this.title, this.date, this.desc, this.isUrgent, this.hasMore});

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                          '${date.day}$getOrdinalIndicator ${date.month} ${date.year}',
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
    );
  }

  String getOrdinalIndicator() {
    if (date.day >= 11 && date.day <= 13) {
      return TH;
    }
    switch (date.day % 10) {
      case 1:
        return ST;
      case 2:
        return ND;
      case 3:
        return RD;
      default:
        return TH;
    }
  }
}

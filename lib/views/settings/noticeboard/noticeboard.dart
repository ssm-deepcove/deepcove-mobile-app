import 'package:discover_deep_cove/data/models/notice.dart';
import 'package:discover_deep_cove/data/sample_notices.dart';
import 'package:discover_deep_cove/util/screen.dart';
import 'package:discover_deep_cove/widgets/misc/bottom_back_button.dart';
import 'package:discover_deep_cove/widgets/misc/text/sub_heading.dart';
import 'package:discover_deep_cove/widgets/noticeboard/noticeboard_seperator.dart';
import 'package:discover_deep_cove/widgets/noticeboard/noticeboard_tile.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Noticeboard extends StatefulWidget {
  @override
  _NoticeboardState createState() => _NoticeboardState();
}

class _NoticeboardState extends State<Noticeboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        title: SubHeading(
          'Deep Cove Noticeboard',
          size:
              Screen.isTablet(context) ? 30 : Screen.isSmall(context) ? 16 : 23,
        ),
        centerTitle: true,
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(
              right: Screen.width(context, percentage: 1.25),
            ),
      child: IconButton(
        icon: Icon(
          FontAwesomeIcons.sync,
          color: Colors.white,
        ),
        onPressed: () {
          //TODO: refresh the list of notices send to refesh indicator method?
        },
      ),
          ),
        ],
        backgroundColor: Theme.of(context).backgroundColor,
        brightness: Brightness.dark,
      ),
      body: RefreshIndicator(
        onRefresh: refreshNotices,
        child: ListView(
          children: <Widget>[
            Seperator("Important Notices"),
            ...getUrgent(),
            Seperator("Other Notices"),
            ...getOther(),
          ],
        ),
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      bottomNavigationBar: BottomBackButton(),
    );
  }

  Future<Null> refreshNotices() async {
    return null;
  }

  List<Widget> getUrgent() {
    List<Widget> urgent = urgentNotices
        .map(
          (data) => NoticeTile(
            title: data.title,
            date: data.activatedAt,
            desc: data.shortDesc,
            isUrgent: true,
            hasMore: data.longDesc != null ? true : false,
            hasDivider: hasDivider(data, urgentNotices),
            onTap: data.longDesc != null
                ? () => Navigator.pushNamed(
                      context,
                      '/noticeView',
                      arguments: data.id,
                    )
                : null,
          ),
        )
        .toList();

    return urgent;
  }

  bool hasDivider(Notice notice, List<Notice> notices) {
    return notice == notices.last || notices.length == 1 ? false : true;
  }

  List<Widget> getOther() {
    List<Widget> other = otherNotices
        .map(
          (data) => NoticeTile(
            title: data.title,
            date: data.activatedAt,
            desc: data.shortDesc,
            isUrgent: false,
            hasMore: data.longDesc != null ? true : false,
            hasDivider: hasDivider(data, otherNotices),
            onTap: data.longDesc != null
                ? () => Navigator.pushNamed(
                      context,
                      '/noticeView',
                      arguments: data.id,
                    )
                : null,
          ),
        )
        .toList();

    return other;
  }
}

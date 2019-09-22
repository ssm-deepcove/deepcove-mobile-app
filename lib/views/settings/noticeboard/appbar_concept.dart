//See issue #76

// appBar: 
      // PreferredSize(
      //   preferredSize: Size.fromHeight(70.0),
      //   child: Container(
      //     color: Theme.of(context).backgroundColor,
      //     child: SafeArea(
      //       child: Column(
      //         mainAxisAlignment: MainAxisAlignment.center,
      //         children: <Widget>[
      //           Row(
      //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //             children: <Widget>[
      //               Padding(
      //                 padding: EdgeInsets.only(left: 20.0),
      //                 child: Container(
      //                   width: Screen.width(context, percentage: 75),
      //                   child: SubHeading(
      //                     'Deep Cove Noticeboard',
      //                     size: Screen.isTablet(context)
      //                         ? 30
      //                         : Screen.isSmall(context) ? 16 : 23,
      //                         align: TextAlign.left,
      //                   ),
      //                 ),
      //               ),
      //               Padding(
      //                 padding: EdgeInsets.only(right: 20.0),
      //                 child: IconButton(
      //                   icon: Icon(
      //                     FontAwesomeIcons.sync,
      //                     color: Colors.white,
      //                   ),
      //                   onPressed: () {
      //                     //TODO: refresh the list of notices send to refesh indicator method?
      //                   },
      //                 ),
      //               ),
      //             ],
      //           ),
      //         ],
      //       ),
      //     ),
      //   ),
      // ),
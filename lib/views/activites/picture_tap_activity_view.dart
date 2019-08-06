import 'dart:io';

import 'package:discover_deep_cove/data/models/activity/activity.dart';
import 'package:discover_deep_cove/env.dart';
import 'package:discover_deep_cove/util/hex_color.dart';
import 'package:discover_deep_cove/util/screen.dart';
import 'package:discover_deep_cove/util/util.dart';
import 'package:discover_deep_cove/widgets/activities/activityAppBar.dart';
import 'package:discover_deep_cove/widgets/fact_file/editAnswer.dart';
import 'package:discover_deep_cove/widgets/misc/text/body.dart';
import 'package:discover_deep_cove/widgets/misc/bottom_back_button.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class PictureTapActivityView extends StatefulWidget {
  final Activity activity;
  final bool isReview;

  ///Takes in a [PictureTapActivity] and a [bool] and displays the view based
  ///on the value of the [bool], you can complete the activity if the [bool] is false
  ///and review it if the [bool] is true.
  PictureTapActivityView({this.activity, this.isReview});

  @override
  _PictureTapActivityViewState createState() => _PictureTapActivityViewState();
}

class _PictureTapActivityViewState extends State<PictureTapActivityView> {
  Offset tapPos;
  Color transparentAccent;
  bool isTapped = false;
  double posY = 0;
  double posX = 0;

  GlobalKey _keyImage = GlobalKey();

  _afterLayout(_) {
    _getPositions();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ActivityAppBar(widget.activity.title),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(40, 20, 40, 20),
            child: Text(widget.activity.description),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
            child: Text(widget.activity.task),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
            child: widget.isReview
                ? Body(
                    "Your Answer:",
                  )
                : null,
          ),
          widget.isReview
              ? Stack(
                  fit: StackFit.loose,
                  children: <Widget>[
                    Container(
                      height: Screen.height(context, percentage: 51.58),
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: FileImage(File(Env.getResourcePath(
                                widget.activity.image.path))),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          color: Color.fromARGB(190, 0, 0, 0),
                          height: Screen.height(context, percentage: 5.0),
                          width: Screen.width(context),
                          child: Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: EditAnswer(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      top: widget.activity.userYCoord,
                      left: widget.activity.userXCoord,
                      child: Center(
                        child: Container(
                          width: 100.0,
                          height: 100.0,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(0x80FF5026),
                              border: Border.all(
                                color: setTransparentColor(),
                                width: 3.0,
                                style: BorderStyle.solid,
                              ),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : Stack(
                  fit: StackFit.loose,
                  children: <Widget>[
                    GestureDetector(
                      onTapDown: _handleTap,
                      child: Container(
                        key: _keyImage,
                        height: Screen.height(context, percentage: 51.58),
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: FileImage(File(Env.getResourcePath(
                                  widget.activity.image.path))),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                    isTapped
                        ? Positioned(
                            top: posY,
                            left: posX,
                            child: Center(
                              child: Container(
                                width: 100.0,
                                height: 100.0,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Color(0x80FF5026),
                                    border: Border.all(
                                      color: setTransparentColor(),
                                      width: 3.0,
                                      style: BorderStyle.solid,
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Container(),
                  ],
                ),
          Expanded(child: Container()),
          widget.isReview
              ? Container()
              : Container(
                  width: Screen.width(context),
                  color: Theme.of(context).primaryColorDark,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: OutlineButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          borderSide: BorderSide(color: Color(0xFF777777)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Body(
                            "Pass",
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: OutlineButton(
                          onPressed: () {
                            if (isTapped) {
                              saveAnswer();
                            } else {
                              Util.showToast(
                                  context, "Please tap the picture!");
                            }
                          },
                          borderSide: BorderSide(color: Color(0xFF777777)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Body(
                            "Save",
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        ],
      ),
      bottomNavigationBar: widget.isReview ? BottomBackButton() : null,
      backgroundColor: Theme.of(context).backgroundColor,
    );
  }

  ///This updates the circle co-ords on the image
  void _handleTap(TapDownDetails details) {
    final RenderBox referenceBox = context.findRenderObject();
    setState(() {
      isTapped = true;
      tapPos = referenceBox.globalToLocal(details.globalPosition);
      posX = tapPos.dx - 50;
      posY = tapPos.dy - (_getPositions() + 50);
    });
  }

  ///returns a [double] this is the y pos of the image
  double _getPositions() {
    final RenderBox renderBoxImage =
        _keyImage.currentContext.findRenderObject();
    final imagePos = renderBoxImage.localToGlobal(Offset.zero);

    return imagePos.dy;
  }

  ///Updates the transparency value of the accent color
  setTransparentColor() {
    return transparentAccent = HexColor(
        '80' + Theme.of(context).accentColor.toString().substring(10, 16));
  }

  void saveAnswer() async {
    widget.activity.userXCoord = posX;
    widget.activity.userYCoord = posY;
    await ActivityBean.of(context).update(widget.activity);
    Navigator.of(context).pop();
  }
}
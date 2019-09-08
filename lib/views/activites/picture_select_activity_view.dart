import 'dart:io';

import 'package:discover_deep_cove/data/models/activity/activity.dart';
import 'package:discover_deep_cove/env.dart';
import 'package:discover_deep_cove/util/hex_color.dart';
import 'package:discover_deep_cove/util/screen.dart';
import 'package:discover_deep_cove/widgets/activities/activity_app_bar.dart';
import 'package:discover_deep_cove/widgets/activities/activity_pass_save_bar.dart';
import 'package:discover_deep_cove/widgets/activities/editAnswer.dart';
import 'package:discover_deep_cove/widgets/misc/text/body.dart';
import 'package:discover_deep_cove/widgets/misc/bottom_back_button.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:discover_deep_cove/widgets/activities/selected_photo.dart';

class PictureSelectActivityView extends StatefulWidget {
  final Activity activity;
  final bool isReview;

  ///Takes in a [PictureSelectActivity] and a [bool] and displays the view based
  ///on the value of the [bool], you can complete the activity if the [bool] is false
  ///and review it if the [bool] is true.
  PictureSelectActivityView({this.activity, this.isReview});

  @override
  _PictureSelectActivityViewState createState() =>
      _PictureSelectActivityViewState();
}

class _PictureSelectActivityViewState extends State<PictureSelectActivityView> {
  int photoIndex = 0;

  previousImage() {
    setState(() => photoIndex = photoIndex > 0 ? photoIndex - 1 : 0);
  }

  nextImage() {
    setState(() => photoIndex = photoIndex =
        photoIndex < widget.activity.imageOptions.length - 1
            ? photoIndex + 1
            : photoIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ActivityAppBar(widget.activity.title),
      body: buildContent(),
      bottomNavigationBar: widget.isReview
          ? BottomBackButton()
          : ActivityPassSaveBar(onTapSave: () => saveAnswer()),
      backgroundColor: Theme.of(context).backgroundColor,
    );
  }

  buildContent() {
    return (Screen.isTablet(context) && Screen.isLandscape(context))
        ? GridView.count(
            crossAxisCount: 2,
            children: [
              getTopHalf(),
              getBottomHalf(),
            ],
          )
        : Column(
            children: [
              getTopHalf(),
              getBottomHalf(),
            ],
          );
  }

  getTopHalf() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Screen.width(context, percentage: 5),
            vertical: Screen.height(context, percentage: 1.25),
          ),
          child: Body(
            widget.activity.description,
            size: Screen.isTablet(context) ? 30 : null,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Screen.width(context, percentage: 5),
            vertical: Screen.height(context, percentage: 1.25),
          ),
          child: Body(
            widget.activity.task,
            size: Screen.isTablet(context) ? 30 : null,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Screen.width(context, percentage: 5),
            vertical: Screen.height(context, percentage: 1.25),
          ),
          child: Divider(
            color: HexColor("FFFFFFFF"),
          ),
        ),
      ],
    );
  }

  getBottomHalf() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Screen.height(context, percentage: 5),
            vertical: Screen.height(context, percentage: 1.25),
          ),
          child: Column(
            children: <Widget>[
              widget.isReview
                  ? Body(
                      "You Answered:",
                      size: Screen.isTablet(context) ? 30 : null,
                    )
                  : Container(),
              Body(
                !widget.isReview
                    ? widget.activity.imageOptions[photoIndex].name
                    : widget.activity.selectedPicture.name,
                size: Screen.isTablet(context) ? 30 : null,
              ),
            ],
          ),
        ),
        !widget.isReview
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      FontAwesomeIcons.chevronLeft,
                      color: Colors.white,
                      size: Screen.isTablet(context)
                          ? Screen.height(context, percentage: 5)
                          : Screen.height(context, percentage: 2.5),
                    ),
                    onPressed: previousImage,
                  ),
                  Column(
                    children: <Widget>[
                      Container(
                        height: Screen.width(context,
                            percentage: Screen.isTablet(context) &&
                                    Screen.isLandscape(context)
                                ? 35
                                : Screen.isTablet(context)
                                    ? 70
                                    : Screen.isSmall(context) ? 55 : 65),
                        width: Screen.width(context,
                            percentage: Screen.isTablet(context) &&
                                    Screen.isLandscape(context)
                                ? 35
                                : Screen.isTablet(context)
                                    ? 70
                                    : Screen.isSmall(context) ? 55 : 65),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: FileImage(
                              File(
                                Env.getResourcePath(widget
                                    .activity.imageOptions[photoIndex].path),
                              ),
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: Screen.height(
                            context,
                            percentage: 2.5,
                          ),
                        ),
                        child: Container(
                          child: SelectedPhoto(
                            numberOfDots: widget.activity.imageOptions.length,
                            photoIndex: photoIndex,
                            context: context,
                          ),
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: Icon(
                      FontAwesomeIcons.chevronRight,
                      color: Colors.white,
                      size: Screen.isTablet(context)
                          ? Screen.height(context, percentage: 5)
                          : Screen.height(context, percentage: 2.5),
                    ),
                    onPressed: nextImage,
                  ),
                ],
              )
            : Container(
                height: Screen.width(context,
                    percentage:
                        Screen.isTablet(context) && Screen.isLandscape(context)
                            ? 30
                            : Screen.isTablet(context)
                                ? 65
                                : Screen.isSmall(context) ? 50 : 60),
                width: Screen.width(context,
                    percentage:
                        Screen.isTablet(context) && Screen.isLandscape(context)
                            ? 30
                            : Screen.isTablet(context)
                                ? 65
                                : Screen.isSmall(context) ? 50 : 60),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: FileImage(
                      File(
                        Env.getResourcePath(
                            widget.activity.selectedPicture.path),
                      ),
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
        widget.isReview
            ? Padding(
                padding: const EdgeInsets.all(20.0),
                child: EditAnswer(),
              )
            : Container(),
      ],
    );
  }

  saveAnswer() async {
    widget.activity.selectedPictureId =
        widget.activity.imageOptions[photoIndex].id;
    await ActivityBean.of(context).update(widget.activity);
    Navigator.of(context).pop();
  }
}

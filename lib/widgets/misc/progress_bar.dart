import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class ProgressBar extends StatelessWidget {
  final double percent;

  ProgressBar({this.percent});

  @override
  Widget build(BuildContext context) {
    return LinearPercentIndicator(
      width: MediaQuery.of(context).size.width - 50,
      animation: true,
      animateFromLastPercent: true,
      lineHeight: 20.0,
      animationDuration: 2500,
      percent: percent,
      linearStrokeCap: LinearStrokeCap.roundAll,
      progressColor: Theme.of(context).accentColor,
    );
  }
}

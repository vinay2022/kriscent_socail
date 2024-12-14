import 'package:flutter/cupertino.dart';

const normalFontSize = 25.0;
const normalIconSize = 40.0;
const norma1lIconSize = 30.0;
const textSize = 18;
const textBoldFont = 20.0;

class AppSizes {
  BuildContext context;

  AppSizes({required this.context});

  double get getHeight => MediaQuery.sizeOf(context).height;

  double get getWidth => MediaQuery.sizeOf(context).height;
}
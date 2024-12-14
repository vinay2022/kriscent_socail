import 'package:flutter/cupertino.dart';

extension Spaces on int {
  SizedBox get width => SizedBox(width: toDouble(),);
  SizedBox get height => SizedBox(height: toDouble(),);
  BorderRadius get borderRadius => BorderRadius.circular(toDouble());
  RoundedRectangleBorder get shapeBorderRadius => RoundedRectangleBorder(  borderRadius:BorderRadius.circular(toDouble()));
  EdgeInsets get allPadding => EdgeInsets.all(toDouble());
  EdgeInsets get horizontalPadding => EdgeInsets.symmetric(horizontal: toDouble());
}

extension Responsive on BuildContext{
  double get screenWidth => MediaQuery.sizeOf(this).width;
  double get screenHeight=> MediaQuery.sizeOf(this).height;
}
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class MyColors {
  static final Color backgroundColor = HexColor("#2D2121");
  static final Color appMainColor = HexColor("#FEB629");
  static final Color menuHeadlineColor = HexColor("#F1CE53");
}

class MyTextTheme {
  static final appHeadline = TextStyle(
      fontFamily: "Lobster", fontSize: 36, color: HexColor("#FEB629"));

  static final menuHeadline = TextStyle(
      fontFamily: "RibeyeMarrow", fontSize: 20, color: HexColor("#F1CE53"));
  static final menu =
      TextStyle(fontFamily: "AbrilFatface", color: HexColor("#FEB629"));
}

import 'package:flutter/material.dart';

const defaultEdge = EdgeInsets.fromLTRB(13, 6, 13, 6);
const Color navLightColor = Colors.white;
final Color navDarkColor = Colors.grey.shade900;

const smallTextStyle = TextStyle(fontSize: 12);

const paywallEdge = EdgeInsets.fromLTRB(16, 32, 16, 16);
const iapTosEdge = EdgeInsets.all(16);

// UI Colors
const kColorBar = Colors.pinkAccent;
const kColorText = Colors.black54;
const kPlanColorText = Colors.white;
const kColorBackground = Colors.white;

// Text Styles
const kFontSizeSuperSmall = 10.0;
const kFontSizeNormal = 16.0;
const kFontSizeMedium = 18.0;
const kFontSizeLarge = 96.0;

const kDescriptionTextStyle = TextStyle(
  color: kColorText,
  fontWeight: FontWeight.normal,
  fontSize: kFontSizeNormal,
);

const kTitleTextStyle = TextStyle(
  color: kPlanColorText,
  fontWeight: FontWeight.bold,
  fontSize: kFontSizeMedium,
);

const purchaseExtraStyle = TextStyle(
  fontSize: 12,
  color: Colors.grey,
  fontWeight: FontWeight.normal,
);

String getMonospaceFontFamily() {
  return 'DroidSansMNerdFontMono';
}

final tileValueStyle = TextStyle(
  color: Colors.grey.shade500,
  fontWeight: FontWeight.normal,
);


import 'package:flutter/cupertino.dart';

import 'colors.dart';

const Gradient kBGGradient2 = LinearGradient(
colors: [
  colorWhite,
colorLightBlue,
],
begin: FractionalOffset(0.0, 1.0),
end: FractionalOffset(0.0, 0.0),
stops: [0.0, 0.4],
tileMode: TileMode.decal,
);

const Gradient kBGGradient = LinearGradient(
colors: [
  colorWhite,
  colorBlue,
],
begin: Alignment.topLeft,
end: Alignment.bottomRight,
stops: [0.0, 1.0],
);




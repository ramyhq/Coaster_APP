
import 'package:flutter/cupertino.dart';

import 'colors.dart';

const Gradient kBGGradient = LinearGradient(
colors: [
colorBlue,
colorLightBlue,
],
begin: FractionalOffset(0.0, 1.0),
end: FractionalOffset(0.0, 0.0),
stops: [0.0, 1.0],
tileMode: TileMode.decal,
);
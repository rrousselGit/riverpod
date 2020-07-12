import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

final marvelLogo = kIsWeb
    // workaround to https://github.com/dnfield/flutter_svg/issues/173
    ? Image.network('/assets/assets/marvel.svg', semanticLabel: 'Marvel Logo')
    : SvgPicture.asset('assets/marvel.svg', semanticsLabel: 'Marvel Logo');

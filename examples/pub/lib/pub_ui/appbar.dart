import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PubAppbar extends StatelessWidget implements PreferredSizeWidget {
  const PubAppbar({super.key});
  static const _webProxy = 'https://api.codetabs.com/v1/proxy';
  static const _dartLogoURL =
      'https://pub.dev/static/hash-6pt3begn/img/pub-dev-logo.svg';

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF1c2834),
      title: SvgPicture.network(
        kIsWeb ? '$_webProxy/?quest=$_dartLogoURL' : _dartLogoURL,
        width: 150,
      ),
    );
  }

  @override
  Size get preferredSize => AppBar().preferredSize;
}

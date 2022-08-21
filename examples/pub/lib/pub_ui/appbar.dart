import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'user_avatar.dart';

class PubAppbar extends StatelessWidget implements PreferredSizeWidget {
  const PubAppbar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF1c2834),
      title: SvgPicture.network(
        'https://pub.dev/static/hash-6pt3begn/img/pub-dev-logo.svg',
        width: 150,
      ),
      // toolbarHeight: 80,
      actions: [
        StreamBuilder<User?>(
          stream: FirebaseAuth.instance.userChanges(),
          builder: (context, snapshot) {
            final user = snapshot.data;
            if (user == null) return Container();

            return Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(right: 10),
              child: GoogleUserCircleAvatar(identity: user),
            );
          },
        )
      ],
    );
  }

  @override
  Size get preferredSize => AppBar().preferredSize;
  // const Size(double.infinity, 100);
}

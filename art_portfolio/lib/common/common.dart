import 'package:art_portfolio/pages/userPage.dart';
import 'package:flutter/material.dart';

class AvatarImage extends StatelessWidget {
  const AvatarImage({super.key,
  required this.avatarSrc,
  required this.size,
  required this.padding});

  final String avatarSrc;
  final double size;
  final double padding;

  @override
  Widget build(BuildContext context) {
    if (avatarSrc.length > 6) {
      return Padding(padding: const EdgeInsets.all(14.0), child: ClipRRect(
                          borderRadius: BorderRadius.circular(size/2),
                            child: Image.network(avatarSrc, height: size, width: size)));
    }

    return Padding(padding: const EdgeInsets.all(14.0), child: ClipRRect(
                          borderRadius: BorderRadius.circular(size/2),
                            child: Image.asset('assets/images/default.png', height: size, width: size)));
  }
}

void goToProfile(BuildContext context, String inputUserID) async {
  Route route = MaterialPageRoute(builder: (context) => UserPageMaterial(userID: inputUserID));
  await Navigator.pushReplacement(context, route);
}
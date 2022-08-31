import 'package:flutter/material.dart';

void nextScreen(context, page) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => page));
}

void nextScreenReplace(context, page) {
  Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => page));
}

void nextScreenRemoveUntil(context, page) {
  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(builder: (context) => page),
    (route) => false,
  );
}

void pushNewScreen(BuildContext context, Widget page) {
  Navigator.push(
    context,
    createRoute(page),
  );
}

Route createRoute(Widget page) {
  return PageRouteBuilder(
    transitionDuration: const Duration(microseconds: 800),
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return SlideTransition(
        position: animation.drive(Tween<Offset>(
          begin: const Offset(1.0, 0.0),
          end: Offset.zero,
        )),
        child: child,
      );
    },
  );
}

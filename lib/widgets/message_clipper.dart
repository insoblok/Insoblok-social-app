import 'package:flutter/material.dart';

class MessageChatClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var radius = 12.0;

    var path = Path();
    path.moveTo(radius * 2, 0);
    path.quadraticBezierTo(
      radius,
      0,
      radius,
      radius,
    );
    path.lineTo(radius, size.height - radius);
    path.quadraticBezierTo(
      radius,
      size.height,
      0,
      size.height,
    );
    path.lineTo(size.width - radius, size.height);
    path.quadraticBezierTo(
      size.width,
      size.height,
      size.width,
      size.height - radius,
    );
    path.lineTo(size.width, radius);
    path.quadraticBezierTo(
      size.width,
      0,
      size.width - radius,
      0,
    );
    path.lineTo(radius * 2, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}

class MessageMeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var radius = 12.0;

    var path = Path();
    path.moveTo(radius, 0);
    path.quadraticBezierTo(
      0,
      0,
      0,
      radius,
    );
    path.lineTo(0, size.height - radius);
    path.quadraticBezierTo(
      0,
      size.height,
      radius,
      size.height,
    );
    path.lineTo(size.width, size.height);
    path.quadraticBezierTo(
      size.width - radius,
      size.height,
      size.width - radius,
      size.height - radius,
    );
    path.lineTo(size.width - radius, radius);
    path.quadraticBezierTo(
      size.width - radius,
      0,
      size.width - radius * 2,
      0,
    );
    path.lineTo(radius, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}

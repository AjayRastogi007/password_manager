import 'package:flutter/material.dart';

class CustomAppBarContainer extends StatelessWidget {
  const CustomAppBarContainer({super.key, required this.context});

  final BuildContext context;

  @override
  Widget build(context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return ClipPath(
      clipper: CustomAppBarClipper(),
      child: Container(
        color: colorScheme.primary,
        padding: const EdgeInsets.all(0),
        child: Stack(
          children: [
            Positioned(
                top: -200,
                right: -250,
                child: customContainer(400, 400, 400, 0, null,
                    colorScheme.onPrimary.withOpacity(0.1))),
            Positioned(
                top: 50,
                right: -300,
                child: customContainer(400, 400, 400, 0, null,
                    colorScheme.onPrimary.withOpacity(0.1))),
          ],
        ),
      ),
    );
  }

  Container customContainer(double? width, double? height, double radius,
      double padding, Widget? child, Color color) {
    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: child,
    );
  }
}

class CustomAppBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height);

    final firstCurve = Offset(0, size.height - 20);
    final lastCurve = Offset(30, size.height - 20);
    path.quadraticBezierTo(
        firstCurve.dx, firstCurve.dy, lastCurve.dx, lastCurve.dy);

    final secondFirstCurve = Offset(0, size.height - 20);
    final secondLastCurve = Offset(size.width - 30, size.height - 20);
    path.quadraticBezierTo(secondFirstCurve.dx, secondFirstCurve.dy,
        secondLastCurve.dx, secondLastCurve.dy);

    final thirdFirstCurve = Offset(size.width, size.height - 20);
    final thirdLastCurve = Offset(size.width, size.height);
    path.quadraticBezierTo(thirdFirstCurve.dx, thirdFirstCurve.dy,
        thirdLastCurve.dx, thirdLastCurve.dy);

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}

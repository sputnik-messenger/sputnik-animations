// Copyright (C) 2019 Mohammed El Batya
//
// This file is part of sputnik_animations.
//
// sputnik_animations is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.

library sputnik_animation;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sputnik_animations/sputnik_shader.dart';
import 'dart:math';

import 'package:sputnik_animations/stars.dart';

class SputnikAnimation extends StatefulWidget {
  final bool runAnimation;

  const SputnikAnimation({Key key, this.runAnimation}) : super(key: key);

  @override
  _SputnikAnimationState createState() => _SputnikAnimationState();
}

class _SputnikAnimationState extends State<SputnikAnimation> with SingleTickerProviderStateMixin {
  AnimationController rotationController;
  Animation<double> animation;

  @override
  void initState() {
    rotationController = AnimationController(
      duration: const Duration(milliseconds: 4000),
      vsync: this,
    );
    if (widget.runAnimation) {
      rotationController.forward();
    }
    super.initState();
  }

  @override
  void dispose() {
    rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildLogo();
  }

  Widget _buildLogo() {
    return AspectRatio(
      aspectRatio: 1,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Ring(
            controller: rotationController,
          ),
          Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Block(
                height: 1,
                width: 3,
                alignment: Alignment(1, -4),
              ),
              Block(
                height: 1,
                alignment: Alignment(-3, -2),
              ),
              Block(
                height: 1,
                width: 2,
                alignment: Alignment(0, 0),
              ),
              Block(
                alignment: Alignment(3, 2),
              ),
              Block(
                width: 3,
                alignment: Alignment(-1, 4),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Ring extends AnimatedWidget {
  Animation<double> animation1;
  Animation<double> animation2;
  int phase = 0;
  final List<Offset> stars = <Offset>[];
  double ct = 0;

  Ring({Key key, AnimationController controller}) : super(key: key, listenable: controller) {
    final c1 = CurveTween(curve: Curves.linear);
    final c2 = CurveTween(curve: Curves.linear);
    animation1 = controller.drive(c1);
    animation2 = controller.drive(c2);

    controller.addStatusListener((s) {
      if (s == AnimationStatus.completed) {
        phase = phase == 0 ? 1 : 0;
        controller.forward(from: 0);
      }
    });

    controller.addListener(() {
      ct += controller.value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: RingPainter(phase == 0 ? animation1.value : animation2.value, phase),
      child: Stars(ct),
    );
  }
}

class RingPainter extends CustomPainter {
  final gradient = const SweepGradient(colors: [
    const Color.fromARGB(255, 232, 83, 180),
    const Color.fromARGB(255, 232, 108, 83),
    const Color.fromARGB(255, 83, 232, 185),
  ], stops: [
    0.0,
    0.3,
    0.75
  ]);

  Paint _paint;
  Paint _white = Paint()..color = Colors.white;
  int phase;
  final double t;

  RingPainter(this.t, this.phase) {
    _paint = Paint()
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..color = Colors.red;
  }

  void drawArcWithRadius(Canvas canvas, double radius, Paint paint) {
    final bounds = Rect.fromCircle(center: Offset.zero, radius: radius);
    final pt = phase == 0 ? t : (1 - t);
    final startAngle = pi / 30;

    paint.strokeWidth = paint.strokeWidth * pt.clamp(0.1, 0.2);

    final sweepAngle = 1.31 * pi * (pt + 0.2);
    canvas.drawArc(bounds, startAngle, sweepAngle, false, paint);

    _paint.strokeWidth = _paint.strokeWidth * 0.8;
    canvas.drawArc(bounds, (-sweepAngle + pt * pi * 0.12), pi * 0.045, false, paint);
    _paint.strokeWidth = _paint.strokeWidth * 0.8;
    canvas.drawArc(bounds, (-sweepAngle + pt * pi), -pi * 0.036, false, paint);
    _paint.strokeWidth = _paint.strokeWidth * 0.8;
    canvas.drawArc(bounds, (-sweepAngle - pt * pi * 0.38), pi * 0.01, false, paint);
    canvas.drawCircle(Offset.fromDirection(0, radius), radius * 0.35 * 0.3, _white);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final radius = size.height * 0.37;
    canvas.translate(size.width / 2, size.height / 2);

    final rotate = 2 * pi * (1 - t);
    canvas.save();
    canvas.rotate(pi * 1.3 + rotate);
    _paint
      ..shader = SputnikShader.shader
      ..strokeWidth = size.height * 0.08;
    drawArcWithRadius(canvas, radius, _paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class Block extends StatelessWidget {
  final int height;
  final int width;
  final Alignment alignment;
  final Color color;
  static const pixelEdge = 0.07;
  static const sputnikGreen = Color.fromARGB(255, 181, 232, 83);

  const Block({
    Key key,
    this.height = 1,
    this.width = 1,
    this.alignment = const Alignment(0, 0),
    this.color = sputnikGreen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Relative(
      height: height * pixelEdge,
      width: width * pixelEdge,
      alignment: Alignment(_mapAlignmentStep(alignment.x), _mapAlignmentStep(alignment.y)),
      child: AnimatedContainer(
        duration: Duration(microseconds: 500),
        color: color,
      ),
    );
  }

  double _mapAlignmentStep(double steps) {
    final gap = (1 - pixelEdge) / 2;
    final step = pixelEdge / 2;
    return (steps * step) / gap;
  }
}

class Relative extends StatelessWidget {
  final Widget child;
  final Alignment alignment;
  final double height;
  final double width;

  const Relative({
    Key key,
    this.child,
    this.alignment,
    this.height,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: FractionallySizedBox(
        heightFactor: height,
        widthFactor: width,
        child: child,
      ),
    );
  }
}

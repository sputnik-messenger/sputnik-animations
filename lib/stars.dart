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

import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:sputnik_animations/sputnik_shader.dart';


class Stars extends StatelessWidget {
  final stars = List<List<Offset>>();
  final double t;

  Stars(this.t) {
    final Random random = Random(8);

    stars.addAll([List<Offset>(), List<Offset>(), List<Offset>()]);

    for (int i = 0; i < 20; i++) {
      stars[0].add(Offset.fromDirection(random.nextDouble() * 2 * pi, random.nextDouble()));
    }
    for (int i = 0; i < 20; i++) {
      stars[1].add(Offset.fromDirection(random.nextDouble() * 2 * pi, random.nextDouble()));
    }
    for (int i = 0; i < 20; i++) {
      stars[2].add(Offset.fromDirection(random.nextDouble() * 2 * pi, random.nextDouble()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: StarsPainter(stars, t),
    );
  }
}

class StarsPainter extends CustomPainter {
  final List<List<Offset>> stars;
  static final p = Paint()
    ..strokeWidth = 1.5
    ..strokeCap = StrokeCap.round
    ..shader = SputnikShader.shader;

  final double t;
  StarsPainter(this.stars, this.t);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.translate(size.width/2, size.height/2);
    canvas.save();
    canvas.scale(1+(t/5000)%1000);
    canvas.drawPoints(PointMode.points, stars[0].map((s) => s.scale(size.height, size.height)).toList(), p);
    canvas.restore();
    canvas.save();
    canvas.rotate(t/2000);
    canvas.scale(1+t/2000);
    canvas.drawPoints(PointMode.points, stars[1].map((s) => s.scale(size.height, size.height)).toList(), p);
    canvas.restore();
    canvas.rotate(t/2000);
    canvas.drawPoints(PointMode.points, stars[2].map((s) => s.scale(size.height, size.height)).toList(), p);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

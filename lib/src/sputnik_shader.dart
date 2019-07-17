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


import 'package:flutter/painting.dart';

class SputnikShader {

  static final gradient = const SweepGradient(colors: [
    const Color.fromARGB(255, 232, 83, 180),
    const Color.fromARGB(255, 232, 108, 83),
    const Color.fromARGB(255, 83, 232, 185),
  ], stops: [
    0.0,
    0.3,
    0.75
  ]);

  SputnikShader();

  static Shader get shader {
    return gradient.createShader(Rect.fromCircle(center: Offset.zero, radius: 1));
  }

}

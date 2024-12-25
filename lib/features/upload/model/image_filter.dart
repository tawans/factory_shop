import 'package:flutter/material.dart';

class ImageFilter {
  final String name;
  final double brightness;
  final double contrast;
  final double saturation;

  const ImageFilter({
    required this.name,
    this.brightness = 1.0,
    this.contrast = 1.0,
    this.saturation = 1.0,
  });

  static const List<ImageFilter> presets = [
    ImageFilter(name: '원본'),
    ImageFilter(
      name: '선명',
      contrast: 1.2,
      saturation: 1.1,
    ),
    ImageFilter(
      name: '흑백',
      saturation: 0.0,
    ),
    ImageFilter(
      name: '빈티지',
      brightness: 0.9,
      contrast: 1.1,
      saturation: 0.8,
    ),
    ImageFilter(
      name: '따뜻한',
      brightness: 1.1,
      saturation: 1.2,
    ),
    ImageFilter(
      name: '차가운',
      brightness: 0.9,
      saturation: 0.8,
    ),
  ];
}

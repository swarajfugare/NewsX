import 'package:flutter/material.dart';

class NewsCategory {
  final String id;
  final String name;
  final IconData icon;
  final Color accentColor;
  final String description;

  const NewsCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.accentColor,
    required this.description,
  });
}

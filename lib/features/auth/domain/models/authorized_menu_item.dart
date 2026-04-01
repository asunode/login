import 'package:flutter/material.dart';

class AuthorizedMenuItem {
  const AuthorizedMenuItem({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
  });

  final String id;
  final String title;
  final String description;
  final IconData icon;
}



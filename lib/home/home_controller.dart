import 'package:flutter/material.dart';
import 'package:flutter_application_1/home/widgets/categories_button.dart';

class HomeController {
  final List<CategoriesButton> categories = [
    CategoriesButton(
      icon: Icons.language,
      categoryName: 'Website',
      value: '15',
    ),
    CategoriesButton(
      icon: Icons.lock,
      categoryName: 'App',
      value: '10',
    ),
    CategoriesButton(
      icon: Icons.credit_card,
      categoryName: 'Card',
      value: '8',
    ),
    CategoriesButton(
      icon: Icons.note,
      categoryName: 'Notes',
      value: '5',
    ),
  ];
}

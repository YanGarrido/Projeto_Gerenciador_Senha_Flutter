import 'package:flutter/material.dart';
import 'package:flutter_application_1/home/widgets/categories_button.dart';
import 'package:flutter_application_1/shared/app_colors.dart';

class HomeController {
  final List<CategoriesButton> categories = [
    CategoriesButton(
      icon: Icons.language,
      categoryName: 'Website',
      value: '15',
      backgroundColor: AppColors.lightblue,
      iconColor: AppColors.darkblue,
    ),
    CategoriesButton(
      icon: Icons.wallet_travel_outlined,
      categoryName: 'Banking',
      value: '10',
      backgroundColor: AppColors.lightgreen,
      iconColor: AppColors.darkgreen,
    ),
    CategoriesButton(
      icon: Icons.key,
      categoryName: 'Personal',
      value: '8',
      backgroundColor: AppColors.lightpurple,
      iconColor: AppColors.darkpurple,
    ),
    CategoriesButton(
      icon: Icons.wallet_travel_outlined,
      categoryName: 'Work',
      value: '5',
      backgroundColor: AppColors.lightorange,
      iconColor: AppColors.darkorange,
    ),
  ];
}

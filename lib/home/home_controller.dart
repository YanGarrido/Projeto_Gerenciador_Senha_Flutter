import 'package:flutter/material.dart';
import 'package:flutter_application_1/home/widgets/categories_button.dart';
import 'package:flutter_application_1/core/constants/app_colors.dart';
import 'package:flutter_application_1/shared/models/password_model.dart';

class HomeController {
  List<CategoriesButton> getCategories(List<PasswordModel> passwords) {
    final websiteCount = passwords.where((p) => p.category == 'Websites').length;
    final bankingCount = passwords.where((p) => p.category == 'Banking').length;
    final personalCount = passwords.where((p) => p.category == 'Personal').length;
    final workCount = passwords.where((p) => p.category == 'Work').length;

    return [
      CategoriesButton(
        icon: Icons.language,
        categoryName: 'Websites',
        value: websiteCount.toString(),
        backgroundColor: AppColors.lightblue,
        iconColor: AppColors.darkblue,
      ),
      CategoriesButton(
        icon: Icons.wallet_travel_outlined,
        categoryName: 'Banking',
        value: bankingCount.toString(),
        backgroundColor: AppColors.lightgreen,
        iconColor: AppColors.darkgreen,
      ),
      CategoriesButton(
        icon: Icons.key,
        categoryName: 'Personal',
        value: personalCount.toString(),
        backgroundColor: AppColors.lightpurple,
        iconColor: AppColors.darkpurple,
      ),
      CategoriesButton(
        icon: Icons.wallet_travel_outlined,
        categoryName: 'Work',
        value: workCount.toString(),
        backgroundColor: AppColors.lightorange,
        iconColor: AppColors.darkorange,
      ),
    ];
  }
}

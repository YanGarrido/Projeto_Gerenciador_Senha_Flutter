import 'package:flutter/material.dart';
import 'package:flutter_application_1/home/home_controller.dart';
import 'package:flutter_application_1/home/widgets/categories_button.dart';
import 'package:flutter_application_1/shared/models/password_model.dart';
import 'package:flutter_application_1/screens/category_screen.dart';

class Categories extends StatelessWidget {
  final List<PasswordModel> passwords;

  const Categories({
    super.key,
    required this.passwords,
  });

  @override
  Widget build(BuildContext context) {
    final controller = HomeController();
    final categories = controller.getCategories(passwords);

    return Column(
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            crossAxisCount: 2,
            childAspectRatio: 1.8,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return CategoriesButton(
              icon: category.icon,
              categoryName: category.categoryName,
              value: category.value,
              backgroundColor: category.backgroundColor,
              iconColor: category.iconColor,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CategoryScreen(
                      categoryName: category.categoryName,
                      passwords: passwords,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}

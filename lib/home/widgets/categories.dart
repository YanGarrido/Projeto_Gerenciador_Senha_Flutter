import 'package:flutter/material.dart';
import 'package:flutter_application_1/home/home_controller.dart';
import 'package:flutter_application_1/home/widgets/categories_button.dart';

class Categories extends StatelessWidget {
  const Categories({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = HomeController();

    return SizedBox(
      height: 300,
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisSpacing: 10,
          mainAxisSpacing: 5,
          crossAxisCount: 2,
          childAspectRatio: 1.8,
        ),
        itemCount: controller.categories.length,
        itemBuilder: (context, index) {
          final category = controller.categories[index];
          return CategoriesButton(
            icon: category.icon,
            categoryName: category.categoryName,
            value: category.value,
          );
        },
      ),
    );
  }
}

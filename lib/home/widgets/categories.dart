import 'package:flutter/material.dart';
import 'package:flutter_application_1/home/home_controller.dart';
import 'package:flutter_application_1/home/widgets/categories_button.dart';
import 'package:flutter_application_1/shared/models/password_model.dart';
import 'package:flutter_application_1/screens/category_screen.dart';

class Categories extends StatelessWidget {
  final List<PasswordModel> passwords;
  final String? selectedCategory;

  const Categories({
    super.key,
    required this.passwords,
    this.selectedCategory,
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
          // Adicionei padding extra aqui para a sombra não cortar
          padding: const EdgeInsets.symmetric(vertical: 4), 
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            crossAxisCount: 2,
            // Aumentei para 2.1 para deixar os cartões mais compactos (menos altos)
            // Isso ajuda a evitar o scroll desnecessário
            childAspectRatio: 2.1, 
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            final isSelected = selectedCategory == category.categoryName;
            return CategoriesButton(
              icon: category.icon,
              categoryName: category.categoryName,
              value: category.value,
              backgroundColor: category.backgroundColor,
              iconColor: category.iconColor,
              isSelected: isSelected,
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
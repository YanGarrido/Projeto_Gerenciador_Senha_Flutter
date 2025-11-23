import 'package:flutter/material.dart';
import 'package:flutter_application_1/home/home_controller.dart';
import 'package:flutter_application_1/home/widgets/categories_button.dart';
import 'package:flutter_application_1/shared/models/password_model.dart';
import 'package:flutter_application_1/screens/category_screen.dart'; // Ajuste o import conforme sua pasta

class Categories extends StatelessWidget {
  final List<PasswordModel> passwords;
  final String? selectedCategory;
  final VoidCallback? onUpdate; // Recebe o aviso da Home

  const Categories({
    super.key,
    required this.passwords,
    this.selectedCategory,
    this.onUpdate,
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
          padding: const EdgeInsets.symmetric(vertical: 4), 
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            crossAxisCount: 2,
            childAspectRatio: 2.1, 
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
<<<<<<< HEAD
              isSelected: isSelected,
              onTap: () async {
                // Navega e ESPERA (await) voltar
                await Navigator.push(
=======
              onTap: () {
                Navigator.push(
>>>>>>> d2a57d63858c055e585967ba8dd02f567353b11c
                  context,
                  MaterialPageRoute(
                    builder: (context) => CategoryScreen(
                      categoryName: category.categoryName,
                      passwords: passwords,
                    ),
                  ),
                );
                
                // Quando voltar, avisa a Home para atualizar tudo
                if (onUpdate != null) {
                  onUpdate!();
                }
              },
            );
          },
        ),
      ],
    );
  }
}
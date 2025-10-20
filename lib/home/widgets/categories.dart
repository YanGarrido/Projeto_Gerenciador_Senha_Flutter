import 'package:flutter/material.dart';
import 'package:flutter_application_1/home/widgets/categories_button.dart';

class Categories extends StatelessWidget {
  const Categories({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 4,
      children: [
        Padding(padding: const EdgeInsets.all(8.0), child: CategoriesButton()),
      ],
    );
  }
}

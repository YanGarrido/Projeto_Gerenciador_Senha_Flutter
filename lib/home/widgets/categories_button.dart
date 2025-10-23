import 'package:flutter/material.dart';
import 'package:flutter_application_1/shared/app_colors.dart';

class CategoriesButton extends StatelessWidget {
  final IconData icon;
  final String categoryName;
  final String value;
  const CategoriesButton({
    super.key,
    required this.icon,
    required this.categoryName,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10.0),
      width: 110,
      height: 170,
      padding: const EdgeInsets.all(17.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        color: Colors.white,
      ),
      child: Row(
        spacing: 10,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: AppColors.lightblue,
            ),

            child: Icon(
              icon,
              size: 24,
            ),
          ),

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(categoryName),
              Text(value),
              Text('Description'),
            ],
          ),
        ],
      ),
    );
  }
}

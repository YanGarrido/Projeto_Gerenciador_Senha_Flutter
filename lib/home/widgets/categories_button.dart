import 'package:flutter/material.dart';

class CategoriesButton extends StatelessWidget {
  final IconData icon;
  final String categoryName;
  final String value;
  final Color backgroundColor;
  final Color iconColor;
  final VoidCallback? onTap;

  const CategoriesButton({
    super.key,
    required this.icon,
    required this.categoryName,
    required this.value,
    required this.backgroundColor,
    required this.iconColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15.0),
      child: Container(
        margin: const EdgeInsets.only(top: 10.0),
        width: 110,
        height: 170,
        padding: const EdgeInsets.all(17.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: Colors.white,
        ),
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.only(right: 12.0),
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: backgroundColor,
              ),
              child: Icon(
                icon,
                size: 24,
                color: iconColor,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(categoryName),
                Text(value),
                const Text('Password'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

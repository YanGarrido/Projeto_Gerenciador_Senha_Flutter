import 'package:flutter/material.dart';

class CategoriesButton extends StatelessWidget {
  const CategoriesButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          children: [
            Column(
              children: [
                Container(width: 20, height: 20),
                Container(width: 8, height: 20),
                Container(width: 20, height: 0),
              ],
            ),
          ],
        ),
        Column(
          children: [
            Column(
              children: [
                Text(
                  "Websites",
                  style: TextStyle(
                    fontSize: 13.600000381469727,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Text(
                  "15",
                  style: TextStyle(
                    fontSize: 11.899999618530273,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  " passwords",
                  style: TextStyle(
                    fontSize: 11.899999618530273,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_application_1/home/widgets/categories.dart';
import 'package:flutter_application_1/home/widgets/password_view.dart';
import 'package:flutter_application_1/home/widgets/search_bar_widget.dart';
import 'package:flutter_application_1/shared/app_colors.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        centerTitle: false,
        title: const Text(
          'PassMan',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.darkblue,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: SearchBarWidget(),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Categorias',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Categories(),
                  PasswordView(
                    title: 'Twitter',
                    email: 'twitter@example.com',
                    password: 'twitter_password',
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Recent passwords',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text('View all'),
                      ),
                    ],
                  ),
                  PasswordView(
                    title: 'Gmail',
                    email: 'gmail@example.com',
                    password: 'gmail_password',
                  ),
                  PasswordView(
                    title: 'Gmail',
                    email: 'gmail@example.com',
                    password: 'gmail_password',
                  ),
                  PasswordView(
                    title: 'Gmail',
                    email: 'gmail@example.com',
                    password: 'gmail_password',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

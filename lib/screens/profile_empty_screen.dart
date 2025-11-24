import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/profile_register_screen.dart';
import 'package:flutter_application_1/screens/login_screen.dart';

class ProfileEmptyScreen extends StatelessWidget {
  const ProfileEmptyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.person, size: 80, color: Colors.grey),
            const SizedBox(height: 20),

            const Text(
              "You are not logged in",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),
            const Text("Create an account or log in to continue."),
            const SizedBox(height: 30),

           
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ProfileRegisterScreen(),
                  ),
                );
              },
              child: const Text("Create account"),
            ),

            const SizedBox(height: 10),

            
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const LoginScreen(),
                  ),
                );
              },
              child: const Text("I already have an account"),
            ),
          ],
        ),
      ),
    );
  }
}

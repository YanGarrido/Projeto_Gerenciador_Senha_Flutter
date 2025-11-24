import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_1/core/constants/app_routes.dart';
import 'package:flutter_application_1/shared/services/password_service.dart';
import 'package:flutter_application_1/shared/models/password_model.dart';
import 'package:flutter_application_1/shared/widgets/top_bar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? name;
  String? email;
  String? memberSince;

  int totalPasswords = 0;
  int strongPasswords = 0;
  int weakPasswords = 0;
  int duplicatePasswords = 0;

  bool isLogged = false;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();

    final savedName = prefs.getString("user_name");
    final savedEmail = prefs.getString("user_email");

    final PasswordService service = PasswordService();
    final List<PasswordModel> passwords = await service.getAllPasswords();

    int strong = 0;
    int weak = 0;
    int duplicates = 0;

    for (var p in passwords) {
      if (p.password.length >= 10) {
        strong++;
      } else {
        weak++;
      }
    }

    final Map<String, int> count = {};
    for (var p in passwords) {
      count[p.password] = (count[p.password] ?? 0) + 1;
    }
    duplicates = count.values.where((c) => c > 1).length;

    setState(() {
      name = savedName;
      email = savedEmail;
      memberSince = prefs.getString("member_since");

      totalPasswords = passwords.length;
      strongPasswords = strong;
      weakPasswords = weak;
      duplicatePasswords = duplicates;

      isLogged = (savedName != null && savedEmail != null);
    });
  }

  String formatMemberSince(String? iso) {
    if (iso == null) return "Member since -";

    final date = DateTime.parse(iso);

    const months = [
      "January", "February", "March", "April", "May", "June",
      "July", "August", "September", "October", "November", "December",
    ];

    return "Member since   ${months[date.month - 1]} ${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    if (!isLogged) {
      return Scaffold(
        backgroundColor: const Color(0xFFF3F4F6),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "You are not logged in.",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2D3E50),
                ),
              ),

              const SizedBox(height: 26),

              SizedBox(
                width: 180,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E4DF5),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  onPressed: () => Navigator.pushNamed(context, AppRoutes.login),
                  child: const Text(
                    "Go to Login",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              SizedBox(
                width: 180,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF1E4DF5),
                    side: const BorderSide(
                      color: Color(0xFF1E4DF5),
                      width: 1.4,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () => Navigator.pushNamed(context, AppRoutes.register),
                  child: const Text(
                    "Create account",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),

        appBar: TopBar(
          title: "Profile",
          showBackButton: false,
          actions: [
            IconButton(
              icon: const Icon(Icons.settings, color: Colors.white),
              onPressed: () => Navigator.pushNamed(context, AppRoutes.settings),
            ),
          ],
        ),



      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1E4DF5), Color(0xFF1B40C9)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Theme.of(context).colorScheme.surface,
                        child: const Icon(Icons.person, size: 40, color: Colors.grey),
                      ),
                      const SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name ?? "User",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            email ?? "email not registered",
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_month,
                        color: Colors.white70,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        formatMemberSince(memberSince),
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              "Security Score",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    totalPasswords == 0
                        ? "0%"
                        : "${((strongPasswords / totalPasswords) * 100).round()}%",
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text("Overall Security"),
                  const SizedBox(height: 10),
                  LinearProgressIndicator(
                    value: totalPasswords == 0
                        ? 0
                        : strongPasswords / totalPasswords,
                    backgroundColor: Colors.grey[300],
                    color: const Color(0xFF1E4DF5),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              "Password Statistics",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            GridView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.6,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              children: [
                statCard(Icons.lock, totalPasswords, "Total Passwords"),
                statCard(Icons.verified, strongPasswords, "Strong Passwords"),
                statCard(Icons.warning, weakPasswords, "Weak Passwords"),
                statCard(Icons.copy, duplicatePasswords, "Duplicates"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget statCard(IconData icon, int value, String label) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 28, color: const Color(0xFF1E4DF5)),
          const SizedBox(height: 10),
          Text(
            value.toString(),
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text(label),
        ],
      ),
    );
  }
}

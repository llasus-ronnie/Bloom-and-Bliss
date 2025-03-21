import 'package:flutter/material.dart';
import 'package:bloom_and_bliss/sidenav.dart';
import 'package:bloom_and_bliss/constants/colors.dart';

void main() {
  runApp(const ProfilePage());
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    const String apptitle = "Bloom & Bliss";
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: apptitle,
      theme: ThemeData(
        fontFamily: 'Recoleta',
      ),
      home: Scaffold(
        backgroundColor: AppColors.pink,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: AppBar(
            backgroundColor: AppColors.beige,
            centerTitle: true,
            flexibleSpace: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 5),
                child: Image.asset("assets/sidenav/bnb-logo.png", height: 70),
              ),
            ),
            iconTheme: const IconThemeData(color: AppColors.pink),
          ),
        ),
        drawer: Sidenav(),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Your Profile",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Recoleta',
                  color: AppColors.beige,
                ),
              ),
              const SizedBox(height: 20),
              const ProfileCard(),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.beige,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircleAvatar(
              backgroundImage: AssetImage('assets/sidenav/guest-icon.png'),
              radius: 50,
            ),
            const SizedBox(height: 20),
            _buildTextField(label: "Name", hintText: "Enter your name"),
            const SizedBox(height: 10),
            _buildTextField(label: "Email", hintText: "Enter your email"),
            const SizedBox(height: 10),
            _buildTextField(label: "Number", hintText: "Enter your number"),
            const SizedBox(height: 10),
            _buildTextField(label: "Password", hintText: "Enter your password", obscureText: true),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  onPressed: () {},
                  child: const Text(
                    "Delete Account",
                    style: TextStyle(fontFamily: 'Recoleta', fontWeight: FontWeight.bold),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.pink,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  ),
                  onPressed: () {},
                  child: const Text(
                    "Save",
                    style: TextStyle(fontFamily: 'Recoleta', fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({required String label, required String hintText, bool obscureText = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'Recoleta',
            color: AppColors.pink,
          ),
        ),
        const SizedBox(height: 5),
        TextField(
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(fontFamily: 'Recoleta', color: AppColors.black),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.pink),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          ),
        ),
      ],
    );
  }
}
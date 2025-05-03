import 'package:flutter/material.dart';
import 'package:bloom_and_bliss/sidenav.dart';
import 'package:bloom_and_bliss/constants/colors.dart';
import '../models/user.dart';
import 'edit_profile_page.dart';
import 'signup_page.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatelessWidget {
  final User user;
  const ProfilePage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      drawer: Sidenav(user: user),
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
            ProfileCard(user: user),
          ],
        ),
      ),
    );
  }
}

class ProfileCard extends StatelessWidget {
  final User user;
  const ProfileCard({super.key, required this.user});

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete Account"),
          content: const Text("Are you sure you want to delete your account? This action cannot be undone."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () {
                _deleteAccount(context);
              },
              child: const Text("Delete", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _deleteAccount(BuildContext context) async {
    try {
      final currentUser = firebase_auth.FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        // Delete user document from Firestore
        await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).delete();

        // Delete user from Firebase Auth
        await currentUser.delete();

        // Navigate to SignUp page
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => SignUpPage(
              user: User(fullName: '', email: '', password: '', phoneNumber: 0),
            ),
          ),
              (route) => false,
        );
      } else {
        throw Exception('No user is currently signed in.');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete account: $e')),
      );
    }
  }
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
            Column(
              children: [
                Text('${user.fullName}'),
                Text('${user.email}'),
                Text('${user.phoneNumber}'),
              ],
            ),
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
                  onPressed: () {
                    _confirmDelete(context);
                  },
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
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EditProfilePage(user: user)),
                    );
                  },
                  child: const Text(
                    "Update Profile",
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
}

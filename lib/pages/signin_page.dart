import 'package:flutter/material.dart';
import 'package:bloom_and_bliss/constants/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bloom_and_bliss/models/user.dart' as CustomUser;
import 'package:bloom_and_bliss/main.dart';
import 'package:bloom_and_bliss/pages/signup_page.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.yellow,
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20.0),
          child: SignInCard(),
        ),
      ),
    );
  }
}

class SignInCard extends StatelessWidget {
  const SignInCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 8,
      color: const Color.fromRGBO(255, 255, 255, 0.9),
      child: const Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image(
              image: AssetImage('assets/sidenav/bnb-logo.png'),
              height: 100,
            ),
            SizedBox(height: 10),
            Text(
              "Welcome Back!",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.black,
                fontFamily: 'Recoleta',
              ),
            ),
            SizedBox(height: 20),
            SignInForm(),
            SizedBox(height: 20),
            SignUpText(),
          ],
        ),
      ),
    );
  }
}

class SignInForm extends StatefulWidget {
  const SignInForm({super.key});

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _signInUser() async {
    try {
      // Firebase Authentication sign-in
      UserCredential userCred = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Get user data from Firestore using the UID
      final uid = userCred.user!.uid;
      final userData = await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (userData.exists) {
        final data = userData.data()!;

        // Create a custom User object
        CustomUser.User customUser = CustomUser.User(
          fullName: data['fullName'],
          email: data['email'],
          password: '', // Do not store password here
          phoneNumber: int.tryParse(data['phoneNumber'].toString()) ?? 0,
        );

        // Navigate to the Home page (MyApp) with the user object
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => MyApp()),
        );
      }
    } catch (e) {
      print("Sign-in failed: $e");
      // Optionally, display an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to sign in. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTextField("Email", Icons.email, controller: _emailController),
        _buildTextField("Password", Icons.lock, obscureText: true, controller: _passwordController),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[400],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text("Back", style: TextStyle(color: Colors.white, fontFamily: 'Recoleta')),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                onPressed: _signInUser,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.pink,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text("Sign In", style: TextStyle(color: Colors.white, fontFamily: 'Recoleta')),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTextField(String label, IconData icon, {bool obscureText = false, required TextEditingController controller}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          labelText: label,
          labelStyle: const TextStyle(fontFamily: 'PTSerif'),
          prefixIcon: Icon(icon, color: AppColors.pink),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}

class SignUpText extends StatelessWidget {
  const SignUpText({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SignUpPage(
              user: CustomUser.User(
                fullName: '',
                email: '',
                password: '',
                phoneNumber: 0,
              ),
            ),
          ),
        );
      },
      child: const Text.rich(
        TextSpan(
          text: "Don't have an account? ",
          style: TextStyle(fontFamily: 'PTSerif', color: AppColors.black),
          children: [
            TextSpan(
              text: "Sign up",
              style: TextStyle(
                color: AppColors.pink,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
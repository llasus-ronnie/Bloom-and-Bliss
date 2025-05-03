import 'package:flutter/material.dart';
import 'package:bloom_and_bliss/main.dart';
import 'package:bloom_and_bliss/constants/colors.dart';
import '../models/user.dart'; // Your custom User model
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth; // Alias the Firebase User class
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(SignUpPage(user: User(fullName: '', email: '', password: '', phoneNumber: 0)));
}

class SignUpPage extends StatelessWidget {
  final User user;
  const SignUpPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Bloom & Bliss - Sign Up",
      home: Scaffold(
        body: Stack(
          children: [
            // Background Image
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/flowers-bg.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Centered Content
            Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Logo
                      Image.asset(
                        'assets/sidenav/bnb-logo.png',
                        height: 100,
                      ),
                      const SizedBox(height: 10),
                      // Sign Up Card
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 8,
                        color: Colors.white.withOpacity(0.9),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                "Create an Account",
                                style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontFamily: 'Recoleta'
                                ),
                              ),
                              const SizedBox(height: 20),
                              SignUpForm(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  Future<void> signUp() async {
    try {
      // Create user with Firebase Auth
      firebase_auth.UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      // After creating the user, save additional information in Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'fullName': fullNameController.text,
        'email': emailController.text,
        'phoneNumber': int.parse(phoneController.text),
      });

      // Navigate to the app's main screen with custom User model
      User user = User(
        fullName: fullNameController.text,
        email: emailController.text,
        password: passwordController.text,
        phoneNumber: int.parse(phoneController.text),
      );

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MyApp()),
      );
    } on firebase_auth.FirebaseAuthException catch (e) {
      String errorMessage = '';
      if (e.code == 'weak-password') {
        errorMessage = 'The password is too weak.';
      } else if (e.code == 'email-already-in-use') {
        errorMessage = 'The account already exists for that email.';
      }
      // Show error message to user
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage)));
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildTextField("Full Name", Icons.person, fullNameController),
          buildTextField("Email", Icons.email, emailController, isEmail: true),
          buildTextField("Phone Number", Icons.phone, phoneController),
          buildTextField("Password", Icons.lock, passwordController, obscureText: true),
          buildTextField("Confirm Password", Icons.lock, confirmPasswordController, obscureText: true),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Navigator.pop(context); // Going back to previous page
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[400],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text("Back", style: TextStyle(color: Colors.white, fontFamily: 'Recoleta')),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Process sign-up
                      signUp();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.pink,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text("Sign Up", style: TextStyle(color: Colors.white, fontFamily: 'Recoleta')),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildTextField(
      String labelText,
      IconData icon,
      TextEditingController controller,
      {bool obscureText = false, bool isEmail = false}
      ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          labelText: labelText,
          labelStyle: const TextStyle(fontFamily: 'PTSerif'),
          prefixIcon: Icon(icon, color: AppColors.pink),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "$labelText is required";
          }
          if (isEmail && !RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA0-9.-]+\.[a-zA-Z]{2,}$").hasMatch(value)) {
            return "Enter a valid email";
          }
          if (labelText == "Confirm Password" && value != passwordController.text) {
            return "Passwords do not match";
          }
          return null;
        },
      ),
    );
  }
}

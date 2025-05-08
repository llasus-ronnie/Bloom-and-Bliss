import 'package:flutter/material.dart';
import 'package:bloom_and_bliss/main.dart';
import 'package:bloom_and_bliss/constants/colors.dart';
import '../models/user.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
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
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  // image: AssetImage("assets/homepage/image1.jpg"),
                  image: AssetImage("assets/flowers-bg.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset('assets/sidenav/bnb-logo.png', height: 100),
                      const SizedBox(height: 10),
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 8,
                        color: Colors.white.withOpacity(0.9),
                        child: const Padding(
                          padding: EdgeInsets.all(20.0),
                          child: SignUpForm(),
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

class _SignUpFormState extends State<SignUpForm> with SingleTickerProviderStateMixin {
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();

  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  late AnimationController _animationController;
  late Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _opacity = Tween<double>(begin: 1.0, end: 0.3).animate(_animationController);
  }

  Future<void> signUp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });
    _animationController.forward();

    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'fullName': fullNameController.text,
        'email': emailController.text,
        'phoneNumber': int.parse(phoneController.text),
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => MyApp()),
      );
    } on firebase_auth.FirebaseAuthException catch (e) {
      String error = 'An error occurred.';
      if (e.code == 'weak-password') error = 'The password is too weak.';
      if (e.code == 'email-already-in-use') error = 'Email is already in use.';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Something went wrong.')));
    } finally {
      setState(() {
        _isLoading = false;
      });
      _animationController.reverse();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FadeTransition(
          opacity: _opacity,
          child: AbsorbPointer(
            absorbing: _isLoading,
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const Text(
                    "Create an Account",
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontFamily: 'Recoleta'),
                  ),
                  const SizedBox(height: 20),
                  buildTextField("Full Name", Icons.person, fullNameController),
                  buildTextField("Email", Icons.email, emailController, isEmail: true),
                  buildTextField("Phone Number", Icons.phone, phoneController),
                  buildTextField("Password", Icons.lock, passwordController, obscureText: true),
                  buildTextField("Confirm Password", Icons.lock, confirmPasswordController, obscureText: true),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const MyApp())),
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
                          onPressed: signUp,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.pink,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          child: const Text("Sign Up", style: TextStyle(color: Colors.white, fontFamily: 'Recoleta')),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        if (_isLoading)
          const Positioned.fill(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(color: AppColors.pink),
                  SizedBox(height: 16),
                  Text(
                    "You are almost in...",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.pink,
                      fontFamily: 'Recoleta',
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget buildTextField(String labelText, IconData icon, TextEditingController controller,
      {bool obscureText = false, bool isEmail = false}) {
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
          if (value == null || value.isEmpty) return "$labelText is required";
          if (isEmail && !RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$").hasMatch(value)) {
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

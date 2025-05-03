import 'package:flutter/material.dart';
import 'package:bloom_and_bliss/main.dart';
import 'package:bloom_and_bliss/constants/colors.dart';
import '../models/user.dart';
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
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  void addUser() async {
    try {
      await _firestore.collection('users').add({
        'fullName': fullNameController.text,
        'email': emailController.text,
        'password': passwordController.text,
        'phoneNumber': int.parse(phoneController.text),
      });

      print("Data added successfully!");


      User user = User(
        fullName: fullNameController.text,
        email: emailController.text,
        password: passwordController.text,
        phoneNumber: int.parse(phoneController.text),
      );


      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MyApp(user: user)),
      );
    } catch (e) {
      print("Error adding data: $e");
    }
  }


  void getUserInfo(String userName) async {

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .get();

    for (var doc in querySnapshot.docs) {
      var data = doc.data() as Map<String, dynamic>;

      if (data['fullName'] == userName) {
        print("Found Document ID: ${doc.id}");
        print("Data: $data");
        return;
      }
    }

    print("No user found with name: ");
  }

  void updateDataUser(String docId) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(docId)
        .update({
      'fullName': 'Olivia Rodrigo',
      'email': 'liv@gmail.com',
      'password': 'password123',
      'phoneNumber': 9876543210,
    });
  }

  @override
  Widget build(BuildContext context) {
    final User user;
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
                      User user = User(
                        fullName: fullNameController.text,
                        email: emailController.text,
                        password: passwordController.text,
                        phoneNumber: int.parse(phoneController.text),
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MyApp(user: user)),
                      );
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
                      addUser();
                      // getUserInfo(fullNameController.text);
                      // updateDataUser("ucwia6EvXbM9kevf8XDX");
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
          if (isEmail && !RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$").hasMatch(value)) {
            return "Enter a valid email";
          }
          if (labelText == "Confirm Password" && value != passwordController.text) {
            return "Passwords do not match";
          }
          return null;
        },
        onChanged: (value) {
          setState(() {
            _formKey.currentState!.validate();
          });
        },
      ),
    );
  }
}

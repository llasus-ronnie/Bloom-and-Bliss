import 'package:flutter/material.dart';
import '../models/user.dart';
import 'profile_page.dart';
import 'package:bloom_and_bliss/constants/colors.dart';

class EditProfilePage extends StatefulWidget {
  final User user;
  const EditProfilePage({super.key, required this.user});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController fullNameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;

  @override
  void initState() {
    super.initState();
    fullNameController = TextEditingController(text: widget.user.fullName);
    emailController = TextEditingController(text: widget.user.email);
    phoneController = TextEditingController(text: widget.user.phoneNumber.toString());
  }

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  void saveProfile() {
    if (_formKey.currentState!.validate()) {
      User updatedUser = User(
        fullName: fullNameController.text,
        email: emailController.text,
        phoneNumber: int.parse(phoneController.text),
        password: widget.user.password, // Keep the existing password
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ProfilePage(user: updatedUser)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        backgroundColor: AppColors.pink,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              buildTextField("Full Name", fullNameController),
              buildTextField("Email", emailController),
              buildTextField("Phone Number", phoneController),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: saveProfile,
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.pink),
                child: const Text("Save Changes", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String labelText, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        validator: (value) => value!.isEmpty ? "$labelText is required" : null,
      ),
    );
  }
}

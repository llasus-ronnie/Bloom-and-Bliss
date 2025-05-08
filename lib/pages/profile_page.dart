import 'package:flutter/material.dart';
import 'package:bloom_and_bliss/sidenav.dart';
import 'package:bloom_and_bliss/constants/colors.dart';
import '../models/user.dart';
import 'edit_profile_page.dart';
import 'signup_page.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/submitted_orders.dart';
import '../constants/custom_button.dart';

class ProfilePage extends StatefulWidget {
  final User user;

  const ProfilePage({Key? key, required this.user}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List<QueryDocumentSnapshot> _submittedOrders = [];

  @override
  void initState() {
    super.initState();
    fetchSubmittedOrders();
  }

  Future<void> fetchSubmittedOrders() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('orders')
        .where('userId', isEqualTo: widget.user.id)
        .get();

    setState(() {
      _submittedOrders = snapshot.docs;
    });
  }


  void handleSelect(Map<String, dynamic> data, String docId) {
    print("Selected order: $docId");
  }

  void handleUpdate(String docId) {
    final order = (_submittedOrders.firstWhere((doc) => doc.id == docId).data() as Map<String, dynamic>);

    showDialog(
      context: context,
      builder: (context) {
        return EditOrderModal(docId: docId, orderData: order);
      },
    );
  }

  void handleRemove(String docId) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Remove Order"),
          content: const Text("Are you sure you want to remove this order? This action cannot be undone."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                try {
                  await FirebaseFirestore.instance.collection('orders').doc(docId).delete();
                  setState(() {
                    _submittedOrders.removeWhere((doc) => doc.id == docId);
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Order removed successfully")),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Error removing order: $e")),
                  );
                }
              },
              child: const Text("Remove", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

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
      drawer: Sidenav(user: widget.user),
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
            ProfileCard(user: widget.user),
            const SizedBox(height: 30),
            SubmittedOrdersSection(
              docs: _submittedOrders,
              onSelect: handleSelect,
              onUpdate: handleUpdate,
              onRemove: handleRemove,
            ),
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
                Navigator.pop(context);
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
        await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).delete();
        await currentUser.delete();

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => SignUpPage(user: User(fullName: '', email: '', password: '', phoneNumber: 0)),
          ),
              (route) => false,
        );
      } else {
        throw Exception('No user is currently signed in.');
      }
    } catch (e) {
      if (e is firebase_auth.FirebaseAuthException && e.code == 'requires-recent-login') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please log in again to delete your account.')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to delete account: $e')));
      }
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
            const SizedBox(height: 15),
            Text(user.fullName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Recoleta')),
            Text(user.email, style: TextStyle(fontSize: 16, color: Colors.grey[700])),
            Text('${user.phoneNumber}', style: TextStyle(fontSize: 16, color: Colors.grey[700])),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomButton(
                  "Delete Account",
                  AppColors.red,
                      () {
                    _confirmDelete(context);
                  },
                ),
                CustomButton(
                  "Update Profile",
                  AppColors.pink,
                      () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EditProfilePage(user: user)),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class EditOrderModal extends StatefulWidget {
  final String docId;
  final Map<String, dynamic> orderData;

  const EditOrderModal({Key? key, required this.docId, required this.orderData}) : super(key: key);

  @override
  _EditOrderModalState createState() => _EditOrderModalState();
}

class _EditOrderModalState extends State<EditOrderModal> {
  late TextEditingController _nameController;
  late TextEditingController _regionController;
  late TextEditingController _addressController;
  late TextEditingController _phoneController;
  late TextEditingController _cityController;
  late TextEditingController _zipController;
  late TextEditingController _additionalInfoController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.orderData['name']);
    _regionController = TextEditingController(text: widget.orderData['region']);
    _addressController = TextEditingController(text: widget.orderData['address']);
    _phoneController = TextEditingController(text: widget.orderData['phone']);
    _cityController = TextEditingController(text: widget.orderData['city']);
    _zipController = TextEditingController(text: widget.orderData['zip']);
    _additionalInfoController = TextEditingController(text: widget.orderData['additionalInfo']);
  }

  void _updateOrder() async {
    try {
      await FirebaseFirestore.instance.collection('orders').doc(widget.docId).update({
        'name': _nameController.text,
        'region': _regionController.text,
        'address': _addressController.text,
        'phone': _phoneController.text,
        'city': _cityController.text,
        'zip': _zipController.text,
        'additionalInfo': _additionalInfoController.text,
      });

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Order updated successfully")));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error updating order: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Edit Order"),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField("Name", _nameController),
            _buildTextField("Region", _regionController),
            _buildTextField("Address", _addressController),
            _buildTextField("Phone", _phoneController),
            _buildTextField("City", _cityController),
            _buildTextField("Zip Code", _zipController),
            _buildTextField("Additional Info", _additionalInfoController),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Cancel"),
        ),
        CustomButton("Update Order", AppColors.pink, _updateOrder),
      ],
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(labelText: label),
      ),
    );
  }
}

class SubmittedOrdersSection extends StatelessWidget {
  final List<QueryDocumentSnapshot> docs;
  final Function(Map<String, dynamic>, String) onSelect;
  final Function(String) onUpdate;
  final Function(String) onRemove;

  const SubmittedOrdersSection({
    Key? key,
    required this.docs,
    required this.onSelect,
    required this.onUpdate,
    required this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: docs.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          final doc = docs[index];
          final order = doc.data() as Map<String, dynamic>;
          final docId = doc.id;
          final List<dynamic> items = order['items'] ?? [];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  "Orders",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Recoleta',
                    color: AppColors.beige,
                  ),
                ),
              ),
              Card(
                color: AppColors.beige,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 5,
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Name: ${order['name']}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Text("Region: ${order['region']}"),
                      Text("Address: ${order['address']}"),
                      Text("Phone: ${order['phone']}"),
                      Text("City: ${order['city']}"),
                      const SizedBox(height: 10),

                      if (items.isNotEmpty) ...[
                        const Text("Items:", style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 5),
                        ...items.map((item) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: Text("- ${item['name']} x${item['quantity']} @ ₱${item['price']}"),
                          );
                        }).toList(),
                        const SizedBox(height: 10),
                      ],

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CustomButton("Remove", AppColors.red, () {
                            onRemove(docId);
                          }),
                          CustomButton("Update", AppColors.pink, () {
                            onUpdate(docId);
                          }),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
    );
  }
}

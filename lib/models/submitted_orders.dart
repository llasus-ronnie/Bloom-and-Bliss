import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bloom_and_bliss/constants/colors.dart';
import 'package:intl/intl.dart';

class SubmittedOrdersSection extends StatefulWidget {
  final List<QueryDocumentSnapshot> docs;
  final Function(Map<String, dynamic>, String) onSelect;
  final Function(String) onUpdate; // Callback for updating an order
  final Function(String) onRemove; // Callback for removing an order

  const SubmittedOrdersSection({
    Key? key,
    required this.docs,
    required this.onSelect,
    required this.onUpdate, // Pass this function
    required this.onRemove, // Pass this function
  }) : super(key: key);

  @override
  _SubmittedOrdersSectionState createState() => _SubmittedOrdersSectionState();
}

class _SubmittedOrdersSectionState extends State<SubmittedOrdersSection> {
  String? hoveredId;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Submitted Orders:",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        SizedBox(height: 10),
        ...widget.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          final docId = doc.id;
          return MouseRegion(
            onEnter: (_) => setState(() => hoveredId = docId),
            onExit: (_) => setState(() => hoveredId = null),
            child: GestureDetector(
              onTap: () => widget.onSelect(data, docId),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 200),
                margin: EdgeInsets.symmetric(vertical: 8),
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color:
                  hoveredId == docId ? Colors.grey.shade100 : Colors.white,
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black12,
                        blurRadius: 5,
                        offset: Offset(0, 3))
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    displayField("Name", data['name']),
                    displayField("Region", data['region']),
                    displayField("Address", data['address']),
                    displayField("Phone", data['phone']),
                    displayField("City", data['city']),
                    displayField("Zip", data['zip']),
                    displayField("Additional Info", data['additionalInfo']),
                    displayField(
                        "Timestamp",
                        data['timestamp'] is Timestamp
                            ? DateFormat('yyyy-MM-dd hh:mm a').format(
                            (data['timestamp'] as Timestamp).toDate())
                            : data['timestamp']?.toString()),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () => widget.onUpdate(docId),
                          child: Text("Update"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue, // Corrected parameter name
                          ),
                        ),
                        SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () => widget.onRemove(docId),
                          child: Text("Remove"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red, // Corrected parameter name
                          ),
                        ),

                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget displayField(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: RichText(
        text: TextSpan(
          style: TextStyle(fontSize: 15, fontFamily: '', color: Colors.black),
          children: [
            TextSpan(
              text: "$label: ",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: value?.toString() ?? 'N/A'),
          ],
        ),
      ),
    );
  }
}

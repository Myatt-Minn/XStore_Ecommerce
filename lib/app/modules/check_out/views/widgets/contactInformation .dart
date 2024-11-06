import 'package:flutter/material.dart';
import 'package:xstore/app/modules/check_out/views/widgets/customtextfield.dart';

class ContactInformation extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController phoneNumberController;

  const ContactInformation({
    Key? key,
    required this.nameController,
    required this.phoneNumberController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          const Text(
            "Contact Information",
            style: TextStyle(fontSize: 18, color: Colors.black),
          ),
          const SizedBox(height: 8),
          CustomTextField(
            controller: nameController,
            icon: Icons.person_outline,
            hintText: 'Name',
          ),
          const SizedBox(height: 8),
          CustomTextField(
            controller: phoneNumberController,
            icon: Icons.phone_outlined,
            hintText: 'Phone Number',
          ),
        ],
      ),
    );
  }
}

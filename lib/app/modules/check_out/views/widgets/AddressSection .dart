import 'package:flutter/material.dart';
import 'package:xstore/app/modules/check_out/views/widgets/customtextfield.dart';

class AddressSection extends StatelessWidget {
  final TextEditingController addressController;

  const AddressSection({Key? key, required this.addressController})
      : super(key: key);

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
          const Text("Address",
              style: TextStyle(fontSize: 18, color: Colors.black)),
          const SizedBox(height: 8),
          CustomTextField(
            controller: addressController,
            icon: Icons.home_outlined,
            hintText: 'Address Detail',
          ),
        ],
      ),
    );
  }
}

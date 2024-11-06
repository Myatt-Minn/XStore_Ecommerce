import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class PrivacyPolicyController extends GetxController {
  //TODO: Implement PrivacyPolicyController

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<String?> fetchTermsConditions() async {
    try {
      DocumentSnapshot doc =
          await firestore.collection('legal').doc('policies').get();
      if (doc.exists) {
        return doc['privacyPolicy'] as String?;
      }
    } catch (e) {
      print('Error fetching privacy policies: $e');
    }
    return null;
  }
}

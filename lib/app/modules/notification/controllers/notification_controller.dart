import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:xstore/app/data/notification_model.dart';

class NotificationController extends GetxController {
  RxList<NotificationModel> notifications = RxList<NotificationModel>();

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  // Getter for cart item count
  int get itemCount => notifications.length;
  void fetchNotifications() {
    FirebaseFirestore.instance
        .collection('notifications')
        .orderBy('receivedAt', descending: true)
        .snapshots()
        .listen((snapshot) {
      notifications.value = snapshot.docs
          .map((doc) => NotificationModel.fromDocument(doc))
          .toList();
    });
  }
}

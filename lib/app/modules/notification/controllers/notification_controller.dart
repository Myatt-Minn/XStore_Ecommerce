import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:xstore/app/data/notification_model.dart';

class NotificationController extends GetxController {
  RxList<NotificationModel> notifications = RxList<NotificationModel>();
  RxList<NotificationModel> usernotifications = RxList<NotificationModel>();
  RxBool isViewingAllNotifications = true.obs;
  @override
  void onInit() async {
    super.onInit();
    fetchNotifications();
    getUserNotifications();
  }

  // Getter for cart item count
  int get itemCount => notifications.length;
  void fetchNotifications() {
    FirebaseFirestore.instance
        .collection('notifications')
        .snapshots()
        .listen((snapshot) {
      notifications.value = snapshot.docs
          .map((doc) => NotificationModel.fromDocument(doc.data()))
          .toList();
    });
  }

  // Function to toggle between all notifications and user's notifications
  void toggleNotificationView() {
    isViewingAllNotifications.value = !isViewingAllNotifications.value;
    getUserNotifications();
    fetchNotifications();
  }

  Future<void> getUserNotifications() async {
    try {
      // Get the document for the specific user
      DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      if (docSnapshot.exists) {
        // Cast the data to a Map<String, dynamic>
        Map<String, dynamic>? data =
            docSnapshot.data() as Map<String, dynamic>?;

        if (data != null && data.containsKey('notifications')) {
          // Retrieve the 'notifications' field as a List<dynamic>
          List<dynamic> notifications = data['notifications'];

          // Convert each Map<String, dynamic> to a NotificationModel object
          List<NotificationModel> notificationList = notifications
              .map((notificationData) => NotificationModel.fromDocument(
                  Map<String, dynamic>.from(notificationData)))
              .toList();

          // Update the usernotifications list
          usernotifications.value = notificationList;
        } else {
          usernotifications.clear(); // Make sure to clear the list
        }
      } else {
        throw Exception('User document does not exist');
      }
    } catch (e) {
      print('Error retrieving notifications: $e');
      rethrow;
    }
  }

  Future<void> deleteNotification(NotificationModel notification) async {
    try {
      // Get the current user's ID
      String userId = FirebaseAuth.instance.currentUser!.uid;

      // Update the user's document in Firestore to remove the notification
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'notifications': FieldValue.arrayRemove([
          {
            'id': notification.id,
            'title': notification.title,
            'body': notification.body,

            // Include any other fields that make up the notification object
          }
        ])
      });

      // Remove from local state
      usernotifications.removeWhere((item) => item.id == notification.id);

      // Show success message
      Get.snackbar('Success', 'Notification deleted successfully.');
    } catch (e) {
      print('Error deleting notification: $e');
      Get.snackbar('Error', 'Failed to delete notification: $e');
    }
  }
}

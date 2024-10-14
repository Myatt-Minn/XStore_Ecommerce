import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthGateController extends GetxController {
  //TODO: Implement AuthGateController
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Connectivity _connectivity = Connectivity();
  RxBool hasInternet = true.obs; // Observable for internet connection status
  var isLoading = false.obs;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  @override
  void onInit() {
    super.onInit();

    // Listen for connectivity changes
    _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        // No internet connection
        hasInternet.value = false;
        Get.offAllNamed('/no-internet');
        isLoading.value = false; // Stop loading after the check
      } else {
        // Internet is available
        hasInternet.value = true;
        _checkAuthentication();
      }
    });

    // Initial check for internet and authentication
    _checkInternetConnection();
  }

  _checkInternetConnection() async {
    isLoading.value = true; // Start loading
    final result = await _connectivity.checkConnectivity();
    if (result == ConnectivityResult.none) {
      hasInternet.value = false;
      Get.offAllNamed('/no-internet');
      isLoading.value = false; // Stop loading if there's no connection
    } else {
      hasInternet.value = true;
      isLoading.value = false; // Stop loading when connection is restored
      _checkAuthentication();
    }
    isLoading.value = false; // Stop loading after the check
  }

  void _checkAuthentication() {
    isLoading.value = true; // Show loading while checking authentication
    authStateChanges.listen((User? user) {
      if (user == null) {
        Get.offNamed('/login');
        isLoading.value = false; // Stop loading after the check
      } else {
        String userId = user.uid;
        DocumentReference userDocRef =
            FirebaseFirestore.instance.collection('users').doc(userId);

        userDocRef.get().then((DocumentSnapshot userDoc) {
          if (userDoc.exists) {
            Map<String, dynamic>? userData =
                userDoc.data() as Map<String, dynamic>?;
            if (userData != null) {
              if (userData['role'] == 'admin') {
                Get.offAllNamed('/admin-panel');
              } else if (userData['role'] == 'premium') {
                Get.offAllNamed('/premium');
              } else {
                Get.offAllNamed('/navigation-screen');
              }
            }
          } else {
            print('User document does not exist');
            Get.offNamed('/login');
          }
        }).catchError((error) {
          print('Error getting user document: $error');
        });
      }
    });
  }

  retryConnection() {
    _checkInternetConnection();
  }
}

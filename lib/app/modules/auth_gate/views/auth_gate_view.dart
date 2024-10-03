import 'package:flutter/material.dart';
import 'package:getwidget/components/loader/gf_loader.dart';

import 'package:get/get.dart';

import '../controllers/auth_gate_controller.dart';

class AuthGateView extends GetView<AuthGateController> {
  const AuthGateView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Center(
      child: GFLoader(),
    ));
  }
}

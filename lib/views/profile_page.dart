import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:travel_app/controllers/auth_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_app/utils/colors.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final authController = Get.find<AuthController>();

  String fullName = '';
  String createdAt = '';
  String lastLogin = '';

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final user = authController.user.value;
    if (user == null) return;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (doc.exists) {
      setState(() {
        fullName = doc['fullName'] ?? '';
        createdAt = doc['createdAt'] != null
            ? (doc['createdAt'] as Timestamp).toDate().toLocal().toString().split(' ')[0]
            : '';
        lastLogin = doc['lastLogin'] != null
            ? (doc['lastLogin'] as Timestamp).toDate().toLocal().toString().split(' ')[0]
            : '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),

            Text(
              'Ad Soyad:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 4),
            Text(fullName, style: TextStyle(fontSize: 16)),

            SizedBox(height: 16),
            Text(
              'Hesap Oluşturulma Tarihi:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 4),
            Text(createdAt, style: TextStyle(fontSize: 16)),

            SizedBox(height: 16),
            Text(
              'Son Giriş Tarihi:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 4),
            Text(lastLogin, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iseeyou_2/models/app_notification.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:typed_data';
import 'dart:io' as io;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

class FetchNotif {
  static Future<List<AppNotification>> fetchNotifications() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('Notification Details')
          .get();

      return snapshot.docs
          .map((doc) => AppNotification.fromFirestore(doc))
          .toList();
    } catch (e) {
      print('Error fetching notifications: $e');
      return [];
    }
  }
}


class FetchInfo {
  static Future<Map<String, String>> fetchUserInfo() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (doc.exists) {
        return {
          'firstname': doc['firstname'] ?? '',
          'lastname': doc['lastname'] ?? '',
          'mobilenum': doc['mobilenum'] ?? '',
          'email': doc['email'] ?? '',
          'Position': doc['Position'] ?? '',
          'profileImageUrl': doc['profileImageUrl'] ?? '',
        };
      } else {
        print('No document for UID: ${user.uid}');
      }
    } else {
      print('No user logged in');
    }
    return {};
  }
}

class ProfileImageUploadAndDisplay {
  static Future<String?> uploadImage(XFile pickedFile) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null || pickedFile == null) return null;

      final ref = FirebaseStorage.instance
          .ref()
          .child('profile_images')
          .child('${user.uid}.jpg');

      if (kIsWeb) {
        Uint8List data = await pickedFile.readAsBytes();
        await ref.putData(data);
      } else {
        final file = io.File(pickedFile.path);
        await ref.putFile(file);
      }

      final downloadURL = await ref.getDownloadURL();
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({'profileImageUrl': downloadURL});

      return downloadURL;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }
}

class EditMobileNum {
  static Future<bool> updateMobileNumber(String newNumber) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null && newNumber.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({'mobilenum': newNumber});
        return true;
      }
    } catch (e) {
      print('Error updating mobile number: $e');
    }
    return false;
  }
}

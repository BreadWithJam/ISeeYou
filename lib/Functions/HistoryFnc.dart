import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iseeyou_2/models/app_notification.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
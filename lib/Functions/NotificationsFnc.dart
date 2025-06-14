import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iseeyou_2/models/app_notification.dart';

class Notif {
  static Future<List<AppNotification>> fetchNotifications() async {
    print("Fetching notifications...");

    final snapshot = await FirebaseFirestore.instance
        .collection('Notification Details')
        .orderBy('Date', descending: true)
        .get();

    print("Documents fetched: ${snapshot.docs.length}");

    return snapshot.docs
        .map((doc) => AppNotification.fromFirestore(doc))
        .toList();
  }
}
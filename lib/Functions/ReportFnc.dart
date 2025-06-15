import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iseeyou_2/models/app_notification.dart';

class Reports {

  static Future<List<AppNotification>> fetchNotifications() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('Notification Details')
        .orderBy('Date', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => AppNotification.fromFirestore(doc))
        .toList();
  }
  static Future<void> updateStatus({
    required String documentId,
    required String newStatus,
  }) async {
    await FirebaseFirestore.instance
        .collection('Notification Details')
        .doc(documentId)
        .update({
      'Status': newStatus,
      'isReported': true,
    });
  }

  static Future<void> updateResponder({
    required String documentId,
    required String newResponder,
  }) async {
    await FirebaseFirestore.instance
        .collection('Notification Details')
        .doc(documentId)
        .update({
      'Responder': newResponder,
      'isReported': true,
    });
  }
}



class PopUpDialogForReport {
  static void showPopup(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: Text(
            message,
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  static Future<bool> getIsReportedFlag(String documentId) async {
    final doc = await FirebaseFirestore.instance
        .collection('Notification Details')
        .doc(documentId)
        .get();

    if (doc.exists && doc.data() != null) {
      final data = doc.data()!;
      return data['isReported'] == true;
    }

    return false;
  }

  static void showSuccessDialog({
    required BuildContext context,
    required VoidCallback onConfirmed,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text("Successfully Reported"),
          content: const Text("The status has been updated successfully."),
          actions: [
            TextButton(
              onPressed: onConfirmed,
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }
}


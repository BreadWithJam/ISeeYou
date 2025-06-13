import 'package:cloud_firestore/cloud_firestore.dart';

class AppNotification {
  final String id;
  final String Title;
  final String Date;
  final String Time;
  final bool isReported;
  final String Location;
  final String camera1;
  final String camera2;
  final String camera3;
  final String camera4;
  final String Status;

  AppNotification({
    required this.id,
    required this.Title,
    required this.Date,
    required this.isReported,
    required this.Location,
    required this.Time,
    required this.camera1,
    required this.camera2,
    required this.camera3,
    required this.camera4,
    required this.Status,



  });

  factory AppNotification.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AppNotification(
      id: doc.id,
      Title: data['Title'] ?? '',
      Date: data['Date'] ?? '',
      isReported: data['isReported'] ?? false,
      Location:  data['Location'] ?? '',
      Time:  data['Time'] ?? '',
      Status:  data['Status'] ?? '',
      camera1: (data['camera1'] ?? '').toString().replaceAll('"', '').trim(),
      camera2: (data['camera2'] ?? '').toString().replaceAll('"', '').trim(),
      camera3: (data['camera3'] ?? '').toString().replaceAll('"', '').trim(),
      camera4: (data['camera4'] ?? '').toString().replaceAll('"', '').trim(),
    );
  }
}
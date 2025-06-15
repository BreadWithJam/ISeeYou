import 'package:cloud_firestore/cloud_firestore.dart';

class AppNotification {
  final String id;
  final String Title;
  final String Date;
  final String Time;
  final bool isReported;
  final String Location;
  final String Camera1;
  final String Camera2;
  final String Camera3;
  final String Camera4;
  final String Status;
  final String Responder;
  final String? folderId;
  final Map<String, dynamic> confidence_scores;

  AppNotification({
    required this.id,
    required this.Title,
    required this.Date,
    required this.isReported,
    required this.Location,
    required this.Time,
    required this.Camera1,
    required this.Camera2,
    required this.Camera3,
    required this.Camera4,
    required this.Status,
    required this.Responder,
    this.folderId,
    required this.confidence_scores,



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
      Responder:  data['Responder'] ?? '',
      folderId: data['folderId'],
      Camera1: (data['Camera1'] ?? '').toString().replaceAll('"', '').trim(),
      Camera2: (data['Camera2'] ?? '').toString().replaceAll('"', '').trim(),
      Camera3: (data['Camera3'] ?? '').toString().replaceAll('"', '').trim(),
      Camera4: (data['Camera4'] ?? '').toString().replaceAll('"', '').trim(),
      confidence_scores: Map<String, dynamic>.from(data['confidence_scores'] ?? {
        'Camera A': 0.0,
        'Camera B': 0.0,
        'Camera C': 0.0,
        'Camera D': 0.0,
      }),
    );
  }
}
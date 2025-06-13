import 'package:flutter/material.dart';
import 'package:iseeyou_2/models/app_notification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iseeyou_2/Tabs/Notifications.dart';
import 'package:iseeyou_2/Widget/BuildCameraImage.dart';


class ReportSummary extends StatefulWidget {
  final AppNotification notification;

  const ReportSummary({super.key, required this.notification});

  @override
  State<ReportSummary> createState() => _ReportSummaryState();
}

class _ReportSummaryState extends State<ReportSummary> {

  @override
  void initState() {
    super.initState();
    loadIsReportedFlag();
  }

  String? selectedResponder;
  String? selectedStatus;
  bool isReported = false;


  final List<String> responders = ['PNP', 'TMU', 'Responder'];
  final List<String> statusOptions = ['On-going', 'Done'];

  Future<void> updateStatusInFirebase(String newStatus) async {
    try {
      await FirebaseFirestore.instance
          .collection('Notification Details')
          .doc(widget.notification.id)
          .update({
        'Status': newStatus,
        'isReported': true,
      });

      setState(() {
        isReported = true;
      });

      showSuccessDialog();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update status: $e')),
      );
    }
  }

  Future<void> loadIsReportedFlag() async {
    final doc = await FirebaseFirestore.instance
        .collection('Notification Details')
        .doc(widget.notification.id)
        .get();

    if (doc.exists && doc.data() != null) {
      final data = doc.data()!;
      setState(() {
        isReported = data['isReported'] == true; // Set state from Firestore
      });
    }
  }


  void showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text("Successfully Reported"),
          content: const Text("The status has been updated successfully."),
          actions: [
            TextButton(
              onPressed: () async {
                // Mark as opened in Firestore
                await FirebaseFirestore.instance
                    .collection('Notification Details')
                    .doc(widget.notification.id)
                    .update({'isOpened': true});


                Navigator.of(context).pop();


                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => NotificationPage()),
                      (Route<dynamic> route) => false,
                );
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Color(0xFF101651),
        elevation: 0,
        title: const Text('Crash', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text("Report Details", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF6C648B))),
            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Picture sa upat ka camera
                  Column(
                    children: [
                      Row(
                        children: [
                          Expanded(child: buildCameraImage(widget.notification.camera1)),
                          const SizedBox(width: 12),
                          Expanded(child: buildCameraImage(widget.notification.camera2)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(child: buildCameraImage(widget.notification.camera3)),
                          const SizedBox(width: 12),
                          Expanded(child: buildCameraImage(widget.notification.camera4)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Text("Location : ${widget.notification.Location}", style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 8),
                  Text("Date : ${widget.notification.Date}", style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 8),
                  Text("Time : ${widget.notification.Time}", style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 20),


                ],
              ),
            ),
            const SizedBox(height: 24),

            // Tong tulo ka buttons
            Column(
              children: [

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Color(0xFF101651),
                  ),
                  child: SizedBox(
                    width: 450,
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedResponder,
                        dropdownColor: Colors.white,
                        hint: const Text('Report to...', style: TextStyle(color:  Colors.white)),
                        items: responders.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value, style: const TextStyle(color: Color.fromARGB(255, 121, 119, 119))),
                          );
                        }).toList(),
                        onChanged: isReported
                            ? null
                            : (String? newValue) {
                          setState(() {
                            selectedResponder = newValue;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Status Dropdown
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Color(0xFF101651),
                  ),
                  child: SizedBox(
                    width: 450, // Set your desired width here
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedStatus,
                        dropdownColor: Colors.white,
                        hint: const Text(
                          'Select Status',
                          style: TextStyle(color: Colors.white),
                        ),
                        items: statusOptions.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: const TextStyle(color: Color.fromARGB(255, 121, 119, 119)),
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedStatus = newValue;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Logic sa report btton
                _buildButton(isReported ? "Update Status" : "Report", Color(0xFF101651), () {
                  if (selectedStatus != null) {
                    updateStatusInFirebase(selectedStatus!);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please select a status first')),
                    );
                  }
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  //tawagon para sa mga button
  Widget _buildButton(String label, Color color, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed, // <- fix here
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 16)),
      ),
    );
  }
}

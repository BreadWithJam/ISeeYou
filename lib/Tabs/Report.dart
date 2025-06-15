import 'package:flutter/material.dart';
import 'package:iseeyou_2/models/app_notification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iseeyou_2/Tabs/Notifications.dart';
import 'package:iseeyou_2/Widget/BuildCameraImage.dart';
import 'package:iseeyou_2/Functions/ReportFnc.dart';
import 'package:iseeyou_2/Widget/BuildButton.dart';

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
      await Reports.updateStatus(
        documentId: widget.notification.id,
        newStatus: newStatus,
      );

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

  void _showCannotModifyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Action Blocked"),
        content: const Text("This report has already been marked as Done and can no longer be modified."),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
  Future<void> loadIsReportedFlag() async {
    final flag = await PopUpDialogForReport.getIsReportedFlag(widget.notification.id);

    setState(() {
      isReported = flag;
    });
  }

  Future<void> showSuccessDialog() async {
    PopUpDialogForReport.showSuccessDialog(
      context: context,
      onConfirmed: () async {
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
    );
  }
///////////////////////////////////////////Start sa UI/////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
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
                          Expanded(child: buildCameraImage(widget.notification.Camera1)),
                          const SizedBox(width: 12),
                          Expanded(child: buildCameraImage(widget.notification.Camera2)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(child: buildCameraImage(widget.notification.Camera3)),
                          const SizedBox(width: 12),
                          Expanded(child: buildCameraImage(widget.notification.Camera4)),
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
                ThreeButtons(
                  label: isReported ? "Update Status" : "Report",
                  color: const Color(0xFF101651),
                  onPressed: () {
                    if (selectedStatus != null) {
                      updateStatusInFirebase(selectedStatus!);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please select a status first')),
                      );
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

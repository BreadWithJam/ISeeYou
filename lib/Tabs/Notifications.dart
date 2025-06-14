import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iseeyou_2/Tabs/Report.dart';
import 'package:iseeyou_2/models/app_notification.dart';
import 'package:iseeyou_2/Tabs/History.dart';
import 'package:iseeyou_2/Widget/BottomNavBar.dart';
import 'package:iseeyou_2/Tabs/MockMap.dart';
import 'package:iseeyou_2/Functions/NotificationsFnc.dart';


class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {

  @override
  void initState() {
    super.initState();
    fetchNotifications();
  }

  List<AppNotification> notifications = [];

  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => History()),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MockHeatMapScreen()),);
    }
  }

  Future<void> fetchNotifications() async {
    final fetchedNotifications = await Notif.fetchNotifications();

    setState(() {
      notifications = fetchedNotifications;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE6F7FF),
      body: SafeArea(

        child: Column(
          children: [
            Container(
              color: Color(0xFF101651),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              width: double.infinity,
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Notifications',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListView.builder(
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final notification = notifications[index];
                  Color indicatorColor;
                  switch (notification.Status?.toLowerCase()) {
                    case 'done':
                      indicatorColor = Colors.green;
                      break;
                    case 'on-going':
                      indicatorColor = Colors.amber;
                      break;
                    case 'pending':
                    default:
                      indicatorColor = Colors.red;
                  }
                  Color backgroundColor;
                  switch (notification.Status?.toLowerCase()) {
                    case 'done':
                    case 'on-going':
                      backgroundColor = Colors.grey[300]!;
                      break;
                    case 'pending':
                    default:
                      backgroundColor = Colors.white;
                  }

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReportSummary(notification: notification),
                        ),
                      ).then((_) {
                        fetchNotifications();
                      });
                    },

                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      child: Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: backgroundColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 4,
                              height: 40,
                              margin: EdgeInsets.only(right: 10, top: 4),
                              decoration: BoxDecoration(
                                color: indicatorColor,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    notification.Title,
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    notification.Date,
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

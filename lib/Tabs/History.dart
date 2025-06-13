import 'package:flutter/material.dart';
import 'package:iseeyou_2/Tabs/HeatMap.dart';
import 'package:iseeyou_2/models/app_notification.dart';
import 'package:iseeyou_2/Tabs/Notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:iseeyou_2/Functions/HistoryFnc.dart';
import 'package:iseeyou_2/Widget/BottomNavBar.dart';
import 'package:iseeyou_2/Tabs/MockMap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io' as io;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'dart:typed_data';

class History extends StatefulWidget {
  const History({super.key});
  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  String _firstname = '';
  String _lastname = '';
  String _mobile = '';
  String _email = '';
  String _position = '';
  String _profileImageUrl = '';

  List<AppNotification> _notifications = [];
  bool _isLoading = true;
  int _selectedIndex = 0;

  XFile? _pickedFile;


  @override
  void initState() {
    super.initState();
    _fetchNotifications();
    _fetchUserInfo();
  }


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => NotificationPage()),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MockHeatMapScreen()),
      );
    }
  }


  Future<void> _uploadImageToFirebase() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null && _pickedFile != null) {
        final ref = FirebaseStorage.instance
            .ref()
            .child('profile_images')
            .child('${user.uid}.jpg');

        if (kIsWeb) {
          Uint8List data = await _pickedFile!.readAsBytes();
          await ref.putData(data);
        } else {
          final file = io.File(_pickedFile!.path);
          await ref.putFile(file);
        }

        final downloadURL = await ref.getDownloadURL();
        print('DEBUG: Uploaded image download URL: $downloadURL');

        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({'profileImageUrl': downloadURL});

        setState(() {
          _profileImageUrl = downloadURL;
          _pickedFile = null;
        });

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Profile image updated'),
          backgroundColor: Colors.green,
        ));

      }
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  void _editMobileNumberDialog() {
    final controller = TextEditingController(text: _mobile);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Mobile Number'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(hintText: 'Enter new mobile number'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final newNumber = controller.text.trim();
              if (newNumber.isNotEmpty) {
                final user = FirebaseAuth.instance.currentUser;
                await FirebaseFirestore.instance.collection('users').doc(user!.uid).update({
                  'mobilenum': newNumber,
                });
                setState(() {
                  _mobile = newNumber;
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Mobile number updated'),
                  backgroundColor: Colors.green,
                ));
              }
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _fetchUserInfo() async {
    final data = await FetchInfo.fetchUserInfo();
    if (data.isNotEmpty) {
      setState(() {
        _firstname = data['firstname']!;
        _lastname = data['lastname']!;
        _mobile = data['mobilenum']!;
        _email = data['email']!;
        _position = data['Position']!;
        _profileImageUrl = data['profileImageUrl'] ?? '';
      });
    }
  }

  //File? _imageFile;

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _pickedFile = picked;
      });
      await _uploadImageToFirebase();
    }
  }


  Future<void> _fetchNotifications() async {
    final notifications = await FetchNotif.fetchNotifications();
    setState(() {
      _notifications = notifications;
      _isLoading = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE6F7FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF101651),
        elevation: 0,
        title: const Text('Reports', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.list),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              color: const Color(0xFFB3E5FC),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 40,
                      backgroundImage: kIsWeb
                          ? (_profileImageUrl.isNotEmpty
                          ? NetworkImage('$_profileImageUrl?t=${DateTime.now().millisecondsSinceEpoch}')
                          : const AssetImage('asset/default_avatar.png') as ImageProvider)
                          : (_pickedFile != null
                          ? FileImage(io.File(_pickedFile!.path))
                          : (_profileImageUrl.isNotEmpty
                          ? NetworkImage('$_profileImageUrl?t=${DateTime.now().millisecondsSinceEpoch}')
                          : const AssetImage('asset/default_avatar.png') as ImageProvider)),
                      backgroundColor: Colors.white,
                    ),
                  ),
                  Center(
                    child: Column(
                      children: [
                        Text(
                          '$_firstname $_lastname',
                          style: const TextStyle(color: Colors.black, fontSize: 18),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          _position,
                          style: const TextStyle(color: Colors.black54, fontSize: 15),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Email and Mobile aligned to the left
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Email: $_email',
                          style: const TextStyle(color: Colors.black54, fontSize: 12),
                        ),
                        SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Mobile: $_mobile',
                              style: const TextStyle(color: Colors.black54, fontSize: 12),
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit, size: 16, color: Colors.black),
                              onPressed: _editMobileNumberDialog,
                              padding: EdgeInsets.zero,
                              constraints: BoxConstraints(),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Expanded(child: Container()),

            Align(
              alignment: Alignment.bottomLeft,
              child: ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Logout'),
                onTap: () async {
                  await FirebaseAuth.instance.signOut();
                },
              ),
            ),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _notifications.length,
        itemBuilder: (context, index) {
          final notification = _notifications[index];
          return Center(
            child: SizedBox(
              width: 260,
              height: 260,
              child: Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFF101651),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Camera Image
                    Padding(
                      padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                          notification.camera1.trim().replaceAll('"', ''),
                          height: 120,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => const SizedBox(
                            height: 120,
                            child: Center(
                              child: Text(
                                'Image failed to load',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Text
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(notification.Location, style: const TextStyle(fontSize: 16, color: Colors.white)),
                          const SizedBox(height: 4),
                          Text(notification.Date, style: const TextStyle(fontSize: 10, color: Colors.white70)),
                          const SizedBox(height: 4),
                          Text(notification.Time, style: const TextStyle(fontSize: 10, color: Colors.white70)),
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
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
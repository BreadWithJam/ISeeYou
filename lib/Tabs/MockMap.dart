import 'package:flutter/material.dart';

class MockHeatMapScreen extends StatelessWidget {
  const MockHeatMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6F7FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF101651),
        title: const Text('Heat Map', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          // Positioned.fill(
          //   child: Image.asset(
          //     //'assets/mock_map.png', // Replace with your mock map image path
          //   //  fit: BoxFit.cover,
          //   ),
          // ),

          // Simulated heat zones
          Positioned(
            top: 120,
            left: 80,
            child: _buildHeatCircle(Colors.red.withOpacity(0.4)),
          ),
          Positioned(
            top: 200,
            left: 150,
            child: _buildHeatCircle(Colors.orange.withOpacity(0.4)),
          ),
          Positioned(
            top: 300,
            left: 100,
            child: _buildHeatCircle(Colors.yellow.withOpacity(0.4)),
          ),

          // Simulated marker
          Positioned(
            top: 250,
            left: 130,
            child: GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text("Crash Report Location"),
                    content: const Text("Simulated crash report marker."),
                  ),
                );
              },
              child: const Icon(Icons.location_on, color: Colors.red, size: 36),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2, // Heat Map tab index
        onTap: (index) {
          // Handle navigation here
        },
        backgroundColor: const Color(0xFF101651),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: '',
          ),
        ],
      ),
    );
  }

  Widget _buildHeatCircle(Color color) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}

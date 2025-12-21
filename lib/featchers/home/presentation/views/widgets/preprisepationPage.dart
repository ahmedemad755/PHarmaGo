import 'package:flutter/material.dart';

class PreparationPage extends StatelessWidget {
  const PreparationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Preparations', 
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: GridView.builder(
          itemCount: 6, // Number of user cards
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
            childAspectRatio: 0.8,
          ),
          itemBuilder: (context, index) => _buildUserCard(context, index),
        ),
      ),
    );
  }

  Widget _buildUserCard(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                // shape: BoxType.circle, // Note: Use BoxShape.circle in actual code
                // // Fixed below for your copy-paste:
               
              ),
              child: Icon(Icons.person_rounded, size: 40, color: Colors.blue[400]),
            ),
            const SizedBox(height: 12),
            const Text("User Name", 
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 4),
            Text("12 Preparations", 
              style: TextStyle(color: Colors.grey[500], fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
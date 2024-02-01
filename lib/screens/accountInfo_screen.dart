import 'package:flutter/material.dart';

class AccountInfoScreen extends StatefulWidget {
  const AccountInfoScreen({super.key});

  @override
  State<AccountInfoScreen> createState() => _AccountInfoScreenState();
}

class _AccountInfoScreenState extends State<AccountInfoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       title: Text('ACCOUNT'),
       backgroundColor: Color.fromARGB(255, 129, 118, 226),
       centerTitle: true, 
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/profile_picture.jpg'), // Replace with the path to the user's profile picture
            ),
            SizedBox(height: 16),
            Text(
              'John Doe', // Replace with the user's name
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'john.doe@example.com', // Replace with the user's email
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // Add logout logic here
                // For example, navigate to login screen
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: Text('Log Out'),
            ),
          ],
        ),
      ),
    );
  }
}
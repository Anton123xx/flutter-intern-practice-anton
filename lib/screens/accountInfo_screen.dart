import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AccountInfoScreen extends StatefulWidget {
  const AccountInfoScreen({super.key});

  @override
  State<AccountInfoScreen> createState() => _AccountInfoScreenState();
}

class _AccountInfoScreenState extends State<AccountInfoScreen> {

  User? user = FirebaseAuth.instance.currentUser;
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ACCOUNT'),
        backgroundColor: Color.fromARGB(255, 129, 118, 226),
        centerTitle: true,
      ),
      body: Center(
        child: user != null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('User Email: ${user!.email}'),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {

                    FirebaseAuth.instance.signOut();
                    
                    Navigator.pushNamed(context, '/signIn_screen');

                

                    },
                    child: const Text('Sign Out'),
                  ),
                ],
              )
            : const Text('User not signed in'),
      ),
    );
  }
}

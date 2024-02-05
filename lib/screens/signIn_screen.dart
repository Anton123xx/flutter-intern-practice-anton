import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/reusable_widget.dart/reusable_widgets.dart';
import 'package:task_manager/screens/home_screen.dart';
import 'package:task_manager/screens/signUp_screen.dart';
import 'package:task_manager/utils/colors_utils.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _passwordTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
           width: MediaQuery.of(context).size.width,
      height:MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          hexStringToColor("CB2B93"),
          hexStringToColor("9546C4"),
          hexStringToColor("5E61F4")
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: SingleChildScrollView(
            child: Padding(
          padding: EdgeInsets.fromLTRB(
              20, MediaQuery.of(context).size.height * 0.2, 20, 0),
          child: Column(children: <Widget>[
            logoWidget("assets/images/logo-placeholder-image.png"),
            const SizedBox(
              height: 30,
            ),
            reusableTextField("Enter Email", Icons.person_outline, false,
             _emailTextController),
            const SizedBox(
              height: 20,
             ),
            reusableTextField("Enter Password", Icons.lock_outline, true,
             _passwordTextController),
            const SizedBox(
              height: 20,
             ),
             signInsignUpButton(context, true, () {
              FirebaseAuth.instance.signInWithEmailAndPassword(
                email: _emailTextController.text, 
                password: _passwordTextController.text).then((value) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const HomeScreen()));
                }).onError((error, stackTrace) {
                  print("Error ${error.toString()}");
                });
             }),
             signUpOption()
          ],
          ),
        )),
      ),
    );
  }



  Row signUpOption(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Dont have account?",
        style:TextStyle(color:Colors.white70)),
        GestureDetector(
          onTap: () {
            Navigator.push(context,
               MaterialPageRoute(builder: (context) => SignUpScreen()));  
          },
          child: const Text(
            "Sign Up",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }



  
}

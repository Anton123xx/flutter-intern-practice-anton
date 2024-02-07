import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuth_Controller
{

static final FirebaseAuth instance = FirebaseAuth.instance;

///??????????
void signIn(String email, String password)
{
    instance
   .signInWithEmailAndPassword(email: email, password: password)
   .then((value) => true)
   .onError((error, stackTrace) => false);
}
   

////?????????
void signOut()
{

}







} 

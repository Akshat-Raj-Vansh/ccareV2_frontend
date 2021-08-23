//@dart=2.9
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class PhoneSignInSection extends StatefulWidget {
  // _PhoneSignInSection(this._scaffold);

  // final ScaffoldState _scaffold;

  @override
  State<StatefulWidget> createState() => PhoneSignInSectionState();
}

class PhoneSignInSectionState extends State<PhoneSignInSection> {
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _smsController = TextEditingController();

  String _message = '';
  String _verificationId;
  ConfirmationResult webConfirmationResult;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              child: const Text(
                'Test sign in with phone number',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            TextFormField(
              controller: _phoneNumberController,
              decoration: const InputDecoration(
                labelText: 'Phone number (+x xxx-xxx-xxxx)',
              ),
              // validator: (String value) {
              //   if (value.isEmpty) {
              //     return 'Phone number (+x xxx-xxx-xxxx)';
              //   }
              //   return null;
              // },
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              alignment: Alignment.center,
              child: RaisedButton(
                //  icon: Icons.contact_phone,
                //  backgroundColor: Colors.deepOrangeAccent[700],
                child: Text('Verify Number'),
                onPressed: _verifyPhoneNumber,
              ),
            ),
            TextField(
              controller: _smsController,
              decoration: const InputDecoration(labelText: 'Verification code'),
            ),
            Container(
              padding: const EdgeInsets.only(top: 16),
              alignment: Alignment.center,
              child: RaisedButton(
                //  icon: Icons.phone,
                //   backgroundColor: Colors.deepOrangeAccent[400],
                onPressed: _signInWithPhoneNumber,
                child: Text('Sign In'),
              ),
            ),
            Visibility(
              visible: _message != null,
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  _message,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  // Example code of how to verify phone number
  Future<void> _verifyPhoneNumber() async {
    setState(() {
      _message = '';
    });

    PhoneVerificationCompleted verificationCompleted =
        (PhoneAuthCredential phoneAuthCredential) async {
      await _auth.signInWithCredential(phoneAuthCredential);
      // widget._scaffold.showSnackBar(SnackBar(
      //   content: Text(
      //       'Phone number automatically verified and user signed in: $phoneAuthCredential'),
      // ));
      print('1');
    };

    PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException authException) {
      setState(() {
        _message =
            'Phone number verification failed. Code: ${authException.code}. Message: ${authException.message}';
      });
    };

    PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) async {
      // widget._scaffold.showSnackBar(const SnackBar(
      //   content: Text('Please check your phone for the verification code.'),
      // ));
      print('2');
      _verificationId = verificationId;
    };

    PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      _verificationId = verificationId;
    };

    try {
      await _auth.verifyPhoneNumber(
          phoneNumber: _phoneNumberController.text,
          timeout: const Duration(seconds: 5),
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: codeSent,
          codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
    } catch (e) {
      // widget._scaffold.showSnackBar(SnackBar(
      //   content: Text('Failed to Verify Phone Number: $e'),
      // ));
      print('3');
      print(e);
    }
  }

  // Example code of how to sign in with phone.
  Future<void> _signInWithPhoneNumber() async {
    try {
      final PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: _smsController.text,
      );
      final User user = (await _auth.signInWithCredential(credential)).user;

      // widget._scaffold.showSnackBar(SnackBar(
      //   content: Text('Successfully signed in UID: ${user.uid}'),
      // ));
      print('4');
    } catch (e) {
      print(e);
      // widget._scaffold.showSnackBar(
      //   const SnackBar(
      //     content: Text('Failed to sign in'),
      //   ),
      // );
      print('5');
    }
  }
}

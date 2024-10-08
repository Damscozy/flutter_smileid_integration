import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:smile_id/smile_id.dart';
import 'package:smile_id/smile_id_biometric_kyc.dart';
import 'package:smile_id/smile_id_document_verification.dart';
import 'package:smile_id/smile_id_enhanced_document_verification.dart';
import 'package:smile_id/smile_id_smart_selfie_authentication.dart';
import 'package:smile_id/smile_id_smart_selfie_enrollment.dart';
import 'package:smile_id/smileid_messages.g.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SmileHome());
}

class SmileHome extends StatefulWidget {
  const SmileHome({super.key});

  @override
  State<SmileHome> createState() => _SmileHomeState();
}

class _SmileHomeState extends State<SmileHome> {
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    // If the widget was removed from the tree while the asynchronous platform
    // message was in fliNGt, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
    SmileID.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Smile ID",
      // MainContent requires its own BuildContext for Navigator to work, hence it is defined as its
      // own widget
      home: MainContent(),
    );
  }
}

class MyScaffold extends StatelessWidget {
  final Widget body;

  const MyScaffold({
    super.key,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leading: const BackButton(),
        title: const Text("Smile ID"),
      ),
      body: body,
    );
  }
}

class MainContent extends StatelessWidget {
  const MainContent({super.key});

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      body: Center(
        child: Column(
          children: [
            enhancedKycAsyncButton(),
            documentVerificationButton(context),
            enhancedDocumentVerificationButton(context),
            smartSelfieEnrollmentButton(context),
            smartSelfieAuthenticationButton(context),
            biometricKycButton(context)
          ],
        ),
      ),
    );
  }

  Widget enhancedKycAsyncButton() {
    return ElevatedButton(
      child: const Text("Enhanced KYC (Async)"),
      onPressed: () {
        SmileID.initialize();
        var userId = "<your user's user ID>";
        SmileID.api
            .authenticate(
              FlutterAuthenticationRequest(
                jobType: FlutterJobType.enhancedKyc,
                userId: userId,
              ),
            )
            .then(
              (authResponse) => {
                SmileID.api.doEnhancedKycAsync(
                  FlutterEnhancedKycRequest(
                    country: "NG",
                    idType: "DRIVERS_LICENSE",
                    idNumber: "B0000000",
                    callbackUrl: "https://somedummyurl.com/demo",
                    partnerParams: FlutterPartnerParams(
                      jobType: FlutterJobType.biometricKyc,
                      jobId: userId,
                      userId: userId,
                    ),
                    timestamp: authResponse!.timestamp,
                    signature: authResponse.signature,
                  ),
                )
              },
              onError: (error) => {
                log("error: $error"),
              },
            );
      },
    );
  }

  Widget documentVerificationButton(BuildContext context) {
    return ElevatedButton(
      child: const Text("Document Verification"),
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (BuildContext context) => MyScaffold(
              body: SmileIDDocumentVerification(
                countryCode: "NG",
                documentType: "DRIVERS_LICENSE",
                onSuccess: (String? result) {
                  // Your success handling logic
                  final snackBar = SnackBar(
                    content: Text("Success: $result"),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  Navigator.of(context).pop();
                },
                onError: (String errorMessage) {
                  // Your error handling logic
                  final snackBar = SnackBar(
                    content: Text("Error: $errorMessage"),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  Navigator.of(context).pop();
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget enhancedDocumentVerificationButton(BuildContext context) {
    return ElevatedButton(
      child: const Text("Enhanced Document Verification"),
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (BuildContext context) => MyScaffold(
              body: SmileIDEnhancedDocumentVerification(
                countryCode: "NG",
                documentType: "DRIVERS_LICENSE",
                onSuccess: (String? result) {
                  // Your success handling logic
                  final snackBar = SnackBar(
                    content: Text("Success: $result"),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  Navigator.of(context).pop();
                },
                onError: (String errorMessage) {
                  // Your error handling logic
                  final snackBar = SnackBar(
                    content: Text("Error: $errorMessage"),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  Navigator.of(context).pop();
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget smartSelfieEnrollmentButton(BuildContext context) {
    return ElevatedButton(
      child: const Text("SmartSelfie Enrollment"),
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (BuildContext context) => MyScaffold(
              body: SmileIDSmartSelfieEnrollment(
                onSuccess: (String? result) {
                  // Your success handling logic
                  final snackBar = SnackBar(
                    content: Text("Success: $result"),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  Navigator.of(context).pop();
                },
                onError: (String errorMessage) {
                  // Your error handling logic
                  final snackBar = SnackBar(
                    content: Text("Error: $errorMessage"),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  Navigator.of(context).pop();
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget smartSelfieAuthenticationButton(BuildContext context) {
    return ElevatedButton(
      child: const Text("SmartSelfie Authentication"),
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (BuildContext context) => MyScaffold(
              body: SmileIDSmartSelfieAuthentication(
                onSuccess: (String? result) {
                  // Your success handling logic
                  final snackBar = SnackBar(
                    content: Text("Success: $result"),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  Navigator.of(context).pop();
                },
                onError: (String errorMessage) {
                  // Your error handling logic
                  final snackBar = SnackBar(
                    content: Text("Error: $errorMessage"),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  Navigator.of(context).pop();
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget biometricKycButton(BuildContext context) {
    return ElevatedButton(
      child: const Text("Biometric KYC"),
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (BuildContext context) => MyScaffold(
              body: SmileIDBiometricKYC(
                country: "NG",
                idType: "NATIONAL_ID",
                idNumber: "12345678",
                onSuccess: (String? result) {
                  // Your success handling logic
                  final snackBar = SnackBar(
                    content: Text("Success: $result"),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  Navigator.of(context).pop();
                },
                onError: (String errorMessage) {
                  // Your error handling logic
                  final snackBar = SnackBar(
                    content: Text("Error: $errorMessage"),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  Navigator.of(context).pop();
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

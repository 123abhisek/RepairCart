import 'package:flutter/material.dart';
import 'package:service_stack/screens/BottomNavPage.dart';
import 'package:service_stack/screens/user/DashboardScreen.dart';
import 'package:service_stack/screens/user/PaymentProcessingScreen.dart';

class PaymentScreen extends StatelessWidget {
  final String qrPath = 'assets/qr_code.png';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Payment'), backgroundColor: Colors.deepPurple),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Scan to Pay", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.deepPurple, width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Image.asset(qrPath, height: 250),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {



                  Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentProcessingScreen(),));
                },
                child: Text("Confirm Payment"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  minimumSize: Size.fromHeight(50),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

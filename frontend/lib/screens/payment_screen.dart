import 'dart:async';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:http/http.dart' as http;

class PaymentScreen extends StatefulWidget {
  final String bookingReference;
  final int seats;

  const PaymentScreen({
    Key? key,
    required this.bookingReference,
    required this.seats,
  }) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late Timer _timer;
  bool _isVerified = false;

  @override
  void initState() {
    super.initState();
    _startPolling();
  }

  void _startPolling() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      final response = await http.get(
        Uri.parse(
          'http://192.168.43.247:8080/api/bookings/verify/${widget.bookingReference}',
        ),
      );

      if (response.statusCode == 200) {
        final result = response.body.trim().toLowerCase();
        if (result == 'true') {
          timer.cancel();
          setState(() {
            _isVerified = true;
          });

          // Optional delay to show success before popping
          Future.delayed(const Duration(seconds: 2), () {
            Navigator.pop(context, 'paymentSuccess');
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payment Verification')),
      body: Center(
        child:
            _isVerified
                ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.check_circle, color: Colors.green, size: 100),
                    SizedBox(height: 16),
                    Text(
                      "Payment Verified! Booking Confirmed.",
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                )
                : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Scan this QR code to complete payment'),
                    const SizedBox(height: 16),
                    QrImageView(
                      data:
                          'http://192.168.43.247:8080/confirm_payment.html?ref=${widget.bookingReference}',
                      version: QrVersions.auto,
                      size: 200.0,
                    ),
                    const SizedBox(height: 16),
                    const CircularProgressIndicator(),
                    const SizedBox(height: 8),
                    const Text('Waiting for payment confirmation...'),
                  ],
                ),
      ),
    );
  }
}

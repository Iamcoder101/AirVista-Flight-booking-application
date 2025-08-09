import 'package:flutter/material.dart';

class TicketScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Your Ticket')),
      body: Center(child: Text('Ticket Confirmation Details')),
    );
  }
}

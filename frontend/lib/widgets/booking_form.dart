import 'package:flutter/material.dart';
import 'package:flutterapp/screens/payment_screen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutterapp/screens/payment_screen.dart'; // Adjust path as needed

class BookingFormScreen extends StatefulWidget {
  final Map<String, dynamic> flight;

  const BookingFormScreen({super.key, required this.flight});

  @override
  State<BookingFormScreen> createState() => _BookingFormScreenState();
}

class _BookingFormScreenState extends State<BookingFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  Future<void> _submitBooking() async {
    if (_formKey.currentState!.validate()) {
      final bookingData = {
        'flightId': widget.flight['flightNumber'],
        'origin': widget.flight['origin'],
        'destination': widget.flight['destination'],
        'departureDate': widget.flight['departureTime'].substring(0, 10),
        'passengerName': _nameController.text,
        'email': _emailController.text,
        'seats': widget.flight['_adults'] ?? 1,
      };

      try {
        final response = await http.post(
          Uri.parse('http://localhost:8080/api/bookings/book'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(bookingData),
        );

        if (response.statusCode == 200) {
          final result = jsonDecode(response.body);
          final bookingReference = result['bookingReference'] ?? 'UNKNOWN_REF';

          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => PaymentScreen(
                    bookingReference: bookingReference,
                    seats: widget.flight['_adults'] ?? 1,
                  ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Booking failed: ${response.statusCode}')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error submitting booking: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final flight = widget.flight;

    return Scaffold(
      appBar: AppBar(title: const Text('Booking Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text(
                'Flight Number: ${flight['flightNumber']}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('From: ${flight['origin']}'),
              Text('To: ${flight['destination']}'),
              Text('Departure: ${flight['departureTime']}'),
              Text('Arrival: ${flight['arrivalTime']}'),
              Text('Price: ₹${flight['price']}'),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Passenger Name',
                  border: OutlineInputBorder(),
                ),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Enter your name'
                            : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                validator:
                    (value) =>
                        value == null || !value.contains('@')
                            ? 'Enter a valid email'
                            : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitBooking,
                child: const Text('Confirm Booking'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';

import '../models/flight.dart';
import 'package:flutterapp/screens/booking_screen.dart'; // Ensure this screen exists
import '../widgets/flight_card.dart';

class SearchResultsScreen extends StatefulWidget {
  final String origin;
  final String destination;
  final String date;
  final int adults;

  const SearchResultsScreen({
    Key? key,
    required this.origin,
    required this.destination,
    required this.date,
    required this.adults,
  }) : super(key: key);

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  List<Flight> flights = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchFlights();
  }

  Future<void> fetchFlights() async {
    final url =
        'http://localhost:8080/api/flights/search?origin=${Uri.encodeComponent(widget.origin)}&destination=${Uri.encodeComponent(widget.destination)}&date=${widget.date}&adults=${widget.adults}';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        setState(() {
          flights = data.map((json) => Flight.fromJson(json)).toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load flights');
      }
    } catch (e) {
      print('Error fetching flights: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flight Options')),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : flights.isEmpty
              ? const Center(child: Text('No flights found'))
              : ListView.builder(
                itemCount: flights.length,
                itemBuilder: (context, index) {
                  final flight = flights[index];
                  return Card(
                    margin: const EdgeInsets.all(8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Flight Number: ${flight.flightNumber}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Departure: ${DateFormat('yyyy-MM-dd HH:mm').format(DateTime.parse(flight.departureTime))}',
                          ),
                          Text(
                            'Arrival: ${DateFormat('yyyy-MM-dd HH:mm').format(DateTime.parse(flight.arrivalTime))}',
                          ),
                          Text('Duration: ${flight.duration}'),
                          Text(
                            'Price: ₹${flight.price.toStringAsFixed(2)}',
                            style: const TextStyle(color: Colors.green),
                          ),
                          const SizedBox(height: 16.0),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) => BookingFormScreen(
                                        flight: flight,
                                        adults: widget.adults,
                                      ),
                                ),
                              );
                            },
                            child: const Text('Book Flight'),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
    );
  }
}

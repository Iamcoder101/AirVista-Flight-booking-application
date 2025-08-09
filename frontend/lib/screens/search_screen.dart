import 'package:flutter/material.dart';
import '../widgets/search_form.dart';
import 'tourism_screen.dart'; // You'll create this

class SearchScreenn extends StatelessWidget {
  const SearchScreenn({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AirVista'),
        actions: [
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              icon: const Icon(
                Icons.menu,
                color: Color.fromARGB(255, 241, 237, 237),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'tourism',
                  child: Text('Tourism Guide'),
                ),
                DropdownMenuItem(value: 'Chatbot', child: Text('Chat-Bot')),
              ],
              onChanged: (value) {
                if (value == 'tourism') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TourismScreen(),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
      body: const Padding(padding: EdgeInsets.all(16.0), child: SearchForm()),
    );
  }
}

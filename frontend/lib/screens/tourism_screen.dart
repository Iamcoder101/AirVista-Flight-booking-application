import 'package:flutter/material.dart';
import 'package:flutterapp/services/tourism_service.dart';
import 'package:flutterapp/models/place.dart';
import 'package:flutterapp/widgets/place_card.dart';
import 'package:flutterapp/screens/chatbot_screen.dart';
import 'package:flutterapp/screens/search_screen.dart';

class TourismScreen extends StatefulWidget {
  const TourismScreen({Key? key}) : super(key: key);

  @override
  _TourismScreenState createState() => _TourismScreenState();
}

class _TourismScreenState extends State<TourismScreen> {
  final TextEditingController _locationController = TextEditingController();
  final TourismService _tourismService = TourismService();
  bool _loading = false;
  List<Place> _places = [];

  void _searchTouristPlaces() async {
    final location = _locationController.text.trim();
    if (location.isEmpty) return;

    setState(() {
      _loading = true;
    });

    try {
      List<Place> places = await _tourismService.fetchTouristPlaces(location);
      setState(() {
        _places = places;
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tourism Guide'),
        actions: [
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              icon: const Icon(
                Icons.menu,
                color: Color.fromARGB(255, 241, 237, 237),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'flights',
                  child: Text('Flight Booking'),
                ),

                DropdownMenuItem(value: 'Chatbot', child: Text('Chat-Bot')),
              ],
              onChanged: (value) {
                if (value == 'flights') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SearchScreenn(),
                    ),
                  );
                }
                if (value == 'ChatBot') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ChatbotScreen(),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _locationController,
              decoration: InputDecoration(
                labelText: 'Enter location',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _searchTouristPlaces,
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            _loading
                ? const CircularProgressIndicator()
                : Expanded(
                  child:
                      _places.isEmpty
                          ? const Center(child: Text('No places found.'))
                          : ListView.builder(
                            itemCount: _places.length,
                            itemBuilder: (context, index) {
                              final place = _places[index];
                              return Card(
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                child: ListTile(
                                  leading:
                                      place.image.isNotEmpty
                                          ? Image.network(
                                            place.image,
                                            width: 60,
                                            height: 60,
                                            fit: BoxFit.cover,
                                            errorBuilder: (
                                              context,
                                              error,
                                              stackTrace,
                                            ) {
                                              return const Icon(Icons.photo);
                                            },
                                          )
                                          : const Icon(Icons.photo),
                                  title: Text(place.name),
                                  subtitle: Text(
                                    place.description.isNotEmpty
                                        ? place.description
                                        : 'No description available',
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              );
                            },
                          ),
                ),
          ],
        ),
      ),
    );
  }
}

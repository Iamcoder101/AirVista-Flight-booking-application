import 'package:flutter/material.dart';
import 'package:flutterapp/models/place.dart';

class PlaceCard extends StatelessWidget {
  final Place place;

  const PlaceCard({Key? key, required this.place}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      child: Column(
        children: [
          ListTile(title: Text(place.name), subtitle: Text(place.description)),
        ],
      ),
    );
  }
}

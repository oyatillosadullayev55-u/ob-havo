import 'package:flutter/material.dart';

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(8, 10, 8, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('City/Country',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18)),
              Icon(Icons.menu, color: Colors.white, size: 28),
            ],
          ),
          SizedBox(height: 8),
          Text('Wed, May 26, 15:00',
              style: TextStyle(color: Colors.white, fontSize: 11)),
        ],
      ),
    );
  }
}
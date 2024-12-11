import 'package:flutter/material.dart';

class ImageSection extends StatelessWidget {
  const ImageSection(
      {super.key,
      required this.image,
      required this.width,
      required this.height});

  final String image;
  final int width;
  final int height;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
      width: 200,
      height: 200,
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.fromLTRB(0, 150, 0, 50),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
      child: Image.asset(
        image,
        fit: BoxFit.cover,
      ),
    ));
  }
}

class TextSection extends StatelessWidget {
  const TextSection(
      {super.key,
      required this.title,
      required this.description,
      required this.textalignment});

  final String title;
  final String description;
  final String textalignment;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(35),
      child: Row(
        children: [
          Expanded(
            /*1*/
            child: Column(
              crossAxisAlignment: textalignment == 'left'
                  ? CrossAxisAlignment.start
                  : textalignment == 'center'
                      ? CrossAxisAlignment.center
                      : CrossAxisAlignment.end,
              children: [
                /*2*/
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    title,
                    // textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(color: Colors.grey[800], fontSize: 14),
                ),
              ],
            ),
          ),
          /*3*/
        ],
      ),
    );
  }
}

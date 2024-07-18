import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flip_card/flip_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WordsCard extends StatefulWidget {
  final String title;
  const WordsCard({super.key, required this.title});

  @override
  State<WordsCard> createState() => _WordsCardState();
}

class _WordsCardState extends State<WordsCard> {
  List<Map<String, String>> words = [];
  int _current = 0;

  @override
  void initState() {
    super.initState();
    fetchWords();
  }

  Future<void> fetchWords() async {
    CollectionReference collection = FirebaseFirestore.instance.collection('terminology');
    DocumentSnapshot snapshot = await collection.doc(widget.title).get();
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

    List<Map<String, String>> fetchedWords = [];
    data['word'].forEach((key, value) {
      fetchedWords.add({'term': key, 'definition': value['meaning'], 'example': value['example']});
    });

    setState(() {
      words = fetchedWords;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        automaticallyImplyLeading: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: words.isEmpty
                ? Center(child: CircularProgressIndicator())
                : CarouselSlider.builder(
              itemCount: words.length,
              itemBuilder: (context, index, realIndex) {
                return _buildCard(context, words[index]['term']!, words[index]['definition']!, words[index]['example']!);
              },
              options: CarouselOptions(
                height: 400,
                enlargeCenterPage: true,
                autoPlay: false,
                aspectRatio: 2.0,
                enableInfiniteScroll: true,
                viewportFraction: 0.8,
                onPageChanged: (index, reason) {
                  setState(() {
                    _current = index;
                  });
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Text(
              "${_current + 1} / ${words.length}",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context, String term, String definition, String example) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 1.0),
      child: FlipCard(
        direction: FlipDirection.HORIZONTAL,
        front: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              term,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        back: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                definition,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                "예시: $example",
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.white70,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

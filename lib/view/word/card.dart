import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flip_card/flip_card.dart';

class WordsCard extends StatefulWidget {
  final String title;
  const WordsCard({super.key, required this.title});

  @override
  State<WordsCard> createState() => _WordsCardState();
}

class _WordsCardState extends State<WordsCard> {
  final List<Map<String, String>> words = [
    {'term': '자산 (Assets)', 'definition': '기업이 소유하고 있는 경제적 가치가 있는 모든 자원.'},
    {'term': '부채 (Liabilities)', 'definition': '기업이 갚아야 할 의무나 빚.'},
    {'term': '자본 (Equity)', 'definition': '자산에서 부채를 뺀 후 소유주에게 남는 가치.'},
    {'term': '수익 (Revenue)', 'definition': '기업이 제공한 상품이나 서비스로 인해 발생한 총 매출.'},
    {'term': '비용 (Expenses)', 'definition': '수익을 창출하기 위해 발생한 모든 비용.'},
    {'term': '이익 (Profit)', 'definition': '수익에서 비용을 뺀 순수한 금액.'},
    {'term': 'PER (Price to Earnings Ratio)', 'definition': '주가를 주당순이익(EPS)으로 나눈 값으로, 기업의 수익력 대비 주가 수준을 나타냄.'},
    {'term': 'ROE (Return on Equity)', 'definition': '자기자본이익률로, 기업이 자본을 얼마나 효율적으로 사용했는지를 나타냄.'},
    {'term': 'PBR (Price to Book Ratio)', 'definition': '주가를 주당순자산가치(BPS)로 나눈 값으로, 주가가 자산가치 대비 얼마나 높은지를 나타냄.'},
    {'term': 'BPS (Book Value per Share)', 'definition': '기업의 순자산을 발행 주식 수로 나눈 값으로, 주당 자산가치를 나타냄.'},
  ];

  int _current = 0;

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
            child: CarouselSlider.builder(
              itemCount: words.length,
              itemBuilder: (context, index, realIndex) {
                return _buildCard(context, words[index]['term']!, words[index]['definition']!, index == _current);
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

  Widget _buildCard(BuildContext context, String term, String definition, bool isCurrent) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
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
          child: Center(
            child: Text(
              definition,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}

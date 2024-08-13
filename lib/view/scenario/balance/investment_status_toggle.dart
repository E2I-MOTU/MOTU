import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InvestmentStatusToggle extends StatefulWidget {
  const InvestmentStatusToggle({super.key});

  @override
  InvestmentStatusToggleState createState() => InvestmentStatusToggleState();
}

class InvestmentStatusToggleState extends State<InvestmentStatusToggle> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            "투자 현황",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 0),
          child: GestureDetector(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: _isExpanded
                    ? const BorderRadius.vertical(top: Radius.circular(20))
                    : BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    children: [
                      Text(
                        '3,285,000',
                        style: TextStyle(fontSize: 20),
                      ),
                      Text(
                        '+ 285,000 (+9.5%)',
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(width: 10),
                  AnimatedRotation(
                    turns: _isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 300),
                    child: IconButton(
                      icon: const Icon(CupertinoIcons.chevron_down),
                      color: Colors.white,
                      onPressed: () {
                        setState(() {
                          _isExpanded = !_isExpanded;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: AnimatedSize(
            duration: const Duration(milliseconds: 300),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.grey,
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(20)),
              ),
              height: _isExpanded ? null : 0,
              width: double.infinity,
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow('총 손익', '+285,000 (+9.5%)', Colors.red),
                    const SizedBox(height: 8),
                    _buildInfoRow('총 매입', '3,000,000', Colors.black),
                    const SizedBox(height: 8),
                    _buildInfoRow('총 평가', '3,285,000', Colors.black),
                    const SizedBox(height: 8),
                    _buildInfoRow('실현 손익', '0', Colors.black),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value, Color valueColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}

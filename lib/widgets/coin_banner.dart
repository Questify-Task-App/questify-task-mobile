import 'package:flutter/material.dart';

class CoinBanner extends StatefulWidget {
  final int coins;

  const CoinBanner({
    super.key,
    required this.coins,
  });

  @override
  State<CoinBanner> createState() => _CoinBannerState();
}

class _CoinBannerState extends State<CoinBanner> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.red,
      color: Colors.blueAccent,
      width: double.infinity,
      padding: EdgeInsets.all(30),
      child: Column(
        spacing: 8,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 8,
            children: [
              Text(
                widget.coins.toString(),
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Image.asset("assets/img/coins.png", width: 50),
              Text(
                "Coins",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

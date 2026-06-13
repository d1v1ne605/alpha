import 'package:alpha/presentation/pages/asset_fee/coin_list_screen.dart';
import 'package:flutter/material.dart';

class CryptoScreen extends StatelessWidget {
  const CryptoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CoinListScreen(onInit: (vm) async => vm.loadCryptoCoins());
  }
}

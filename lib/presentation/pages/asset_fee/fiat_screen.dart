import 'package:alpha/presentation/pages/asset_fee/coin_list_screen.dart';
import 'package:flutter/material.dart';

class FiatScreen extends StatelessWidget {
  const FiatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CoinListScreen(onInit: (vm) async => vm.loadFiatCoins());
  }
}

import 'package:alpha/core/widgets/custom_navbottom_bar.dart';
import 'package:alpha/presentation/pages/main/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Setting extends StatelessWidget {
  const Setting({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings'), centerTitle: true),

      body: GestureDetector(
        onTap: () {
          context.push('/home');
        },
        child: Center(child: Text('Settings Screen')),
      ),
    );
  }
}

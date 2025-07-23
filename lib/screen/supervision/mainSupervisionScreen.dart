
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rondines/provider/supervisionProvider.dart';

class mainSupervisionScreen extends StatelessWidget {
  const mainSupervisionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(create: (_)=>supervisionProvider(),child: _mainSupervision(),);
  }
}

class _mainSupervision extends StatelessWidget {
  const _mainSupervision({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}


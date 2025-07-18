import 'package:flutter/material.dart';
import 'package:mall_blackstone/mall_screem.dart';
import 'package:mall_blackstone/provider/shop_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => ShopProvider())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Blackstone",
        home: MallScreen(),
      ),
    );
  }
}

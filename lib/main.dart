import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/providers/pos_provider.dart';
import 'features/home/screens/home_screen.dart';

void main() {
  runApp(const RestaurantPOSApp());
}

class RestaurantPOSApp extends StatelessWidget {
  const RestaurantPOSApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => POSProvider()),
      ],
      child: MaterialApp(
        title: 'ZestBite Enterprise',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const HomeScreen(),
      ),
    );
  }
}

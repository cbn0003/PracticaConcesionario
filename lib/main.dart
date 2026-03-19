import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'providers/product_provider.dart';
import 'app.dart';

void main() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ProductProvider()),
        ],
        child: const InventarioApp() ,
      ),
    );
}




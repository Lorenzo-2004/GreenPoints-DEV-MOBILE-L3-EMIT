import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'app.dart';
import 'data/services/init_service.dart';
import 'presentation/providers/theme_provider.dart';
import 'presentation/providers/locale_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // On n'attend pas la fin de l'initialisation pour lancer l'app
  // Sinon, s'il n'y a pas de réseau ou si Firebase bloque, l'app reste sur un écran blanc !
  final initService = InitService();
  initService.initAllData().catchError((e) {
    debugPrint("Erreur lors de l'initialisation des données par défaut: \$e");
  });
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
      ],
      child: const GreenPointsApp(),
    ),
  );
}
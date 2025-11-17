import 'package:flutter/material.dart';
import 'pages/home_page.dart';

/// Entrada da aplicação.
///
/// Configura o tema básico e define a `HomePage` como tela inicial.
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokedex Flutter',
      // Tema global: usa tons de vermelho para combinar com a identidade
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: HomePage(),
    );
  }
}

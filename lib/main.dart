import 'package:flutter/material.dart';
import 'package:pmsbmibile3/pages/produto/product_visual.dart';
import 'package:provider/provider.dart';
import 'package:pmsbmibile3/state/user_repository.dart';
import 'package:pmsbmibile3/pages/pages.dart';
import 'package:pmsbmibile3/state/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      builder: (_) => UserRepository.instance(),
      child: Provider<DatabaseService>.value(
        value: DatabaseService(),
        child: MaterialApp(
          title: 'PMSB',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          initialRoute: "/",
          routes: {
            "/": (context) => HomePage(),
            "/noticias/noticias_visualizadas": (context) =>
                NoticiasVisualizadasPage(),
            "/perfil": (context) => PerfilPage(),
            "/perfil/editar_variavel": (context) => PerfilEditarVariavelPage(),
            "/comunicacao": (context) => CommunicationPage(),
            "/comunicacao/criar_editar": (context) => CommunicationCreateEdit(),
            "/produto": (context) => ProductPage(),
            "/produto/adicionar_editar": (context) => AddEditProduct(),
            "/produto/lista": (context) => ProductList(),
            "/produto/visual": (context) => ProductVisual(),
            "/produto/editar_visual": (context) => EditVisual(),
          },
        ),
      ),
    );
  }
}

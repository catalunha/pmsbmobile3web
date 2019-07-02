import 'package:flutter/material.dart';
import 'package:pmsbmibile3/pages/produto/product_visual.dart';
import 'package:provider/provider.dart';
import 'package:pmsbmibile3/state/user_repository.dart';
import 'package:pmsbmibile3/pages/pages.dart';
import 'package:pmsbmibile3/state/services.dart';
import 'package:pmsbmibile3/state/auth_bloc.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider.value(
      value: AuthBloc(),
      child: ChangeNotifierProvider(
        builder: (_) => UserRepository.instance(),
        child: Provider<DatabaseService>.value(
          value: DatabaseService(),
          child: MaterialApp(
            title: 'PMSB',
            //theme: ThemeData.dark(),
            initialRoute: "/",
            routes: {
              "/": (context) => HomePage(),

              //perfil
              "/perfil": (context) => PerfilPage(),
              "/perfil/editar_variavel": (context) => PerfilEditarVariavelPage(),
              "/perfil/configuracao":(context)=> ConfiguracaoPage(),
              //questionario
              "/questionario/home":(context) => QuestionarioHomePage(),
              "/questionario/adicionar_editar": (context) => AdicionarEditarQuestionarioPage(),
              
              "/pergunta/home":(context) => PerguntaHomePage(),
              "/aplicacao/home":(context) => AplicacaoHomePage(),
              "/resposta/home":(context) => RespostaHomePage(),
              "/sintese/home":(context) => SinteseHomePage(),

              //produto
              "/produto": (context) => ProductPage(),
              "/produto/adicionar_editar": (context) => AddEditProduct(),
              "/produto/lista": (context) => ProductList(),
              "/produto/visual": (context) => ProductVisual(),
              "/produto/editar_visual": (context) => EditVisual(),

              //comunicacao
              "/comunicacao": (context) => CommunicationPage(),
              "/noticias/noticias_visualizadas": (context) =>
                  NoticiasVisualizadasPage(),
              "/comunicacao/criar_editar": (context) => CommunicationCreateEdit(),

              //administração
              "/administracao/home":(context) => AdministracaoHomePage(),
              "/administracao/perfil":(context) => AdministracaoPerfilPage(),
            },
          ),
        ),
      ),
    );
  }
}

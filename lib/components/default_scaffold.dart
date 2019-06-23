import 'package:flutter/material.dart';
import 'package:pmsbmibile3/pages/geral/loading.dart';
import 'package:pmsbmibile3/models/usuarios_model.dart';
import 'package:pmsbmibile3/state/services.dart';
import 'package:pmsbmibile3/state/user_repository.dart';
import 'package:provider/provider.dart';

var db = DatabaseService();

class DefaultDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Consumer(
              builder: (context, UsuarioModel usuario, _) => DrawerHeader(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                              color: Theme.of(context).textTheme.title.color),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Icon(
                            Icons.people,
                            size: 75,
                          ),
                          Text("${usuario.telefoneCelular}"),
                        ],
                      ),
                    ),
                  ),
            ),
            ListTile(
              title: Text('Questionarios'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/questionario/home');
              },
            ),
            ListTile(
              title: Text('Perguntas'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/pergunta/home');
              },
            ),
            ListTile(
              title: Text('Aplicação'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/aplicacao/home');
              },
            ),
            ListTile(
              title: Text('Respostas'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/resposta/home');
              },
            ),
            ListTile(
              title: Text('Síntese'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/sintese/home');
              },
            ),
            ListTile(
              title: Text('Produto'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/produto');
              },
            ),
            ListTile(
              title: Text('Comunicação'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/comunicacao');
              },
            ),

            ListTile(
              title: Text('Administração'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/administracao/home');
              },
            ),
          ],
        ),
      ),
    );
  }
}

class DefaultEndDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    UserRepository userRepository = Provider.of<UserRepository>(context);

    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            ListTile(
              title: Text('Perfil'),
              onTap: () {
                //noticias perfil
                Navigator.pop(context);
                Navigator.pushNamed(context, "/perfil");
              },
            ),
            ListTile(
              title: Text('Noticias Arquivadas'),
              onTap: () {
                //noticias arquivadas
                Navigator.pop(context);
                Navigator.pushNamed(context, "/noticias/noticias_visualizadas");
              },
            ),
            ListTile(
              title: Text('Configurações'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, "/perfil/configuracao");
              },
            ),
            ListTile(
              title: Text('Sair'),
              onTap: () {
                userRepository.signOut();
                Navigator.pushNamedAndRemoveUntil(
                    context, "/", (Route<dynamic> route) => false);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class MoreAppAction extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Icon(Icons.more_vert),
      onTap: () {
        Scaffold.of(context).openEndDrawer();
      },
    );
  }
}

class DefaultScaffold extends StatelessWidget {
  final Widget body;
  final Widget floatingActionButton;
  final Widget title;
  final Widget actions;

  const DefaultScaffold(
      {Key key, this.body, this.floatingActionButton, this.title, this.actions})
      : super(key: key);

  Widget _appBarBuild() {
    return AppBar(
      actions: <Widget>[
        MoreAppAction(),
      ],
      //leading: Text("leading"),
      centerTitle: true,
      title: title,
    );
  }

  @override
  Widget build(BuildContext context) {
    UserRepository userRepository = Provider.of<UserRepository>(context);
    if (userRepository.user != null) {
      return StreamProvider<UsuarioModel>.value(
        initialData: UsuarioModel(firstName: "..", lastName: ".."),
        stream: db.streamUsuario(userRepository.user.uid),
        child: Scaffold(
          drawer: DefaultDrawer(),
          endDrawer: DefaultEndDrawer(),
          appBar: _appBarBuild(),
          floatingActionButton: floatingActionButton,
          body: body,
        ),
      );
    } else {
      return LoadingPage();
    }
  }
}
import 'package:flutter/material.dart';
import 'package:pmsbmibile3/components/default_scaffold.dart';
import 'package:pmsbmibile3/models/questionario_model.dart';
import 'package:pmsbmibile3/pages/aplicacao/aplicacao_home_page_bloc.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/pages/page_arguments.dart';
import 'package:pmsbmibile3/state/auth_bloc.dart';

class AplicacaoHomePage extends StatefulWidget {
  final AuthBloc authBloc;

  const AplicacaoHomePage(this.authBloc, {Key key}) : super(key: key);

  @override
  _AplicacaoHomePageState createState() {
    return _AplicacaoHomePageState(authBloc);
  }
}

class _AplicacaoHomePageState extends State<AplicacaoHomePage> {
  final String _eixo = "eixo exemplo";
  final String _setor = "setor exemplo";
  final AplicacaoHomePageBloc bloc =
      AplicacaoHomePageBloc(Bootstrap.instance.firestore);
  final AuthBloc authBloc;

  _AplicacaoHomePageState(this.authBloc);

  @override
  void initState() {
    super.initState();
    authBloc.perfil.listen((usuario) {
      bloc.dispatch(UpdateUserIDAplicacaoHomePageBlocEvent(usuario.id, usuario.eixoIDAtual.id));
    });
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  _listaQuestionarioAplicado() {
    return StreamBuilder<AplicacaoHomePageBlocState>(
      stream: bloc.state,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("ERROR");
        }
        if (!snapshot.hasData) {
          return Text("SEM DADOS");
        }
        final questionarios = snapshot.data.questionariosAplicados != null
            ? snapshot.data.questionariosAplicados
            : [];
        return ListView(
          children:
              questionarios.map((q) => QuestionarioAplicadoItem(q)).toList(),
        );
      },
    );
  }

  _bodyTodos() {
    return Column(
      children: <Widget>[
        //TODO: preambulo
//        Padding(
//          padding: EdgeInsets.only(top: 10),
//          child: Text(
//            "Eixo : $_eixo",
//            style: TextStyle(fontSize: 16, color: Colors.blue),
//          ),
//        ),
//        Padding(
//          padding: EdgeInsets.only(top: 10),
//          child: Text(
//            "Setor censitário: $_setor",
//            style: TextStyle(fontSize: 16, color: Colors.blue),
//          ),
//        ),
        Expanded(child: _listaQuestionarioAplicado())
      ],
    );
  }

  _bodyArvore() {
    return Container(
      child: Center(
        child: Text(
          "Em construção",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: DefaultScaffold(
        bottom: TabBar(
          tabs: [
            Tab(text: "Todos"),
            Tab(text: "Arvore"),
          ],
        ),
        title: Text('Aplicando questionario'),
        body: TabBarView(
          children: [
            _bodyTodos(),
            _bodyArvore(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            // Adicionar novo questionario aplicado
            Navigator.pushNamed(context, "/aplicacao/momento_aplicacao");
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}

class CardText extends StatelessWidget {
  final String text;

  const CardText(this.text, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10, left: 5),
      child: Text(
        text,
        style: TextStyle(fontSize: 15),
      ),
    );
  }
}

class QuestionarioAplicadoItem extends StatelessWidget {
  final QuestionarioAplicadoModel _questionario;

  const QuestionarioAplicadoItem(this._questionario, {Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 10,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CardText("Questionario: ${_questionario.nome}"),
            CardText("Referencia: ${_questionario.referencia}"),
            ButtonTheme.bar(
              child: ButtonBar(
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.record_voice_over),
                    onPressed: () {
                      Navigator.pushNamed(
                          context, "/aplicacao/aplicando_pergunta", arguments: AplicandoPerguntaPageArguments(_questionario.id));
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.person_add),
                    onPressed: () {
                      Navigator.pushNamed(context, "/aplicacao/pendencias",
                          arguments: _questionario.id);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      // Abrir questionário
                      Navigator.pushNamed(
                          context, "/aplicacao/momento_aplicacao",
                          arguments: _questionario.id);
                    },
                  ),
                ],
              ),
            )
          ],
        ));
  }
}

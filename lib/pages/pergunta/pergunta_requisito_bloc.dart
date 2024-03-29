import 'package:firestore_wrapper/firestore_wrapper.dart' as fw;
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/models/models.dart';
import 'package:pmsbmibile3/models/pergunta_tipo_model.dart';
import 'package:rxdart/rxdart.dart';

class PerguntaRequisitoPageEvent {}

class UpdatePerguntaIDEvent extends PerguntaRequisitoPageEvent {
  final String perguntaID;
  UpdatePerguntaIDEvent({this.perguntaID});
}

class UpdateRequisitosListEvent extends PerguntaRequisitoPageEvent {
  final String requisitoUid;
  final bool marcado;

  UpdateRequisitosListEvent({this.requisitoUid, this.marcado});
}

class UpdateRequisitosPerguntaEvent extends PerguntaRequisitoPageEvent {}

class SaveEvent extends PerguntaRequisitoPageEvent {}

class CheckRequisitoEscolhaEvent extends PerguntaRequisitoPageEvent {}

class PerguntaRequisitoPageState {
  String perguntaID;
  String eixoID;
  PerguntaModel perguntaModel;

  Map requisitosPerguntaList = Map<String, Map<String, dynamic>>();
  Map<String, Requisito> requisitosPergunta;
  Map<String, dynamic> requisitosPerguntaRemovidos = Map<String, dynamic>();

  bool temReqEscolha;

  // // Map requisitoEscolha = Map<String, Map<String, dynamic>>();
  // Map<String, Requisito> requisitoEscolha = Map<String, Requisito>();

  void updateStateFromPerguntaModel() {
    requisitosPergunta = Map<String, Requisito>();
    // requisitosPergunta = perguntaModel.requisitos;
    requisitosPergunta = perguntaModel.requisitos != null
        ? perguntaModel.requisitos
        : requisitosPergunta;
  }
}

class PerguntaRequisitoBloc {
  //Firestore
  final fw.Firestore _firestore;

  //Eventos
  final _eventController = BehaviorSubject<PerguntaRequisitoPageEvent>();
  Stream<PerguntaRequisitoPageEvent> get eventStream => _eventController.stream;
  Function get eventSink => _eventController.sink.add;

  //Estados
  final PerguntaRequisitoPageState _state = PerguntaRequisitoPageState();
  final _stateController = BehaviorSubject<PerguntaRequisitoPageState>();
  Stream<PerguntaRequisitoPageState> get stateStream => _stateController.stream;
  Function get stateSink => _stateController.sink.add;

  //Bloc
  PerguntaRequisitoBloc(this._firestore) {
    eventStream.listen(_mapEventToState);
  }
  void dispose() {
    _stateController.close();
    _eventController.close();
  }

  _mapEventToState(PerguntaRequisitoPageEvent event) async {
    if (event is UpdatePerguntaIDEvent) {
      _state.perguntaID = event.perguntaID;
      final docRef = _firestore
          .collection(PerguntaModel.collection)
          .document(_state.perguntaID);

      final docSnap = await docRef.get();

      if (docSnap.exists) {
        final perguntaModel =
            PerguntaModel(id: docSnap.documentID).fromMap(docSnap.data);
        _state.perguntaModel = perguntaModel;
        _state.eixoID = _state.perguntaModel.eixo.id;
        _state.updateStateFromPerguntaModel();
      }

      final perguntasRef = _firestore
          .collection(PerguntaModel.collection)
          .where("eixo.id", isEqualTo: _state.eixoID);

      final fw.QuerySnapshot perguntasSnapshot =
          await perguntasRef.getDocuments();
      final perguntaModelList =
          perguntasSnapshot.documents.map((fw.DocumentSnapshot doc) {
        return PerguntaModel(id: doc.documentID).fromMap(doc.data);
      }).toList();

      perguntaModelList.forEach((PerguntaModel pergunta) {
        if (pergunta.id != _state.perguntaID) {
          final tipoEnum = PerguntaTipoModel.ENUM[pergunta.tipo.id];
          final contains = _state.requisitosPergunta.containsKey(pergunta.id);
          _state.requisitosPerguntaList[pergunta.id] = {
            "questionario": 'Q: ${pergunta.questionario.nome}',
            "pergunta": 'P: ${pergunta.titulo}',
            "requisito": contains
                ? _state.requisitosPergunta[pergunta.id]
                : Requisito(
                    referencia: pergunta.referencia,
                    perguntaTipo: pergunta.tipo.id,
                    perguntaID: null,
                    label:
                        'Q: ${pergunta.questionario.nome}\nP: ${pergunta.titulo}',
                  ),
            "checkbox": contains,
          };

          if (tipoEnum == PerguntaTipoEnum.EscolhaUnica ||
              tipoEnum == PerguntaTipoEnum.EscolhaMultipla) {
            pergunta.escolhas.forEach((k, v) {
              final requisitoKey = "${pergunta.id}$k";
              final contains =
                  _state.requisitosPergunta.containsKey(requisitoKey);
              final requisito = contains
                  ? _state.requisitosPergunta[requisitoKey]
                  : Requisito(
                      referencia: pergunta.referencia,
                      perguntaTipo: pergunta.tipo.id,
                      perguntaID: null,
                      escolha: EscolhaRequisito(
                        id: k,
                        marcada: false,
                        label:
                            'Q: ${pergunta.questionario.nome}\nP: ${pergunta.titulo}\nE: ${v.texto}',
                      ),
                    );
              _state.requisitosPerguntaList[requisitoKey] = {
                "questionario": 'Q: ${pergunta.questionario.nome}',
                "pergunta": "P: ${pergunta.titulo}\nE: ${v.texto}",
                "requisito": requisito,
                "checkbox": contains,
              };
            });
          }
        }
      });
    }
    if (event is UpdateRequisitosListEvent) {
      _state.requisitosPerguntaList[event.requisitoUid]["checkbox"] =
          event.marcado;
      if (!_stateController.isClosed) _stateController.add(_state);
    }

    if (event is SaveEvent) {
      _state.requisitosPerguntaList.forEach((key, value) {
        if (value["checkbox"] != null) {
          if (value["checkbox"]) {
            _state.requisitosPergunta[key] = value["requisito"];
          } else {
            _state.requisitosPerguntaRemovidos[key] =
                Bootstrap.instance.FieldValue.delete();
          }
        }
      });

      final docRef = _firestore
          .collection(PerguntaModel.collection)
          .document(_state.perguntaID);

      final instance = PerguntaModel(
        requisitos: _state.requisitosPergunta,
      );
      final map = instance.toMap();

      map["requisitos"].addAll(_state.requisitosPerguntaRemovidos);

      await docRef.setData(map, merge: true);
      // eventSink(CheckRequisitoEscolhaEvent());
    }

    if (event is CheckRequisitoEscolhaEvent) {
      _state.temReqEscolha = false;
      _state.requisitosPergunta.forEach((k, v) {
        if (v.escolha != null) {
          _state.temReqEscolha = true;
        }
      });
    }

    if (!_stateController.isClosed) _stateController.add(_state);
    // print('>>> _state.toMap() <<< ${_state.toMap()}');
    print(
        '>>> PerguntaRequisitoBloc event.runtimeType <<< ${event.runtimeType}');
  }
}

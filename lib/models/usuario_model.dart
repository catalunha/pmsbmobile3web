// import 'package:validators/validators.dart';
import 'package:pmsbmibile3/models/base_model.dart';
import 'package:pmsbmibile3/models/propriedade_for_model.dart';

class UsuarioModel extends FirestoreModel {
  static final String collection = "Usuario";
  String nome;
  String celular;
  String email;
  bool ativo;
  UsuarioArquivoID usuarioArquivoID;
  List<RotaID> rotaID;
  SetorCensitarioID setorCensitarioID;
  CargoID cargoID;
  EixoID eixoIDAtual;
  EixoID eixoID;
  List<EixoID> eixoIDAcesso;

  UsuarioModel(
      {String id,
      this.nome,
      this.celular,
      this.email,
      this.ativo,
      this.usuarioArquivoID,
      this.rotaID,
      this.setorCensitarioID,
      this.cargoID,
      this.eixoIDAtual,
      this.eixoID,
      this.eixoIDAcesso})
      : super(id);

  @override
  UsuarioModel fromMap(Map<String, dynamic> map) {
    if (map.containsKey('nome')) nome = map['nome'];
    if (map.containsKey('celular')) celular = map['celular'];
    if (map.containsKey('email')) email = map['email'];
    if (map.containsKey('ativo')) ativo = map['ativo'];
    if (map.containsKey('usuarioArquivoID')) {
      usuarioArquivoID = map['usuarioArquivoID'] != null
          ? new UsuarioArquivoID.fromMap(map['usuarioArquivoID'])
          : null;
    }
    if (map.containsKey('rotaID') && (map['rotaID'] != null)) {
      rotaID = new List<RotaID>();
      map['rotaID'].forEach((v) {
        rotaID.add(new RotaID.fromMap(v));
      });
    }
    if (map.containsKey('setorCensitarioID')) {
      setorCensitarioID = map['setorCensitarioID'] != null
          ? new SetorCensitarioID.fromMap(map['setorCensitarioID'])
          : null;
    }
    if (map.containsKey('cargoID')) {
      cargoID =
          map['cargoID'] != null ? new CargoID.fromMap(map['cargoID']) : null;
    }
    if (map.containsKey('eixoIDAtual')) {
      eixoIDAtual = map['eixoIDAtual'] != null
          ? new EixoID.fromMap(map['eixoIDAtual'])
          : null;
    }
    if (map.containsKey('eixoID')) {
      eixoID = map['eixoID'] != null ? new EixoID.fromMap(map['eixoID']) : null;
    }
    if (map.containsKey('eixoIDAcesso') && (map['eixoIDAcesso'] != null)) {
      eixoIDAcesso = new List<EixoID>();
      map['eixoIDAcesso'].forEach((v) {
        eixoIDAcesso.add(new EixoID.fromMap(v));
      });
    }
    return this;
  }

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (nome != null) data['nome'] = this.nome;
    if (celular != null) data['celular'] = this.celular;
    if (email != null) data['email'] = this.email;
    if (ativo != null) data['ativo'] = this.ativo;
    if (this.usuarioArquivoID != null) {
      data['usuarioArquivoID'] = this.usuarioArquivoID.toMap();
    }
    if (this.rotaID != null) {
      data['rotaID'] = this.rotaID.map((v) => v.toMap()).toList();
    }
    if (this.setorCensitarioID != null) {
      data['setorCensitarioID'] = this.setorCensitarioID.toMap();
    }
    if (this.cargoID != null) {
      data['cargoID'] = this.cargoID.toMap();
    }
    if (this.eixoIDAtual != null) {
      data['eixoIDAtual'] = this.eixoIDAtual.toMap();
    }
    if (this.eixoID != null) {
      data['eixoID'] = this.eixoID.toMap();
    }
    if (this.eixoIDAcesso != null) {
      data['eixoIDAcesso'] = this.eixoIDAcesso.map((v) => v.toMap()).toList();
    }
    return data;
  }
}


class OvertimeModel{
  final String ? departement;
  final List data;


  OvertimeModel({this.departement, required this.data});

  factory OvertimeModel.fromJson(dynamic json){
    return OvertimeModel(
      departement: json['departement'],
      data: json['data'],
    );
  }

  static List<OvertimeModel> OvertimeModelFromSnapshot(List ? snapshot){
    return snapshot!.map((e){
      return OvertimeModel.fromJson(e);
    }).toList();
  }

  @override
  String toString(){
    return '{departement: $departement, data: $data}';
  }
  
}
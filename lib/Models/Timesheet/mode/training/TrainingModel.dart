class TrainingModel{
  final int? id;
  final String? project_name;



  TrainingModel({this.id, this.project_name});

  factory TrainingModel.fromJson(dynamic json){
    return TrainingModel(
      id: json['id'],
      project_name: json['project_name'],
    );
  }

  static List<TrainingModel> TrainingModelFromSnapshot(List snapshot){
    return snapshot.map((e){
      return TrainingModel.fromJson(e);
    }).toList();
  }

  @override
  String toString(){
    return '{id: $id, project_name, $project_name}';
  }
  
}
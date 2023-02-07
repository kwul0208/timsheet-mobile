class TrainingModel{
  final String? id;
  final String? training_name;



  TrainingModel({this.id, this.training_name});

  factory TrainingModel.fromJson(dynamic json){
    return TrainingModel(
      id: json['id'],
      training_name: json['training_name'],
    );
  }

  static List<TrainingModel> TrainingModelFromSnapshot(List snapshot){
    return snapshot.map((e){
      return TrainingModel.fromJson(e);
    }).toList();
  }

  @override
  String toString(){
    return '{id: $id, training_name, $training_name}';
  }
  
}
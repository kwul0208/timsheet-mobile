class ProjectModel{
  final int? id;
  final String? project_name;



  ProjectModel({this.id, this.project_name});

  factory ProjectModel.fromJson(dynamic json){
    return ProjectModel(
      id: json['id'],
      project_name: json['project_name'],
    );
  }

  static List<ProjectModel> ProjectModelFromSnapshot(List snapshot){
    return snapshot.map((e){
      return ProjectModel.fromJson(e);
    }).toList();
  }

  @override
  String toString(){
    return '{id: $id, project_name, $project_name}';
  }
  
}
class EmployeesModel{
  final int id;
  final String fullname;

  EmployeesModel({required this.id, required this.fullname});

  factory EmployeesModel.fromJson(dynamic json){
    return EmployeesModel(
      id: json['id'],
      fullname: json['fullname']
    );
  }

  static List<EmployeesModel> EmployeesModelFromSnapshot(List snapshot){
    return snapshot.map((e){
      return EmployeesModel.fromJson(e);
    }).toList();
  }

  @override
  String toString(){
    return '{id: $id, fullname: $fullname}';
  }
  
}
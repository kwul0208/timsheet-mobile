class AssignmentModel{
  final int id;
  final String? assignment_number;
  final String? companies_name;
  final String? service_name;
  final String? service_periode;
  final String? service_scope;


  AssignmentModel({required this.id, this.assignment_number, this.companies_name,  this.service_name, this.service_periode,  this.service_scope});

  factory AssignmentModel.fromJson(dynamic json){
    return AssignmentModel(
      id: json['id'],
      assignment_number: json['assignment_number'],
      companies_name: json['companies_name'],
      service_name: json['service_name'],
      service_periode: json['service_periode'],
      service_scope: json['service_scope']

    );
  }

  static List<AssignmentModel> AssignmentModelFromSnapshot(List snapshot){
    return snapshot.map((e){
      return AssignmentModel.fromJson(e);
    }).toList();
  }

  @override
  String toString(){
    return '{id: $id, assignment_number: $assignment_number, companies_name: $companies_name, service_name: $service_name, service_periode: $service_periode, service_scope: $service_scope}';
  }
  
}
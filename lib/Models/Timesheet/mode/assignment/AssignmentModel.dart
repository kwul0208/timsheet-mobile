class AssignmentModel{
  final int id;
  final String? assignment_number;
  final String? companies_name;
  final String? service_name;
  final String? service_period;
  final String? service_scope;
  final String? ope;


  AssignmentModel({required this.id, this.assignment_number, this.companies_name,  this.service_name, this.service_period,  this.service_scope, this.ope});

  factory AssignmentModel.fromJson(dynamic json){
    return AssignmentModel(
      id: json['id'],
      assignment_number: json['assignment_number'],
      companies_name: json['companies_name'],
      service_name: json['service_name'],
      service_period: json['service_period'],
      service_scope: json['service_scope'],
      ope: json['ope']

    );
  }

  static List<AssignmentModel> AssignmentModelFromSnapshot(List snapshot){
    return snapshot.map((e){
      return AssignmentModel.fromJson(e);
    }).toList();
  }

  @override
  String toString(){
    return '{id: $id, assignment_number: $assignment_number, companies_name: $companies_name, service_name: $service_name, service_period: $service_period, service_scope: $service_scope, ope: $ope}';
  }
  
}
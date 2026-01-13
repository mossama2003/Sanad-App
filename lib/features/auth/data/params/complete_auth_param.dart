class CompleteAuthParam {
  final String fName;
  final String lName;
  final String dob;
  final String gender;

  CompleteAuthParam({
    required this.fName,
    required this.lName,
    required this.dob,
    required this.gender,
  });

  Map<String, dynamic> toJson() => {
        "first_name": fName,
        "last_name": lName,
        "birthday": dob,
        "gender": gender,
      };
}

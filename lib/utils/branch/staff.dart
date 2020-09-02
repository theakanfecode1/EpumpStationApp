

class State{
  String countryName;
  String name;
  String id;

  State({this.countryName, this.name, this.id});

  factory State.fromJson(Map<String,dynamic> json){
    return State(
      countryName: json["countryName"] == null ? "":json["countryName"],
      name: json["name"] == null ? "":json["name"],
      id: json["id"] == null ? "":json["id"],

    );
  }


}
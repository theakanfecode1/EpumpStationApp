class Company {
  String id;
  String name;
  String email;
  String street;
  String city;
  String state;
  String country;
  int numberOfBranches;
  int numberOfDealers;
  String url;

  Company(
      {this.id,
      this.name,
      this.email,
      this.street,
      this.city,
      this.state,
      this.country,
      this.numberOfBranches,
      this.numberOfDealers,
      this.url});

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      id: json["id"] == null ? "" : json["id"],
      name: json["name"] == null ? "" : json["name"],
      email: json["email"] == null ? "" : json["email"],
      street: json["street"] == null ? "" : json["street"],
      city: json["city"] == null ? "" : json["city"],
      state: json["state"] == null ? "" : json["state"],
      country: json["country"] == null ? "" : json["country"],
      numberOfBranches:
          json["numberOfBranches"] == null ? 0 : json["numberOfBranches"],
      numberOfDealers:
          json["numberOfDealers"] == null ? 0 : json["numberOfDealers"],
      url: json["url"] == null ? "" : json["url"],
    );
  }
}

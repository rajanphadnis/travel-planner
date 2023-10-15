class Trip {
  String name = "";

  Trip(this.name);

  factory Trip.fromFirestore() {
    return Trip("test");
  }
}

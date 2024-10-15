class Exercise {
  String title;
  String details;
  bool done;
  String sheduleDate;

  Exercise(
      {required this.title,
      required this.details,
      required this.done,
      required this.sheduleDate});

  factory Exercise.fromMap(Map exerscise) {
    return Exercise(
        title: exerscise["title"],
        details: exerscise["details"],
        done: exerscise["done"],
        sheduleDate: exerscise["sheduleDate"]);
  }

  Map toMap() {
    return {
      "title": title,
      "details": details,
      "done": done,
      "sheduleDate": sheduleDate,
    };
  }
}

              
            



               



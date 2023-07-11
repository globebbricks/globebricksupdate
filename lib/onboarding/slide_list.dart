class Slide {
  String title;
  String description;
  String image;

  Slide({required this.title, required this.description, required this.image});
}

final slideList = [
  Slide(
      title: "Rented Properties",
      description: "Find affordable properties across the world.",
      image: "assets/newScene.json"),
  Slide(
      title: "Buy or Sell",
      description: "You now have a platform to buy or sell properties.",
      image: "assets/property.json"),

  Slide(
      title: "Flat Sharing",
      description:
      "You also can find flatmates for your properties.",
      image: "assets/ob.json"),

  Slide(
      title: "Collaboration",
      description:
      "You can even find collaboration or builders here.",
      image: "assets/collaboration.json"),
   Slide(
      title: "Repair Property",
      description:
      "We have dedicated professionals that helps to repair your property.",
      image: "assets/people.json"),

];

class CoastPlaces {
  final String location;
  final String subtitle;
  final String image;

  const CoastPlaces({required this.location,required this.subtitle,required this.image});
}

const List<CoastPlaces> places = [
   CoastPlaces(
    location : 'Zagazig',
    subtitle : '2 Stars',
    image : 'assets/images/splachlogo.png',
  ),
  CoastPlaces(
    location : 'Cairo',
    subtitle : '5 Stars',
    image : 'assets/images/splachlogo.png',
  ),
  CoastPlaces(
    location : 'Alex',
    subtitle : '2 Stars',
    image : 'assets/images/splachlogo.png',
  ),
  CoastPlaces(
    location : 'Suez',
    subtitle : '3 Stars',
    image : 'assets/images/splachlogo.png',
  ),
  CoastPlaces(
    location : 'Banha',
    subtitle : '2 Stars',
    image : 'assets/images/splachlogo.png',
  ),
];




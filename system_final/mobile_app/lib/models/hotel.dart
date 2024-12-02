class Hotel {
  final int id;
  final String name;
  final String description;
  final String image;
  final double rating;
  final int totalReviews;

  Hotel({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.rating,
    required this.totalReviews,
  });
}

final List<Hotel> dummyHotels = [
  Hotel(
    id: 1,
    name: 'Grand Luxury Hotel',
    description: 'Experience luxury at its finest with our premium amenities and world-class service.',
    image: 'https://images.unsplash.com/photo-1566073771259-6a8506099945',
    rating: 4.8,
    totalReviews: 128,
  ),
  Hotel(
    id: 2,
    name: 'Seaside Resort',
    description: 'Beachfront paradise with stunning ocean views and private beach access.',
    image: 'https://images.unsplash.com/photo-1520250497591-112f2f40a3f4',
    rating: 4.5,
    totalReviews: 96,
  ),
  Hotel(
    id: 3,
    name: 'Mountain View Lodge',
    description: 'Cozy mountain retreat perfect for nature lovers and adventure seekers.',
    image: 'https://images.unsplash.com/photo-1551882547-ff40c63fe5fa',
    rating: 4.6,
    totalReviews: 75,
  ),
  Hotel(
    id: 4,
    name: 'City Center Hotel',
    description: 'Prime location in the heart of downtown, perfect for business and leisure.',
    image: 'https://images.unsplash.com/photo-1566073771259-6a8506099945',
    rating: 4.3,
    totalReviews: 112,
  ),
  Hotel(
    id: 5,
    name: 'Boutique Inn',
    description: 'Charming boutique hotel with personalized service and unique character.',
    image: 'https://images.unsplash.com/photo-1520250497591-112f2f40a3f4',
    rating: 4.7,
    totalReviews: 64,
  ),
]; 
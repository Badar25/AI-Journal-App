abstract interface class ApiConfig {
  static const token =
      "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI2ZGE2NGQzMjZmNzgyM2Q0NzJjMjhkMGIwNTUxMWM2MCIsIm5iZiI6MTczOTM0MDgzMC42MzMsInN1YiI6IjY3YWMzYzFlMDliODU1MWEwNGIwYzVkMyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.aR37iUx8t2pd0WUKhajOeG7mi5H5Bb1c4gBd6yawFmQ";

  static const String baseUrl = "https://api.themoviedb.org/3";
  static const String imageBaseUrl = 'https://image.tmdb.org/t/p/w500';

  static const Duration receiveTimeout = Duration(milliseconds: 15000); // 15 seconds
  static const Duration connectionTimeout = Duration(milliseconds: 15000); // 15 seconds
  static const String users = '/users';

  static const String movie = '/movie';
  static const String upcoming = '/movie/upcoming';
  static const String search = '/search/$movie';
  static const String searchByGenre = '/discover$movie';
  static const String genre = '/genre/movie/list';

  static const header = {'Authorization': 'Bearer $token', 'content-Type': 'application/json'};
}

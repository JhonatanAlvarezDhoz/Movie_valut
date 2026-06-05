import 'package:get/get.dart';
import 'package:movie_vault/core/errors/result.dart';
import 'package:movie_vault/features/movies/domain/entities/movie.dart';
import 'package:movie_vault/features/movies/domain/entities/movie_category.dart';
import 'package:movie_vault/features/movies/domain/entities/movie_detail.dart';
import 'package:movie_vault/features/movies/domain/usecases/get_movie_detail_use_case.dart';
import 'package:movie_vault/features/movies/domain/usecases/get_movies_use_case.dart';

class MoviesController extends GetxController {
  MoviesController({
    required GetMoviesUseCase getMoviesUseCase,
    required GetMovieDetailUseCase getMovieDetailUseCase,
  }) : _getMoviesUseCase = getMoviesUseCase,
       _getMovieDetailUseCase = getMovieDetailUseCase;

  final GetMoviesUseCase _getMoviesUseCase;
  final GetMovieDetailUseCase _getMovieDetailUseCase;

  final selectedCategory = MovieCategory.popular.obs;
  final movies = <Movie>[].obs;
  final isLoading = false.obs;
  final isLoadingMore = false.obs;
  final hasReachedEnd = false.obs;
  final errorMessage = RxnString();
  final selectedMovieDetail = Rxn<MovieDetail>();
  final isLoadingDetail = false.obs;
  final detailErrorMessage = RxnString();
  int _currentPage = 0;
  int _totalPages = 1;

  @override
  void onInit() {
    super.onInit();
    loadMovies();
  }

  Future<void> selectCategory(MovieCategory category) async {
    if (selectedCategory.value == category && movies.isNotEmpty) return;

    selectedCategory.value = category;
    _resetPagination();
    movies.clear();
    await loadMovies();
  }

  Future<void> refreshCurrentCategory() async {
    await loadMovies(forceRefresh: true);
  }

  Future<void> loadMovies({bool forceRefresh = false}) async {
    if (isLoading.value) return;

    isLoading.value = true;
    errorMessage.value = null;
    if (forceRefresh) {
      _resetPagination();
    }

    final result = await _getMoviesUseCase(
      selectedCategory.value,
      forceRefresh: forceRefresh,
      page: 1,
    );

    isLoading.value = false;

    switch (result) {
      case ResultSuccess(value: final moviePage):
        _currentPage = moviePage.currentPage;
        _totalPages = moviePage.totalPages;
        hasReachedEnd.value = !moviePage.hasMorePages;
        movies.assignAll(moviePage.movies);
      case ResultFailure(failure: final failure):
        errorMessage.value = failure.message;
    }
  }

  Future<void> loadNextPage() async {
    if (isLoading.value || isLoadingMore.value || hasReachedEnd.value) return;
    if (movies.isEmpty) return;

    isLoadingMore.value = true;
    errorMessage.value = null;

    final result = await _getMoviesUseCase(
      selectedCategory.value,
      page: _currentPage + 1,
    );

    isLoadingMore.value = false;

    switch (result) {
      case ResultSuccess(value: final moviePage):
        _currentPage = moviePage.currentPage;
        _totalPages = moviePage.totalPages;
        hasReachedEnd.value =
            !moviePage.hasMorePages || moviePage.movies.isEmpty;
        _appendUniqueMovies(moviePage.movies);
      case ResultFailure(failure: final failure):
        errorMessage.value = failure.message;
    }
  }

  Future<void> loadMovieDetail(Movie movie) async {
    isLoadingDetail.value = true;
    detailErrorMessage.value = null;
    selectedMovieDetail.value = MovieDetail(
      movie: movie,
      genres: const [],
      cast: const [],
    );

    final result = await _getMovieDetailUseCase(movie);
    isLoadingDetail.value = false;

    switch (result) {
      case ResultSuccess(value: final detail):
        selectedMovieDetail.value = detail;
      case ResultFailure(failure: final failure):
        detailErrorMessage.value = failure.message;
    }
  }

  void _appendUniqueMovies(List<Movie> nextMovies) {
    final existingIds = movies.map((movie) => movie.id).toSet();
    movies.addAll(
      nextMovies.where((movie) => existingIds.add(movie.id)).toList(),
    );
    if (_currentPage >= _totalPages) {
      hasReachedEnd.value = true;
    }
  }

  void _resetPagination() {
    _currentPage = 0;
    _totalPages = 1;
    hasReachedEnd.value = false;
  }
}

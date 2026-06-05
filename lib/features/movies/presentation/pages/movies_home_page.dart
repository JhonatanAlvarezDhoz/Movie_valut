import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_vault/core/router/app_routes.dart';
import 'package:movie_vault/core/shared/widgets/feedback/app_error_view.dart';
import 'package:movie_vault/core/shared/widgets/loaders/app_loader.dart';
import 'package:movie_vault/core/shared/widgets/loaders/app_loading_view.dart';
import 'package:movie_vault/features/movies/presentation/controllers/movies_controller.dart';
import 'package:movie_vault/features/movies/presentation/widgets/movie_card.dart';
import 'package:movie_vault/features/movies/presentation/widgets/movie_category_selector.dart';

class MoviesHomePage extends StatefulWidget {
  const MoviesHomePage({super.key});

  @override
  State<MoviesHomePage> createState() => _MoviesHomePageState();
}

class _MoviesHomePageState extends State<MoviesHomePage> {
  late final MoviesController _controller;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _controller = Get.find<MoviesController>();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final position = _scrollController.position;
    final shouldLoadMore = position.pixels >= position.maxScrollExtent - 320;

    if (shouldLoadMore) {
      _controller.loadNextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie Vault'),
        actions: [
          IconButton(
            tooltip: 'Cuenta',
            onPressed: () => Get.toNamed(AppRoutes.account),
            icon: const Icon(Icons.person_outline),
          ),
          IconButton(
            tooltip: 'Ajustes',
            onPressed: () => Get.toNamed(AppRoutes.settings),
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: SafeArea(
        child: Obx(() {
          final movies = _controller.movies;
          final error = _controller.errorMessage.value;
          final isLoading = _controller.isLoading.value;
          final isLoadingMore = _controller.isLoadingMore.value;
          final showPaginationError =
              error != null && movies.isNotEmpty && !isLoadingMore;

          return Column(
            children: [
              MovieCategorySelector(
                selectedCategory: _controller.selectedCategory.value,
                onSelected: _controller.selectCategory,
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _controller.refreshCurrentCategory,
                  child: Builder(
                    builder: (context) {
                      if (isLoading && movies.isEmpty) {
                        return const AppLoadingView(
                          message: 'Cargando películas...',
                        );
                      }

                      if (error != null && movies.isEmpty) {
                        return ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: [
                            const SizedBox(height: 120),
                            AppErrorView(
                              message: error,
                              icon: Icons.cloud_off_rounded,
                              onRetry: _controller.refreshCurrentCategory,
                            ),
                          ],
                        );
                      }

                      if (movies.isEmpty) {
                        return const Center(
                          child: Text('No hay películas disponibles.'),
                        );
                      }

                      return ListView.separated(
                        controller: _scrollController,
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                        itemBuilder: (context, index) {
                          if (index == movies.length) {
                            if (isLoadingMore) {
                              return const _PaginationFooter(
                                child: AppLoader(size: 24),
                              );
                            }

                            return _PaginationFooter(
                              child: AppErrorView(
                                message:
                                    error ??
                                    'No se pudieron cargar más películas.',
                                compact: true,
                              ),
                            );
                          }

                          return MovieCard(movie: movies[index]);
                        },
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 12),
                        itemCount:
                            movies.length +
                            (isLoadingMore || showPaginationError ? 1 : 0),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

class _PaginationFooter extends StatelessWidget {
  const _PaginationFooter({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      child: Center(child: child),
    );
  }
}

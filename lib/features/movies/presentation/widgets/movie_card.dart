import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_vault/core/config/app_config.dart';
import 'package:movie_vault/core/router/app_routes.dart';
import 'package:movie_vault/core/shared/widgets/images/cached_remote_image.dart';
import 'package:movie_vault/features/movies/domain/entities/movie.dart';

class MovieCard extends StatelessWidget {
  const MovieCard({super.key, required this.movie});

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final posterUrl = AppConfig.tmdbImageUrl(movie.posterPath);

    final heroTag = 'movie-poster-${movie.id}';

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Get.toNamed(
          AppRoutes.movieDetail.replaceFirst(':movieId', movie.id.toString()),
          arguments: movie,
        ),
        child: SizedBox(
          height: 172,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Hero(
                tag: heroTag,
                transitionOnUserGestures: true,
                child: CachedRemoteImage(
                  imageUrl: posterUrl,
                  width: 116,
                  height: 172,
                  borderRadius: BorderRadius.zero,
                  semanticLabel: movie.title,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        movie.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        movie.releaseDate.isEmpty
                            ? 'Sin fecha'
                            : movie.releaseDate,
                        style: theme.textTheme.bodySmall,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            size: 18,
                            color: Colors.amber,
                          ),
                          const SizedBox(width: 4),
                          Text(movie.voteAverage.toStringAsFixed(1)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: Text(
                          movie.overview.isEmpty
                              ? 'Sin descripción disponible.'
                              : movie.overview,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

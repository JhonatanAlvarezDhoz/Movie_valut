import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_vault/core/config/app_config.dart';
import 'package:movie_vault/core/shared/widgets/images/cached_remote_image.dart';
import 'package:movie_vault/core/shared/widgets/loaders/app_loader.dart';
import 'package:movie_vault/core/extensions/context_theme_extension.dart';
import 'package:movie_vault/features/movies/domain/entities/cast_member.dart';
import 'package:movie_vault/features/movies/domain/entities/movie.dart';
import 'package:movie_vault/features/movies/domain/entities/movie_detail.dart';
import 'package:movie_vault/features/movies/presentation/controllers/movies_controller.dart';

class MovieDetailPage extends StatefulWidget {
  const MovieDetailPage({super.key});

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  final _controller = Get.find<MoviesController>();

  Movie? get _movie => Get.arguments is Movie ? Get.arguments as Movie : null;

  @override
  void initState() {
    super.initState();
    final movie = _movie;
    if (movie != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _controller.loadMovieDetail(movie);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final movie = _movie;
    final movieId = Get.parameters['movieId'];

    if (movie == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Detalle')),
        body: Center(child: Text('Movie ID: ${movieId ?? '-'}')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(movie.title, maxLines: 1)),
      body: Obx(() {
        final detail =
            _controller.selectedMovieDetail.value ??
            MovieDetail(movie: movie, genres: const [], cast: const []);

        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            _MovieHeader(detail: detail),
            const SizedBox(height: 20),
            _BackdropImage(movie: detail.movie),
            const SizedBox(height: 20),
            _OverviewSection(movie: detail.movie),
            if (_controller.isLoadingDetail.value) ...[
              const SizedBox(height: 24),
              const Center(child: AppLoader()),
            ],
            if (detail.cast.isNotEmpty) ...[
              const SizedBox(height: 24),
              _CastSection(cast: detail.cast),
            ],
          ],
        );
      }),
    );
  }
}

class _MovieHeader extends StatelessWidget {
  const _MovieHeader({required this.detail});

  final MovieDetail detail;

  @override
  Widget build(BuildContext context) {
    final movie = detail.movie;
    final theme = Theme.of(context);
    final posterUrl = AppConfig.tmdbImageUrl(movie.posterPath);
    final heroTag = 'movie-poster-${movie.id}';
    final categoryText = _categoryText(detail);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.22),
                blurRadius: 18,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Hero(
            tag: heroTag,
            transitionOnUserGestures: true,
            child: CachedRemoteImage(
              imageUrl: posterUrl,
              width: 132,
              height: 198,
              semanticLabel: movie.title,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                movie.title,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.headlineSmall,
              ),
              const SizedBox(height: 12),
              _MetadataRow(movie: movie),
              if (categoryText.isNotEmpty) ...[
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    Chip(label: Text(categoryText)),
                    ...detail.genres
                        .take(2)
                        .map((genre) => Chip(label: Text(genre))),
                  ],
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  String _categoryText(MovieDetail detail) {
    if (detail.movie.categoryLabel.isNotEmpty) {
      return detail.movie.categoryLabel;
    }

    return detail.genres.isNotEmpty ? detail.genres.first : '';
  }
}

class _MetadataRow extends StatelessWidget {
  const _MetadataRow({required this.movie});

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.calendar_today_outlined, size: 16),
            const SizedBox(width: 4),
            Text(movie.releaseDate.isEmpty ? 'Sin fecha' : movie.releaseDate),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.star_rounded, size: 18, color: context.colors.rating),
            const SizedBox(width: 4),
            Text(movie.voteAverage.toStringAsFixed(1)),
          ],
        ),
      ],
    );
  }
}

class _BackdropImage extends StatelessWidget {
  const _BackdropImage({required this.movie});

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    final backdropUrl = AppConfig.tmdbImageUrl(
      movie.backdropPath,
      original: true,
    );
    final posterUrl = AppConfig.tmdbImageUrl(movie.posterPath);

    return CachedRemoteImage(
      imageUrl: backdropUrl.isNotEmpty ? backdropUrl : posterUrl,
      height: 220,
      width: double.infinity,
      semanticLabel: movie.title,
    );
  }
}

class _OverviewSection extends StatelessWidget {
  const _OverviewSection({required this.movie});

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Descripción', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        Text(
          movie.overview.isEmpty
              ? 'Sin descripción disponible.'
              : movie.overview,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }
}

class _CastSection extends StatelessWidget {
  const _CastSection({required this.cast});

  final List<CastMember> cast;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Elenco', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        SizedBox(
          height: 174,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) => _CastCard(member: cast[index]),
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemCount: cast.length,
          ),
        ),
      ],
    );
  }
}

class _CastCard extends StatelessWidget {
  const _CastCard({required this.member});

  final CastMember member;

  @override
  Widget build(BuildContext context) {
    final profileUrl = AppConfig.tmdbImageUrl(member.profilePath);

    return SizedBox(
      width: 92,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CachedRemoteImage(
            imageUrl: profileUrl,
            width: 92,
            height: 112,
            semanticLabel: member.name,
          ),
          const SizedBox(height: 8),
          Text(
            member.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelLarge,
          ),
          if (member.character.isNotEmpty)
            Text(
              member.character,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall,
            ),
        ],
      ),
    );
  }
}

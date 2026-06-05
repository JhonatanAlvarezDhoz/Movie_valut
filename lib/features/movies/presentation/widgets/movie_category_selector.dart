import 'package:flutter/material.dart';
import 'package:movie_vault/features/movies/domain/entities/movie_category.dart';

class MovieCategorySelector extends StatelessWidget {
  const MovieCategorySelector({
    super.key,
    required this.selectedCategory,
    required this.onSelected,
  });

  final MovieCategory selectedCategory;
  final ValueChanged<MovieCategory> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemBuilder: (context, index) {
          final category = MovieCategory.values[index];
          return ChoiceChip(
            label: Text(category.label),
            selected: selectedCategory == category,
            onSelected: (_) => onSelected(category),
          );
        },
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemCount: MovieCategory.values.length,
      ),
    );
  }
}

import 'package:flutter_test/flutter_test.dart';
import 'package:movie_valut/core/config/app_config.dart';
import 'package:movie_valut/core/database/cache_refresh_policy.dart';

void main() {
  test('CacheRefreshPolicy refreshes after configured interval', () {
    final policy = CacheRefreshPolicy(
      refreshInterval: AppConfig.moviesRefreshInterval,
    );
    final now = DateTime.utc(2026, 6, 4, 12);

    expect(policy.shouldRefresh(null, now: now), isTrue);
    expect(
      policy.shouldRefresh(now.subtract(const Duration(hours: 11)), now: now),
      isFalse,
    );
    expect(
      policy.shouldRefresh(now.subtract(const Duration(hours: 12)), now: now),
      isTrue,
    );
  });
}

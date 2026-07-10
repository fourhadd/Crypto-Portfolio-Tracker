// features/portfolio/domain/usecases/watch_portfolio_holdings_usecase.dart
import '../entities/holding_entity.dart';
import '../repositories/portfolio_repository.dart';

/// Streams the raw holdings only — no coin/market data attached.
///
/// Pricing is resolved separately by combining these holdings with
/// MarketCubit's already-fetched coin list (falling back to a direct
/// fetch only for coins MarketCubit doesn't have), the same approach
/// used by WatchlistCubit. This avoids firing an independent
/// `coinRepository.getCoinsByIds(...)` request on every holdings change.
class WatchPortfolioHoldingsUseCase {
  final PortfolioRepository portfolioRepository;

  WatchPortfolioHoldingsUseCase({required this.portfolioRepository});

  Stream<List<HoldingEntity>> call() {
    return portfolioRepository.watchHoldings();
  }
}

📱 Crypto Portfolio Tracker

A Flutter application for tracking cryptocurrency prices, managing a personal portfolio, watching favorite coins, comparing coins, and setting price alerts — built with Clean Architecture and Cubit (flutter_bloc) state management.

Live market data is powered by the CoinGecko API.


✨ Features

FeatureDescription🏠 HomeTop coins overview with live prices and 24h change📈 MarketFull, searchable & filterable coin market list🔍 Coin DetailPrice, chart (with selectable ranges), and key stats for a coin⭐ WatchlistSave coins to track without adding them to your portfolio💼 PortfolioAdd/sell holdings, track P&L, view total value & allocation🥧 CompositionVisual breakdown of portfolio allocation (donut chart)⚖️ CompareSide-by-side price chart comparison of two coins🔔 Price AlertsGet notified when a coin crosses a target price⚙️ SettingsCurrency, refresh interval, data export (CSV), and app preferences📡 Offline HandlingApp-wide "no internet" banner + per-screen retry states, and network-gated portfolio actions (see below)


🛠 Tech Stack


Flutter (Dart)
flutter_bloc — state management (Cubit pattern)
get_it — dependency injection (service locator)
go_router — declarative navigation/routing
dio — HTTP client for the CoinGecko API
equatable — value-based state comparisons
flutter_screenutil — responsive sizing
cached_network_image — coin icon caching
fl_chart — price & composition charts
Local persistence via StorageService (SharedPreferences-based) for portfolio, watchlist, and settings — no backend/server, all personal data lives on-device



🏗 Architecture

The project follows Clean Architecture, split per feature into three layers:

feature/
├── data/           # Talks to the outside world (API, local storage)
│   ├── datasources/    → raw API/storage calls
│   ├── models/         → JSON ⇄ Dart mapping (extends domain entities)
│   └── repositories/   → implements the domain repository interface
├── domain/         # Pure business logic, no Flutter/Dio imports
│   ├── entities/       → core business objects
│   ├── repositories/   → abstract contracts
│   └── usecases/       → single-responsibility business actions
└── presentation/   # UI layer
    ├── cubit/          → state management (Cubit + State)
    ├── pages/          → full screens
    └── widgets/        → screen-specific reusable widgets

Data flow: UI → Cubit → UseCase → Repository (interface) → RepositoryImpl → DataSource → API/Storage, and back up the same chain with the result.

Shared code that multiple features depend on lives in core/ (see file structure below), so features stay decoupled from each other and only depend on core.

State Management (Cubit)


Every feature's UI state lives in an immutable XState extends Equatable class with a status enum (initial/loading/loaded/error) and a copyWith.
The matching XCubit extends Cubit<XState> holds the logic: it calls use cases and emit()s new state — never mutates state in place.
UI listens via BlocBuilder (rebuild), BlocSelector (rebuild on a slice of state, for performance), BlocListener (side effects like SnackBars/navigation, no rebuild), or BlocConsumer (both).
Cubits are created through get_it (sl<XCubit>()) and provided locally to a screen via BlocProvider, or app-wide via MultiBlocProvider in app/app.dart when multiple screens need the same state (e.g. PortfolioCubit, ConnectivityCubit).
Some cubits compose others instead of duplicating logic — e.g. HomeCubit subscribes to MarketCubit's stream rather than re-fetching the market list itself.


Offline / Connectivity Handling


ConnectivityCubit (app-wide singleton) polls connectivity every few seconds and can also be notified instantly by DioClient the moment a request fails.
ConnectivityBanner wraps the whole app (in app/app.dart) and slides a "No internet connection" banner over any screen when offline, auto-dismissing after a few seconds.
CoreNetworkErrorView is a shared per-screen error state (icon + message + Retry button) used consistently across Home, Market, Coin Detail, Watchlist, Portfolio, and Compare.
Actions that must not silently "succeed" while offline (adding/selling a holding) re-check connectivity right before submitting and block with a clear error if there's no connection.



📂 File Structure

lib/
├── main.dart                          # App entry point, service init
├── app/
│   └── app.dart                       # Root widget, global providers, theming, ConnectivityBanner
│
├── core/                              # Shared across all features
│   ├── constants/                     # API endpoints, app-wide constants
│   ├── data/                          # Shared coin data layer (used by Home/Market/etc.)
│   │   ├── datasources/
│   │   ├── models/
│   │   └── repositories/
│   ├── domain/
│   │   ├── entities/                  # e.g. CoinEntity
│   │   ├── repositories/
│   │   └── usecases/                  # e.g. GetTopCoinsUseCase
│   ├── di/
│   │   └── injection_container.dart   # get_it registrations (sl)
│   ├── errors/
│   │   ├── exceptions.dart            # ServerException, NetworkException, ...
│   │   └── failures.dart              # Failure classes returned to the UI layer
│   ├── network/
│   │   ├── dio_client.dart            # Dio setup + error interceptor
│   │   └── connectivity_checker.dart  # Lightweight DNS-based reachability check
│   ├── routes/
│   │   └── app_router.dart            # go_router route table
│   ├── sevices/                       # App-wide services (currency, notifications, CSV export, storage)
│   ├── shared/
│   │   ├── cubit/
│   │   │   └── connectivity_cubit.dart
│   │   └── widgets/                   # Reusable UI: coin list tile, error view, connectivity banner
│   ├── theme/                         # Colors, text styles, ThemeData
│   └── utils/                         # Formatters, page transitions
│
└── features/
    ├── home/                          # Top coins overview
    ├── market/                        # Full market list, search & filters
    ├── coin_detail/                   # Single coin price/chart/stats
    ├── watchlist/                     # Saved coins
    ├── portfolio/                     # Holdings: add/sell, list, calendar picker
    ├── composition/                   # Portfolio allocation donut chart
    ├── compare/                       # Two-coin chart comparison
    ├── price_alert/                   # Target-price notifications
    ├── settings/                      # Preferences, currency, data export
    └── onboarding/                    # First-launch intro slides

    # each feature follows: data/ · domain/ · presentation/ (cubit, pages, widgets)
    # (market, composition, onboarding have presentation/ only — they reuse
    #  core's coin data or hold purely local UI state; price_alert has
    #  domain/ + presentation/ but persists via core's StorageService)

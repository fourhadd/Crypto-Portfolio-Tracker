// features/portfolio/presentation/widgets/portfolio_body.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:crypto_portfolio_tracker/core/theme/app_theme.dart';

import '../cubit/portfolio_cubit.dart';
import '../cubit/portfolio_state.dart';
import 'portfolio_empty_state.dart';
import 'portfolio_holdings_list.dart';

class PortfolioBody extends StatelessWidget {
  const PortfolioBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PortfolioCubit, PortfolioState>(
      builder: (context, state) {
        if (state is PortfolioLoading || state is PortfolioInitial) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.accentAmber),
          );
        }

        if (state is PortfolioError) {
          return Center(
            child: Text(state.message, style: AppTextStyles.bodySmall),
          );
        }

        final loaded = state as PortfolioLoaded;
        if (loaded.isEmpty) {
          return const PortfolioEmptyState();
        }

        return PortfolioHoldingsList(items: loaded.items);
      },
    );
  }
}

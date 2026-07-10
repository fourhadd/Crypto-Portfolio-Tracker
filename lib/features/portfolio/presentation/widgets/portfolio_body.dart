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
      buildWhen: (prev, curr) =>
          prev.status != curr.status || prev.items != curr.items,
      builder: (context, state) {
        if (state.status == PortfolioStatus.loading ||
            state.status == PortfolioStatus.initial) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.accentAmber),
          );
        }

        if (state.status == PortfolioStatus.error) {
          return Center(
            child: Text(
              state.errorMessage ?? 'An error occurred',
              style: AppTextStyles.bodySmall,
            ),
          );
        }

        if (state.isEmpty) {
          return const PortfolioEmptyState();
        }

        return PortfolioHoldingsList(items: state.items);
      },
    );
  }
}

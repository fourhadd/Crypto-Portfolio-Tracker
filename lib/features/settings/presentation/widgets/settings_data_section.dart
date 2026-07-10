// features/settings/presentation/widgets/settings_data_section.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:crypto_portfolio_tracker/core/sevices/csv_export_service.dart';
import '../../../portfolio/presentation/cubit/portfolio_cubit.dart';
import '../../../portfolio/presentation/cubit/portfolio_state.dart';
import '../cubit/settings_cubit.dart';
import '../cubit/settings_state.dart';
import 'settings_section.dart';
import 'settings_tile.dart';

/// DATA bölməsi: CSV export.
class SettingsDataSection extends StatelessWidget {
  const SettingsDataSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsSection(
      title: 'DATA',
      children: [
        BlocBuilder<SettingsCubit, SettingsState>(
          buildWhen: (prev, curr) => prev.isExportingCsv != curr.isExportingCsv,
          builder: (context, state) {
            return SettingsTile(
              icon: Icons.file_download_outlined,
              title: 'Export CSV',
              isLoading: state.isExportingCsv,
              onTap: () => _handleExport(context),
            );
          },
        ),
      ],
    );
  }

  Future<void> _handleExport(BuildContext context) async {
    final settingsCubit = context.read<SettingsCubit>();
    final portfolioState = context.read<PortfolioCubit>().state;

    if (portfolioState.status != PortfolioStatus.loaded ||
        portfolioState.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Export ediləcək holding yoxdur')),
      );
      return;
    }

    settingsCubit.setExporting(true);
    try {
      await CsvExportService().exportHoldings(portfolioState.items);
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('An error occurred during export')),
        );
      }
    } finally {
      settingsCubit.setExporting(false);
    }
  }
}

// features/settings/data/services/csv_export_service.dart
import 'dart:io';

import 'package:crypto_portfolio_tracker/features/portfolio/domain/entities/portfolio_coin_entity.dart';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class CsvExportService {
  Future<void> exportHoldings(List<PortfolioCoinEntity> items) async {
    final rows = <List<dynamic>>[
      [
        'Coin',
        'Symbol',
        'Amount',
        'Buy Price',
        'Buy Date',
        'Current Value',
        'P/L %',
      ],
      for (final item in items)
        [
          item.coin.name,
          item.coin.symbol.toUpperCase(),
          item.holding.amount,
          item.holding.buyPrice,
          item.holding.buyDate.toIso8601String(),
          item.currentValue,
          item.profitLossPercent.toStringAsFixed(2),
        ],
    ];

    final csvData = CsvEncoder().convert(rows);

    final directory = await getTemporaryDirectory();
    final file = File(
      '${directory.path}/portfolio_export_${DateTime.now().millisecondsSinceEpoch}.csv',
    );
    await file.writeAsString(csvData);

    await SharePlus.instance.share(
      ShareParams(files: [XFile(file.path)], text: 'Portfolio Export'),
    );
  }
}

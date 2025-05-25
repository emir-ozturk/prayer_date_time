import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';

class MonthlyTableHeader extends StatelessWidget {
  const MonthlyTableHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.3),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Row(
        children: [
          _buildHeaderCell('Tarih', flex: 2),
          _buildHeaderCell('İmsak', flex: 2),
          _buildHeaderCell('Güneş', flex: 2),
          _buildHeaderCell('Öğle', flex: 2),
          _buildHeaderCell('İkindi', flex: 2),
          _buildHeaderCell('Akşam', flex: 2),
          _buildHeaderCell('Yatsı', flex: 2),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String text, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w800,
          color: AppColors.primary,
          letterSpacing: 0.5,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

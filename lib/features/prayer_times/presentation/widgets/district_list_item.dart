import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_icons.dart';
import '../../domain/entities/district.dart';

class DistrictListItem extends StatelessWidget {
  final District district;
  final VoidCallback onTap;

  const DistrictListItem({super.key, required this.district, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.secondary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(AppIcons.cities, color: AppColors.secondary, size: 24),
        ),
        title: Text(
          district.name,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        trailing: const Icon(AppIcons.add, color: AppColors.primary, size: 20),
        onTap: onTap,
      ),
    );
  }
}

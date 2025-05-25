import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_icons.dart';
import '../../domain/entities/city.dart';

class CityListItem extends StatelessWidget {
  final City city;
  final VoidCallback onTap;

  const CityListItem({super.key, required this.city, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(AppIcons.location, color: AppColors.primary, size: 24),
        ),
        title: Text(
          city.name,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, color: AppColors.textSecondary, size: 16),
        onTap: onTap,
      ),
    );
  }
}

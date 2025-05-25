import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_icons.dart';

class HomeNoCityDataState extends StatelessWidget {
  const HomeNoCityDataState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(30),
        margin: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(AppIcons.error, size: 64, color: AppColors.error),
            SizedBox(height: 16),
            Text(
              'Şehir verisi bulunamadı',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.error),
            ),
            SizedBox(height: 8),
            Text(
              'Lütfen şehir ekleyin veya yeniden deneyin',
              style: TextStyle(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

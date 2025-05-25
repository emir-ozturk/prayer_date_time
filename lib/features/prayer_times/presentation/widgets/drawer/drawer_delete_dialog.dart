import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../bloc/prayer_times_bloc.dart';
import '../../bloc/prayer_times_event.dart';

class DrawerDeleteDialog extends StatelessWidget {
  final String districtId;
  final String cityName;

  const DrawerDeleteDialog({super.key, required this.districtId, required this.cityName});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: Row(
        children: [
          Icon(Icons.delete_outline, color: AppColors.error, size: 24),
          const SizedBox(width: 8),
          const Text('Şehri Kaldır'),
        ],
      ),
      content: Text('$cityName şehrini listeden kaldırmak istediğinizden emin misiniz?'),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('İptal')),
        ElevatedButton(
          onPressed: () {
            context.read<PrayerTimesBloc>().add(RemoveCity(districtId: districtId));
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.error,
            foregroundColor: Colors.white,
          ),
          child: const Text('Kaldır'),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prayer_date_time/core/extensions/string_extensions.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_icons.dart';
import '../../bloc/prayer_times_bloc.dart';
import '../../bloc/prayer_times_event.dart';
import 'drawer_delete_dialog.dart';

class DrawerCityItem extends StatelessWidget {
  final String districtId;
  final String cityName;
  final bool isSelected;

  const DrawerCityItem({
    super.key,
    required this.districtId,
    required this.cityName,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary.withValues(alpha: 0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.5)
              : AppColors.textHint.withValues(alpha: 0.2),
          width: isSelected ? 2 : 1,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            isSelected ? AppIcons.locationOn : AppIcons.location,
            color: isSelected ? Colors.white : AppColors.primary,
            size: 20,
          ),
        ),
        title: Text(
          cityName.toTitleCase,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? AppColors.primaryDark : AppColors.textPrimary,
            fontSize: 16,
          ),
        ),
        trailing: isSelected
            ? Icon(Icons.check_circle, color: AppColors.primary, size: 20)
            : IconButton(
                icon: Icon(Icons.delete_outline, color: AppColors.error, size: 20),
                onPressed: () => _showDeleteDialog(context),
              ),
        onTap: isSelected
            ? null
            : () {
                context.read<PrayerTimesBloc>().add(SelectCity(districtId: districtId));
                Navigator.of(context).pop();
              },
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => DrawerDeleteDialog(districtId: districtId, cityName: cityName),
    );
  }
}

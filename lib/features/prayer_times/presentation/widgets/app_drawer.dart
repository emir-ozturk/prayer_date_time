import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_icons.dart';
import '../bloc/prayer_times_bloc.dart';
import '../bloc/prayer_times_event.dart';
import '../bloc/prayer_times_state.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: BlocBuilder<PrayerTimesBloc, PrayerTimesState>(
        builder: (context, state) {
          return Column(
            children: [
              _buildHeader(),
              Expanded(child: _buildContent(context, state)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24) + const EdgeInsets.only(top: kToolbarHeight),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 14,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(AppIcons.cities, color: Colors.white, size: 32),
          ),
          const Text(
            'Şehirler',
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, PrayerTimesState state) {
    if (state is! PrayerTimesLoaded) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.citiesPrayerTimes.isEmpty) {
      return _buildEmptyState();
    }

    return _buildCityList(context, state);
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(AppIcons.addLocation, size: 64, color: AppColors.textSecondary.withOpacity(0.5)),
            const SizedBox(height: 16),
            Text(
              'Henüz şehir eklenmemiş',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Ana sayfadaki + butonunu kullanarak şehir ekleyebilirsiniz',
              style: TextStyle(fontSize: 14, color: AppColors.textHint),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCityList(BuildContext context, PrayerTimesLoaded state) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        SizedBox(),
        ...state.citiesPrayerTimes.entries.map((entry) {
          final districtId = entry.key;
          final prayerTimes = entry.value;

          if (prayerTimes.isEmpty) return const SizedBox.shrink();

          final cityName = prayerTimes.first.districtName;
          final isSelected = state.selectedCityId == districtId;

          return _buildCityItem(context, districtId, cityName, isSelected);
        }),
      ],
    );
  }

  Widget _buildCityItem(BuildContext context, String districtId, String cityName, bool isSelected) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isSelected
              ? AppColors.primary.withOpacity(0.5)
              : AppColors.textHint.withOpacity(0.2),
          width: isSelected ? 2 : 1,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            isSelected ? AppIcons.locationOn : AppIcons.location,
            color: isSelected ? Colors.white : AppColors.primary,
            size: 20,
          ),
        ),
        title: Text(
          cityName,
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
                onPressed: () => _showDeleteDialog(context, districtId, cityName),
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

  void _showDeleteDialog(BuildContext context, String districtId, String cityName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
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
      ),
    );
  }
}

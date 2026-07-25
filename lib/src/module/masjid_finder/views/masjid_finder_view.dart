import 'package:al_muttaqee/l10n/app_localizations.dart';
import 'package:al_muttaqee/src/core/base/base_view.dart';
import 'package:al_muttaqee/src/core/constants/app_colors.dart';
import 'package:al_muttaqee/src/core/constants/app_textstyles.dart';
import 'package:al_muttaqee/src/core/shared/widgets/application_bar.dart';
import 'package:al_muttaqee/src/module/masjid_finder/controllers/masjid_finder_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';

class MasjidFinderView extends BaseView<MasjidFinderController> {
  @override
  PreferredSizeWidget? appBar(BuildContext context) =>
      ApplicationBar(appTitleText: AppLocalizations.of(context)!.masjidFinder);

  @override
  Widget body(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Obx(() {
      final center = controller.position.value;
      return Column(
        children: [
          Expanded(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(center.latitude, center.longitude),
                zoom: 13,
              ),
              myLocationEnabled: controller.locationAvailable.value,
              myLocationButtonEnabled: controller.locationAvailable.value,
              onMapCreated: (map) => _applyNightStyle(context, map),
              markers: controller.masjids
                  .map(
                    (m) => Marker(
                      markerId: MarkerId(m.id),
                      position: LatLng(m.latitude, m.longitude),
                      infoWindow: InfoWindow(title: m.name, snippet: m.address),
                    ),
                  )
                  .toSet(),
            ),
          ),
          if (controller.apiKeyMissing.value)
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                l10n.mapsApiKeyRequired,
                style: kFigtree400W14S.copyWith(color: AppColors.red600),
              ),
            ),
          SizedBox(
            height: 210,
            child: controller.masjids.isEmpty
                ? Center(child: Text(l10n.noNearbyMasjids, style: kFigtree400W14S))
                : ListView.separated(
                    padding: const EdgeInsets.all(12),
                    itemCount: controller.masjids.length,
                    separatorBuilder: (_, __) => const Divider(),
                    itemBuilder: (_, index) {
                      final masjid = controller.masjids[index];
                      return ListTile(
                        leading: const Icon(Icons.mosque, color: AppColors.brand600),
                        title: Text(masjid.name, style: kFigtree600W14S),
                        subtitle: Text(
                          '${masjid.address}\n${l10n.distanceKm(masjid.distanceKm.toStringAsFixed(1))}',
                          style: kFigtree400W12S,
                        ),
                        isThreeLine: true,
                        trailing: TextButton(
                          onPressed: () => controller.openDirections(masjid),
                          child: Text(l10n.openInMaps),
                        ),
                      );
                    },
                  ),
          ),
        ],
      );
    });
  }

  Future<void> _applyNightStyle(BuildContext context, GoogleMapController map) async {
    if (Theme.of(context).brightness == Brightness.dark) {
      await map.setMapStyle(await rootBundle.loadString('assets/map_styles/dark_map.json'));
    }
  }
}

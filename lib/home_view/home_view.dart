import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_naver_map_test/home_view/rivepod/home_view_riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  late NaverMapController mapController;

  @override
  Widget build(BuildContext context) {
    final positionAsyncValue = ref.watch(currentPositionProvider);

    return Scaffold(
      body: Stack(
        children: [
          positionAsyncValue.when(
            data: (position) {
              return NaverMap(
                onMapReady: (controller) {
                  mapController = controller;
                  WidgetsBinding.instance.addPostFrameCallback(
                    (_) {
                      mapController.setLocationTrackingMode(
                          NLocationTrackingMode.follow);
                    },
                  );
                },
                options: NaverMapViewOptions(
                  initialCameraPosition: NCameraPosition(
                    target: NLatLng(position.latitude, position.longitude),
                    zoom: 14,
                  ),
                  indoorEnable: true,
                  nightModeEnable: true,
                  locationButtonEnable: false,
                  logoClickEnable: false,
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(child: Text("Error: $error")),
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.25,
            maxChildSize: 0.8,
            minChildSize: 0.25,
            builder: (context, scrollController) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  FloatingActionButton(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.deepPurple,
                    onPressed: () async {
                      mapController.setLocationTrackingMode(
                        NLocationTrackingMode.follow,
                      );
                    },
                    child: const Icon(Icons.my_location),
                  ),
                  Container(
                    //width: MediaQuery.of(context).size.width,
                    // height: MediaQuery.of(context).size.width / 2,
                    clipBehavior: Clip.hardEdge,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(32),
                        topRight: Radius.circular(32),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

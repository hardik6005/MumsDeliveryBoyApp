import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:grocery_delivery_boy/common/models/track_body_model.dart';
import 'package:grocery_delivery_boy/common/models/api_response_model.dart';
import 'package:grocery_delivery_boy/common/models/response_model.dart';
import 'package:grocery_delivery_boy/common/reposotories/tracker_repo.dart';
import 'package:grocery_delivery_boy/helper/api_checker_helper.dart';

class TrackerProvider extends ChangeNotifier {
  final TrackerRepo? trackerRepo;
  TrackerProvider({required this.trackerRepo});

  final List<TrackBodyModel> _trackList = [];
  final int _selectedTrackIndex = 0;
  final bool _isBlockButton = false;
  final bool _canDismiss = true;
  bool _startTrack = false;
  Timer? _timer;

  List<TrackBodyModel> get trackList => _trackList;
  int get selectedTrackIndex => _selectedTrackIndex;
  bool get isBlockButton => _isBlockButton;
  bool get canDismiss => _canDismiss;
  bool get startTrack => _startTrack;

  void startLocationService() async {
    _startTrack = true;
    addTrack();
    if(_timer != null) {
      _timer!.cancel();
      _timer = null;
    }
    _timer = Timer.periodic(const Duration(seconds: 30), (timer) {
      addTrack();
    });
  }

  void stopLocationService() {
    _startTrack = false;
    if(_timer != null) {
      _timer!.cancel();
      _timer = null;
    }
    notifyListeners();
  }

  Future<ResponseModel?> addTrack() async {
    ResponseModel? responseModel;
    if (_startTrack) {
      Geolocator.getCurrentPosition().then((location) async {
        String locationText = 'demo';
        try {
          List<Placemark> placeMark = await placemarkFromCoordinates(location.latitude, location.longitude);
          Placemark address = placeMark.first;
          locationText = '${address.name ?? ''}, ${address.subAdministrativeArea ?? ''}, ${address.isoCountryCode ?? ''}';
        // ignore: empty_catches
        }catch(e) {
        }
        ApiResponseModel apiResponse = await trackerRepo!.addTrack(location.latitude, location.longitude, locationText);
        if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
          responseModel = ResponseModel(true, 'Successfully start track');
        } else {
          responseModel = ResponseModel(false, ApiCheckerHelper.getError(apiResponse).errors![0].message);
        }
      });
    } else {
      _timer!.cancel();
    }
    Future.delayed(const Duration(milliseconds: 100)).then((value) {
      notifyListeners();
    });
    return responseModel;
  }

  Future<bool> setOrderID(int orderID) async {
    return await trackerRepo!.setOrderID(orderID);
  }
}

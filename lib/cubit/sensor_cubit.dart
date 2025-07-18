import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:interview_project/enums/sort_order.dart';
import 'package:interview_project/model/sensor.dart';
import 'package:interview_project/repository/sensor_repository.dart';
import 'package:rxdart/rxdart.dart';

part 'sensor_state.dart';

class SensorCubit extends Cubit<SensorState> {
  final SensorRepository _sensorRepository;

  final _searchQueryController = BehaviorSubject<String>.seeded('');
  final _sortOrderController = BehaviorSubject<SortOrder>.seeded(
    SortOrder.none,
  );

  StreamSubscription? _sensorsSubscription;

  SensorCubit(this._sensorRepository) : super(SensorInitial());

  void initialize() {
    emit(SensorLoading());

    _sensorsSubscription =
        Rx.combineLatest3(
              _sensorRepository.sensorsStream,
              _searchQueryController.stream,
              _sortOrderController.stream,
              _processSensors,
            )
            .handleError((error) {
              emit(SensorError("An error occurred: $error"));
            })
            .listen((processedSensors) {
              emit(
                SensorLoaded(
                  displayedSensors: processedSensors,
                  sortOrder: _sortOrderController.value,
                ),
              );
            });

    _sensorRepository.initializeSensors();
  }

  List<Sensor> _processSensors(
    List<Sensor> sensors,
    String query,
    SortOrder sortOrder,
  ) {
    final filtered = query.isEmpty
        ? sensors
        : sensors.where((sensor) {
            final nameMatches = sensor.name.toLowerCase().contains(
              query.toLowerCase(),
            );
            final descMatches = sensor.description.toLowerCase().contains(
              query.toLowerCase(),
            );
            return nameMatches || descMatches;
          }).toList();

    if (sortOrder != SortOrder.none) {
      filtered.sort((a, b) {
        if (sortOrder == SortOrder.ascending) {
          return a.value.compareTo(b.value);
        } else {
          return b.value.compareTo(a.value);
        }
      });
    }

    return filtered;
  }

  void search(String query) {
    _searchQueryController.add(query);
  }

  void sort(SortOrder order) {
    _sortOrderController.add(order);
  }

  void updateSensorDetails(Sensor sensor) {
    _sensorRepository.updateSensor(sensor);
  }

  @override
  Future<void> close() {
    _searchQueryController.close();
    _sortOrderController.close();
    _sensorsSubscription?.cancel();
    return super.close();
  }
}

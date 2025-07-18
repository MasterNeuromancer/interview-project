part of 'sensor_cubit.dart';

sealed class SensorState extends Equatable {
  const SensorState();

  @override
  List<Object> get props => [];
}

final class SensorInitial extends SensorState {}

final class SensorLoading extends SensorState {}

final class SensorLoaded extends SensorState {
  final List<Sensor> displayedSensors;

  final SortOrder sortOrder;

  const SensorLoaded({
    required this.displayedSensors,
    this.sortOrder = SortOrder.none,
  });

  @override
  List<Object> get props => [displayedSensors, sortOrder];
}

final class SensorError extends SensorState {
  final String message;

  const SensorError(this.message);

  @override
  List<Object> get props => [message];
}

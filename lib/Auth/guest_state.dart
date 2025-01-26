part of 'guest_bloc.dart';

abstract class GuestState extends Equatable {
  const GuestState();

  @override
  List<Object> get props => [];
}

class GuestInitial extends GuestState {}

class GuestLoading extends GuestState {}

class GuestSuccess extends GuestState {}

class GuestFailure extends GuestState {
  final String error;

  const GuestFailure({required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'GuestFailure {error: $error }';
}

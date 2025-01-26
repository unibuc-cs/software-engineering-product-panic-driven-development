part of 'guest_bloc.dart';

abstract class GuestEvent extends Equatable {
  const GuestEvent();

  @override
  List<Object> get props => [];
}

class GuestButtonPressed extends GuestEvent {
  final BuildContext context;

  const GuestButtonPressed({required this.context});

  @override
  List<Object> get props => [context];

  @override
  String toString() => 'GuestButtonPressed';
}

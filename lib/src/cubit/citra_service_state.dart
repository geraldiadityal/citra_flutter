part of 'citra_service_cubit.dart';

abstract class CitraServiceState extends Equatable {
  const CitraServiceState();
}

class CitraServiceInitial extends CitraServiceState {
  @override
  List<Object> get props => [];
}class CitraServiceLoading extends CitraServiceState {
  @override
  List<Object> get props => [];
}


class CitraServiceLoaded extends CitraServiceState {
  final List<CitraService> citraService;

  CitraServiceLoaded(this.citraService);

  @override
  List<Object> get props => [citraService];
}

class CitraServiceFailed extends CitraServiceState {
  final String message;

  CitraServiceFailed(this.message);

  @override
  List<Object> get props => [message];
}

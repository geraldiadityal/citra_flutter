part of 'citra_partner_cubit.dart';

abstract class CitraPartnerState extends Equatable {
  const CitraPartnerState();
}

class CitraPartnerInitial extends CitraPartnerState {
  @override
  List<Object> get props => [];
}

class AllPartnerLoaded extends CitraPartnerState {
  final List<CitraPartner> allCitraPartner;

  AllPartnerLoaded(this.allCitraPartner);

  @override
  List<Object> get props => [allCitraPartner];
}

class AllPartnerFailed extends CitraPartnerState {
  final String message;

  AllPartnerFailed(this.message);

  @override
  List<Object> get props => [message];
}

class CitraPartnerLoaded extends CitraPartnerState {
  final List<CitraPartner> citraPartner;

  CitraPartnerLoaded(this.citraPartner);

  @override
  List<Object> get props => [citraPartner];
}

class CitraPartnerFailed extends CitraPartnerState {
  final String message;

  CitraPartnerFailed(this.message);

  @override
  List<Object> get props => [message];
}

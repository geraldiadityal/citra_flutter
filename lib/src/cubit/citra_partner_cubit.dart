import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:project_citra/src/models/models.dart';
import 'package:project_citra/src/services/services.dart';

part 'citra_partner_state.dart';


class CitraPartnerCubit extends Cubit<CitraPartnerState> {
  CitraPartnerCubit() : super(CitraPartnerInitial());

  Future<void> getAllPartner() async {
    ApiReturnValue<List<CitraPartner>> result =
        await CitraPartnerServices.getPartner();
    if (result.value != null) {
      emit(AllPartnerLoaded(result.value!));
    } else {
      emit(AllPartnerFailed(result.message));
    }
  }

  Future<List<CitraPartner>?> getPartnerWithService(int id) async {
    ApiReturnValue<List<CitraPartner>> result =
        await CitraPartnerServices.getPartnerByService(id);
    if (result.value != null) {
      emit(CitraPartnerLoaded(result.value!));
    } else {
      emit(CitraPartnerFailed(result.message));
    }
    return result.value;
  }
}

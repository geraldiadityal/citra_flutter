import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:project_citra/src/models/models.dart';
import 'package:project_citra/src/services/services.dart';

part 'citra_service_state.dart';

class CitraServiceCubit extends Cubit<CitraServiceState> {
  CitraServiceCubit() : super(CitraServiceInitial());

  Future<List<CitraService>?> getService() async {
    emit(CitraServiceLoading());
    ApiReturnValue<List<CitraService>> result =
        await CitraServiceServices.getService();

    if (result.value != null) {
      emit(CitraServiceLoaded(result.value!));
      return result.value;
    } else {
      emit(CitraServiceFailed(result.message));
      return null;
    }
  }
}

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:project_citra/src/models/models.dart';
import 'package:project_citra/src/services/services.dart';

part 'transaction_state.dart';

class TransactionCubit extends Cubit<TransactionState> {
  TransactionCubit() : super(TransactionInitial());

  Future<void> getTransactions() async {
    ApiReturnValue<List<Transaction>> result =
        await TransactionServices.getTransactions();

    if (result.value != null) {
      emit(TransactionLoaded(result.value!));
    } else {
      emit(TransactionLoadingFailed(result.message));
    }
  }

  Future<List<Transaction>> getTransactionsByStatus(
      {String status = "UNPAID", int? partnerId}) async {
    emit(TransactionLoading());
    ApiReturnValue<List<Transaction>> result =
        await TransactionServices.getTransactionsByStatus(
            transactionStatus: status, partnerId: partnerId);

    if (result.value != null) {
      emit(TransactionLoaded(result.value!));
      return result.value!;
    } else {
      emit(TransactionLoadingFailed(result.message));
      return [];
    }
  }

  Future<String?> submitTransaction(CitraPartner partner, User user) async {
    ApiReturnValue<Transaction> result =
        await TransactionServices.submitTransaction(partner, user);

    if (result.value != null) {
      emit(TransactionLoaded(
          (state as TransactionLoaded).transactions + [result.value!]));
      return result.value!.paymentUrl;
    } else {
      emit(TransactionLoadingFailed(result.message));
      return 'null';
    }
  }
}

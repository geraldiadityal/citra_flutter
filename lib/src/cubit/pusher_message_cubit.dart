import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:project_citra/src/models/models.dart';
import 'package:project_citra/src/services/services.dart';
import 'package:pusher_client/pusher_client.dart';

part 'pusher_message_state.dart';

class PusherMessageCubit extends Cubit<PusherMessageState> {
  PusherMessageCubit() : super(PusherMessageInitial());

  void getFetchMessage({required int sessionChatId}) async {
    emit(PusherMessageLoading());

    ApiReturnValue<List<PusherMessage>> result =
        await PusherMessageServices.fetchMessage(sessionChatId: sessionChatId);

    if (result.value != null) {
      emit(PusherMessageSuccess(result.value!));
    } else {
      emit(PusherMessageFailed(result.message));
    }
  }

  Future<void> initPusher({required int sessionChatId}) async {
    PusherClient? pusher;
    Channel? channel;
    // PusherAuth pusherAuth = PusherAuth(
    //   '${apiUrl}broadcasting/auth',
    //   headers: {
    //     'Authorization': 'Bearer ${User.token}',
    //   },
    // );
    pusher = PusherClient(
      tokenPusher,
      PusherOptions(
        cluster: 'ap1',
        // auth: pusherAuth,
      ),
    );

    channel = pusher.subscribe('Chat.$sessionChatId');

    pusher.onConnectionStateChange((state) {
      print(
          "previousState: ${state?.previousState}, currentState: ${state?.currentState}");
    });

    pusher.onConnectionError((error) {
      print("error: ${error!.message}");
    });

    channel.bind('App\\Events\\PrivateChatEvent', (PusherEvent? event) {
      PusherMessage pusherMessage =
          PusherMessage.fromPusherJson(jsonDecode(event!.data!));
      emit(
        PusherMessageSuccess(
          (state as PusherMessageSuccess).pusherMessage + [pusherMessage],
        ),
      );
    });
  }
}

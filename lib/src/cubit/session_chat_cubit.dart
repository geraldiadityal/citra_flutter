import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:project_citra/src/models/models.dart';
import 'package:project_citra/src/services/services.dart';
import 'package:pusher_client/pusher_client.dart';

part 'session_chat_state.dart';

class SessionChatCubit extends Cubit<SessionChatState> {
  SessionChatCubit() : super(SessionChatInitial());

  void getSessionChat() async {
    ApiReturnValue<List<SessionChat>> result =
        await SessionChatServices.getSessionRoomChat();

    if (result.value != null) {
      emit(SessionChatLoaded(result.value!));
    } else {
      emit(SessionChatFailed(result.message));
    }
  }

  void initSessionPusher({required int id}) async {
    PusherClient? pusher;
    Channel? channel;

    pusher = PusherClient(
      tokenPusher,
      PusherOptions(
        cluster: 'ap1',
        // auth: pusherAuth,
      ),
    );

    channel = pusher.subscribe('SessionChat.$id');

    pusher.onConnectionStateChange((state) {
      print(
          "previousState: ${state?.previousState}, currentState: ${state?.currentState}");
    });

    pusher.onConnectionError((error) {
      print("error: ${error!.message}");
    });

    channel.bind('App\\Events\\SessionChatEvent', (PusherEvent? event) {
      getSessionChat();
    });
  }
}

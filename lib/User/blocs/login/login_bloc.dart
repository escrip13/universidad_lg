import 'package:universidad_lg/User/models/user.dart';
import 'package:universidad_lg/User/services/secure_storage.dart';
import 'package:bloc/bloc.dart';
import 'login_event.dart';
import 'login_state.dart';
import '../authentication/authentication.dart';
import '../../exceptions/exceptions.dart';
import '../../services/services.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthenticationBloc _authenticationBloc;
  final AuthenticationService _authenticationService;

  LoginBloc(AuthenticationBloc authenticationBloc,
      AuthenticationService authenticationService)
      : assert(authenticationBloc != null),
        assert(authenticationService != null),
        _authenticationBloc = authenticationBloc,
        _authenticationService = authenticationService,
        super(LoginInitial());

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginInWithEmailButtonPressed) {
      yield* _mapLoginWithEmailToState(event);
    }

    if (event is CodigoValidateButtonPressed) {
      yield* _mapLoginCodigoState(event);
    }
  }

  Stream<LoginState> _mapLoginWithEmailToState(
      LoginInWithEmailButtonPressed event) async* {
    yield LoginLoading();
    try {
      final user = await _authenticationService.signInWithEmailAndPassword(
          event.email, event.password);
      if (user != null) {
        // _authenticationBloc.add(UserLoggedIn(user: user));
        _authenticationBloc.add(UserLoggedCodigo(user: user));
        yield LoginSuccess();
        yield LoginInitial();
      } else {
        yield LoginFailure(error: 'Something very weird just happened');
      }
    } on AuthenticationException catch (e) {
      yield LoginFailure(error: e.message);
    } catch (err) {
      yield LoginFailure(error: err.message ?? 'An unknown error occured');
    }
  }

  Stream<LoginState> _mapLoginCodigoState(
      CodigoValidateButtonPressed event) async* {
    yield LoginLoading();
    try {
      String userCodeStorage = await UserSecureStorage.getLoginCodigo();
      if (userCodeStorage == event.codigo) {
        final token = await UserSecureStorage.getLoginToken();
        final name = await UserSecureStorage.getNombre();
        final uid = await UserSecureStorage.getUserId();
        final email = await UserSecureStorage.getEmail();
        await UserSecureStorage.setIslogin('login');
        User user = User(name: name, email: email, userId: uid, token: token);

        _authenticationBloc.add(UserLoggedIn(user: user));

        yield LoginSuccess();
        yield LoginInitial();
      } else {
        yield LoginFailure(error: 'Codigo no valido');
      }
    } on AuthenticationException catch (e) {
      yield LoginFailure(error: e.message);
    } catch (err) {
      yield LoginFailure(error: err.message ?? 'Un error desconocido ocurrió');
    }
  }
}

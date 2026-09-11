# Convenciones de nombres

**Capa data**
- Data source (contrato): `<feature>_data_source.dart` → `abstract class <Feature>DataSourceContract`
- Data source (implementación): `<feature>_remote_data_source.dart` / `<feature>_local_data_source.dart` según origen. Devuelve datos "en crudo" o lanza excepciones — **no** devuelve `Result` (eso se maneja en el repositorio).
- Modelos/DTOs: `<entity>_remote_entity.dart`
- Repositorio (implementación): `<feature>_repository_impl.dart`. Envuelve la llamada al data source con un helper `_handleError`, que captura la excepción, la mapea con `ErrorsMapper` y devuelve `Result<T, AppError>`:
  ```dart
  @override
  Future<Result<void, AppError>> login(String email, String pass) async {
    return _handleError(() async {
      await _authDataSource.login(email, pass);
    });
  }
  ```

**Capa domain**
- Entidades: nombre simple, ej. `car.dart`, `order.dart`, `photo.dart`, `user.dart`
- Repositorio (contrato): `<feature>_repository.dart` → `abstract class <Feature>RepositoryContract`
- Casos de uso: `<accion>_use_case.dart`, con patrón Contract + Impl y clase invocable (`call()`):
  ```dart
  abstract class LoginUseCaseContract {
    Future<Result<void, AppError>> call(String email, String pass);
  }

  class LoginUseCase implements LoginUseCaseContract {
    LoginUseCase(this._authRepository);
    final AuthRepositoryContract _authRepository;

    @override
    Future<Result<void, AppError>> call(String email, String pass) async {
      return _authRepository.login(email, pass);
    }
  }
  ```
  Se invocan desde el Bloc como `_loginUseCase.call(...)` (o `_loginUseCase(...)` al ser invocable).

**Capa presentation**
- Bloc: siempre en su propia carpeta `bloc/`, nunca suelto junto a la page o el widget. Dentro: `<feature>_bloc.dart` (+ `<feature>_event.dart`, `<feature>_state.dart`, con Freezed). Ej. `features/auth/presentation/bloc/auth_bloc.dart`. Esto aplica también a widgets compartidos con estado propio (ver más abajo): `features/widgets/text_fields/bloc/custom_text_field_bloc.dart`.
- El estado tiene un campo `status` (enum propio del feature: ej. `LoginStatus.initial/loading/success/error`) y un campo `error` de tipo `AppError?`. Se actualiza con `copyWith`.
- En el constructor, un único `on<XxxEvent>` (el evento sellado del feature, no cada subtipo por separado) que despacha con `switch` a los handlers privados `_onXxx`:
  ```dart
  LoginBloc(this._loginUseCase) : super(const LoginState()) {
    on<LoginEvent>((event, emit) {
      return switch (event) {
        UpdateEmail() => _onUpdateEmail(event, emit),
        UpdatePassword() => _onUpdatePassword(event, emit),
        Login() => _onLogin(event, emit),
        ShowPassword() => _onShowPassword(event, emit),
      };
    });
  }
  ```
- Los handlers de evento consultan el `Result` devuelto por el caso de uso con `result.isSuccess` / `result.isFailure` / `result.error`:
  ```dart
  Future<void> _onLogin(Login event, Emitter<LoginState> emit) async {
    emit(state.copyWith(status: LoginStatus.loading));
    final result = await _loginUseCase.call(state.email, state.pass);
    if (result.isSuccess) {
      emit(state.copyWith(status: LoginStatus.success));
    }
    if (result.isFailure) {
      emit(state.copyWith(status: LoginStatus.error, error: result.error));
    }
  }
  ```
- Page: `<feature>_page.dart`
- Widgets compartidos: `custom_<nombre>.dart`, ej. `custom_elevated_button.dart`, `custom_linear_progress_indicator.dart`

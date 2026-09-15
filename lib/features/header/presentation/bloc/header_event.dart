import 'package:freezed_annotation/freezed_annotation.dart';

part 'header_event.freezed.dart';

@freezed
sealed class HeaderEvent with _$HeaderEvent {
  const factory HeaderEvent.started() = HeaderStarted;
  const factory HeaderEvent.searchQueryChanged(String query) =
      HeaderSearchQueryChanged;
  const factory HeaderEvent.searchCleared() = HeaderSearchCleared;
  const factory HeaderEvent.mobileMenuOpened() = HeaderMobileMenuOpened;
  const factory HeaderEvent.mobileMenuClosed() = HeaderMobileMenuClosed;
  const factory HeaderEvent.mobileSearchOpened() = HeaderMobileSearchOpened;
  const factory HeaderEvent.mobileSearchClosed() = HeaderMobileSearchClosed;
  const factory HeaderEvent.sessionEnded() = HeaderSessionEnded;
  const factory HeaderEvent.cartItemsIncremented(int quantity) =
      HeaderCartItemsIncremented;
}

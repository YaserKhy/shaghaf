part of 'navigation_bloc.dart';

@immutable
sealed class NavigationState {}

final class NavigationInitial extends NavigationState {}

// final class PageInitial extends NavigationState {}

final class SwitchScreenState extends NavigationState {}
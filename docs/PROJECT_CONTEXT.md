# Project Context

## Purpose

LoginShell is a Flutter desktop shell intended to host authentication, authorized menus, connection profile management, local control data, and future operational modules backed by an external database.

## Shell-First Approach

The application opens into a persistent shell, not directly into a login screen.

- The top bar manages global actions.
- The center area changes according to the selected section.
- The bottom bar carries application status.
- The default opening state is InfoView.

## Top Bar Responsibilities

- Home returns the center area to InfoView.
- Theme toggles light and dark mode.
- User opens LoginView.
- Settings opens SettingsView.
- Safe Exit opens a confirmation dialog and closes the app on approval.

## Center Area Structure

- `InfoView`: introduction and information area
- `LoginView`: user authentication screen
- `AuthorizedMenuView`: post-login authorized menu area
- `SettingsView`: connection profile management and connection test area

## Data Direction

Planned Isar local control layer:

- user records
- connection profiles
- authorized menus
- session information
- app settings
- theme preference
- last active profile and last active section

Planned main external database layer:

- operational business data
- transactional records
- work tables
- reporting data

## Current Checkpoint

- Shell-first frame is working.
- Mock login flow is working.
- Authorized menu flow is working.
- Settings and connection profile management flow is working.
- Repository and contract abstraction replaced direct mock access from views.
- Session and app settings models are present.
- Settings-side overflow is known and intentionally postponed.

## Red Lines

- The top bar must not be broken.
- The bottom bar must not be broken.
- Neumorphic and soft UI texture must be preserved.
- Provider must not be added.
- NavigationService-style legacy flow must not return.
- Dashboard and chart chain must not be brought back in this phase.

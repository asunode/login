# Project Context

## Purpose

LoginShell is a Flutter desktop shell intended to host authentication, authorized menus, connection profile management, local control data, and future operational modules backed by an external database.

## Shell-First Approach

The application opens into a persistent shell, not directly into a login screen.

- The top bar manages global actions.
- The center area changes according to the selected section.
- The bottom bar carries status and session visibility feedback.
- The default opening state is InfoView.

This shell-first structure is being extended gradually without replacing the current UI language or introducing a larger state architecture.

## Main UI Responsibilities

- Top bar: Home, theme toggle, login entry, settings, safe exit
- Center area: InfoView, LoginView, AuthorizedMenuView, SettingsView
- Bottom bar: active section status, locked/open session visibility, version info
- Left title capsule: shell root navigation shortcut based on authentication state

## Login Flow

- The user action in the top bar opens LoginView.
- The login screen remains intentionally simple.
- The login form contains username, password, and password visibility toggle behavior.
- Password rule guidance is intentionally not part of the login screen in this phase.
- Successful login opens AuthorizedMenuView.

## Session and Bottom Bar Connection

- Session information is created after successful authentication.
- The shell keeps the session object in local state for current UI visibility needs.
- The bottom bar reads session-backed state to show whether a session is locked or open.
- After login, the bottom bar also shows the authenticated username.
- This keeps session visibility tied to the session layer instead of treating it as a direct auth-only shortcut.

## Root Navigation and User Slot Behavior

- Before authentication, the left title capsule uses `Login` as the root title.
- After authentication, the same capsule uses the authenticated user's display name as the root title.
- Tapping the left title capsule returns to the login root when no session exists.
- Tapping the left title capsule returns to the authenticated user's authorized menu root when a session exists.
- The top bar user slot shows the user action before authentication.
- After authentication, that same slot becomes the logout action.
- This keeps the top bar simpler by avoiding a second separate logout button.

## Logout and Safe Exit Separation

- Logout is a session-level action and now requires confirmation.
- On confirmed logout, session data is cleared, current user state is cleared, authorized menu state is cleared, and the shell returns to `LoginView`.
- If logout is cancelled, the user remains in the current location.
- Safe exit remains a separate application-level action for closing the app.

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
- Password visibility toggle behavior was added to the login form.
- Bottom bar session visibility was added without redesigning the existing bar.
- Root title behavior now uses `Login` before authentication and the user's display name after authentication.
- Left title capsule root navigation behavior is present.
- Top bar user slot now changes into logout after authentication.
- Logout confirmation behavior is present and returns the shell to the login root when approved.
- Safe exit remains distinct from logout.
- The current neumorphic / soft feel and controlled growth approach were preserved.
- Settings-side overflow is known and intentionally postponed.

## Architecture Notes

- Provider was not added.
- No new state management structure was introduced.
- The bottom bar was extended, not rebuilt.
- The shell root behavior was updated without introducing a new navigation service.
- The current top bar structure was simplified rather than expanded with duplicate actions.
- `login_view.dart` was not changed unnecessarily in this checkpoint.

## Red Lines

- The top bar must not be broken.
- The bottom bar must not be broken.
- Neumorphic and soft UI texture must be preserved.
- Provider must not be added.
- NavigationService-style legacy flow must not return.
- Dashboard and chart chain must not be brought back in this phase.

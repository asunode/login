# LoginShell

LoginShell is a shell-first Flutter desktop application core for authentication, authorized menus, connection profile management, local control data, and future external database integration.

## Project Summary

The application does not open directly into a login screen. It starts with a persistent shell layout:

- top bar for global actions
- center area for active content
- bottom bar for status and session feedback
- InfoView as the default opening content

This structure is being expanded in a controlled way for login, authorized navigation, connection profile management, local control data, and future operational modules.

## Current Architecture

- Shell-first layout remains the main application frame.
- The top bar controls Home, theme toggle, login entry, settings, and safe exit.
- The center area switches between Info, Login, Authorized Menu, and Settings views.
- The bottom bar carries both section status and session visibility feedback.
- Mock data is not consumed directly by views.
- Repository and contract layers sit between presentation and mock data sources.
- Local control data is planned for Isar in a later phase.
- External business and operational data is planned for a separate main database.

## Working Features

- Application opens on Windows desktop with the shell layout.
- Top bar actions are active.
- Bottom bar is active.
- Light and dark theme switching works.
- LoginView opens from the user action.
- Mock authentication flow works.
- AuthorizedMenuView opens after successful login.
- SettingsView opens from the settings action.
- Mock connection profiles can be listed, added, edited, activated, and tested.
- Safe exit confirmation dialog works.
- The login form includes a password visibility toggle.
- The login screen remains intentionally minimal.
- The bottom bar reflects locked or open session state.
- The bottom bar shows the authenticated username after login.

## Current Checkpoint

- Password visibility toggle was added to the login form.
- The login screen was kept minimal and password rule guidance was not added there.
- The bottom bar was extended without redesigning its existing structure.
- Locked session state is shown when no login is active.
- Open session state and username are shown after successful login.
- Session data is connected to the bottom bar through shell state and session layer usage.
- The right-side info text now reads `ASUNODE LoginShell v0.1.0`.
- The current neumorphic / soft UI feel and controlled architecture approach were preserved.
- The known overflow in the settings profile form still exists and remains intentionally deferred.

## Local Control Data vs External Data

Planned local control data scope:

- users
- connection profiles
- authorized menus
- session data
- application settings
- theme preference
- last active profile and last active section

Planned external database scope:

- daily operational data
- core business records
- transaction tables
- reporting data

SettingsView is for profile management and connection checks. It is not the future main operational data screen.

## Architecture Notes

- Provider was not added.
- No new state management structure was introduced.
- The shell-first structure was preserved.
- The bottom bar was expanded on top of the existing layout instead of being redesigned.
- Session visibility is aligned with the session layer rather than being treated as raw auth-only UI state.
- `login_view.dart` was intentionally left unchanged in this checkpoint.

## Next Notes

- The top bar title currently still shows `SWorld`.
- Changing that title to `Login` remains a later technical debt item, not part of this checkpoint.

## Documentation

- [Project Context](docs/PROJECT_CONTEXT.md)
- [Roadmap](docs/ROADMAP.md)
- [Tasks](docs/TASKS.md)
- [Changelog](docs/CHANGELOG.md)

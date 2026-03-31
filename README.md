# LoginShell

LoginShell is a shell-first Flutter desktop application for authentication, authorized menus, settings, local control data, and future external database integration.

## Project Summary

The application does not open directly into a login screen. It starts with a persistent shell layout:

- top bar for global actions
- center area for active content
- bottom bar for status information
- InfoView as the default opening content

This structure is intended to grow into a controlled desktop shell for login, authorized navigation, connection profile management, local control data, and future operational modules.

## Current Architecture

- Shell-first layout is the main application frame.
- The top bar controls Home, theme toggle, login entry, settings, and safe exit.
- The center area switches between Info, Login, Authorized Menu, and Settings views.
- The bottom bar provides application status feedback.
- Mock data is no longer consumed directly by views.
- Repository and contract layers now sit between presentation and mock data sources.
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

## Current Checkpoint

- Shell-first application frame is in place.
- Mock login and authorized menu flow is in place.
- Settings profile management flow is in place.
- Repository and contract abstraction has been added.
- Session and app settings models have been added.
- Direct mock access from views has been removed.
- A known overflow exists in the settings profile form area and is intentionally deferred for a later UI pass.

## Next Steps

- Add password visibility toggle to the login form.
- Add locked/unlocked session state indicator to the bottom bar.
- Show the logged-in username in the bottom bar after authentication.
- Keep the login screen minimal.
- Reserve password rule guidance for future password creation, change, and reset screens.

## Notes

- The repository name may remain `login`, but the project should be described as `LoginShell`.
- This checkpoint focuses on architecture alignment and documentation, not UI redesign.

## Documentation

- [Project Context](docs/PROJECT_CONTEXT.md)
- [Roadmap](docs/ROADMAP.md)
- [Tasks](docs/TASKS.md)
- [Changelog](docs/CHANGELOG.md)

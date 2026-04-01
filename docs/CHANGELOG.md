# Changelog

## 2026-04-01

- Added password visibility toggle behavior to the login form.
- Kept the login screen intentionally minimal.
- Did not add password rule guidance to the login screen in this checkpoint.
- Extended the bottom bar with session visibility feedback without redesigning the existing structure.
- Added locked session state feedback for the no-login state.
- Added open session state and username visibility after successful login.
- Connected bottom bar session visibility through shell state and session-layer usage.
- Updated the bottom-right info text to `ASUNODE LoginShell v0.1.0`.
- Preserved the shell-first structure, current neumorphic / soft UI feel, and controlled architecture approach.
- Left the known settings-side `connection_profile_form` overflow deferred.

## 2026-03-31

- Shell-first application structure is active and opens with the persistent shell layout.
- Mock login and authorized menu flow has been established.
- Settings profile management flow has been established.
- Repository and contract abstraction has been added.
- Session and app settings models have been added.
- Direct mock access from views has been removed.
- Settings-side overflow is known and intentionally deferred in this checkpoint.

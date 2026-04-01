# Changelog

## 2026-04-01

- Login shell root title now uses `Login` before authentication and the user's display name after authentication.
- Left title capsule root navigation behavior was added.
- Top bar user slot now transforms into logout after authentication.
- Logout confirmation dialog was added.
- Confirmed logout now clears session, current user, and authorized menu state and returns the shell to `LoginView`.
- Safe exit remains separate from logout.
- `SWorld` to `Login` root title migration was completed.
- Password visibility toggle behavior remains part of the login form.
- Bottom bar session visibility remains connected through shell state and session-layer usage.
- Bottom-right info text remains `ASUNODE LoginShell v0.1.0`.
- Current neumorphic / soft UI feel and controlled shell-first architecture were preserved.
- Settings-side `connection_profile_form` overflow remains deferred.

## 2026-03-31

- Shell-first application structure is active and opens with the persistent shell layout.
- Mock login and authorized menu flow has been established.
- Settings profile management flow has been established.
- Repository and contract abstraction has been added.
- Session and app settings models have been added.
- Direct mock access from views has been removed.
- Settings-side overflow is known and intentionally deferred in this checkpoint.

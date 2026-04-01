# Tasks

## Done

- Shell-first application frame was established.
- Top bar and bottom bar are active.
- Theme switching is working.
- LoginView flow is connected.
- Mock authentication flow is working.
- Authorized menu flow is working.
- SettingsView and mock connection profile management flow are working.
- Repository and contract layers were added between views and mock data.
- Session and app settings model backbone was added.
- Password visibility eye toggle was added to the login form.
- The login screen was kept minimal in this checkpoint.
- Password rule guidance was intentionally kept out of the login screen.
- Bottom bar session visibility was added.
- Locked session state is shown when no login is active.
- Open session state and username are shown after successful login.
- Bottom bar session visibility is connected through shell state and session usage.
- Bottom-right info text was updated to `ASUNODE LoginShell v0.1.0`.
- Left title capsule root navigation is clickable.
- The shell root title uses `Login` before authentication and the user's display name after authentication.
- The authenticated user slot changes into logout action.
- Logout confirmation dialog was added.
- Confirmed logout clears session, current user, and authorized menu state and returns to `LoginView`.
- Safe exit remains separate from logout.
- `SWorld` to `Login` root title migration was completed.

## Current

- Preserve the current shell-first structure without disturbing UI language.
- Preserve the neumorphic / soft UI character while making small scoped changes.
- Maintain repository and contract separation as the current data access rule.
- Keep SettingsView focused on profile management and connection testing, not operational data loading.

## Next

- prepare password creation, password change, and password reset flows separately from login
- continue aligning local session usage with later persistence planning
- continue expanding authenticated shell behavior in small, controlled steps

## Deferred / Known

- the known overflow in the settings `connection_profile_form` remains deferred for a later pass
- this item was not a primary target in the current checkpoint

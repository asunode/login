# Roadmap

## Phase 0: Shell Transfer

Base desktop shell structure was moved into the project and used as the working foundation.

## Phase 1: Shell-First Opening

The application opens with the shell structure instead of opening directly into login.

## Phase 2: Top Bar Behaviors

Home, theme, user, settings, and safe exit flows were connected into the shell.

## Phase 3: Login and Session Visibility

Completed in the current checkpoint:

- password visibility toggle was added to the login form
- the login screen remained intentionally minimal
- password rule guidance was not added to the login screen
- bottom bar session indicator was added
- locked state is shown when no login is active
- open session state and username are shown after successful login
- session data is surfaced through shell state and session layer usage
- left root title now uses `Login` before authentication and the user's display name after authentication
- left title capsule root navigation behavior was added
- top bar user slot now becomes logout after authentication
- logout confirmation flow was added
- confirmed logout clears session, user, and menu state and returns the shell to `LoginView`
- safe exit remains separate from logout
- bottom-right info text was updated to `ASUNODE LoginShell v0.1.0`
- `SWorld` to `Login` root title migration is complete

## Phase 4: Authorized Menus

Successful login opens the user-specific authorized menu area.

## Phase 5: Settings and Connection Profiles

Profile listing, add, edit, activate, and test flows are available and remain focused on profile management rather than operational data loading.

## Phase 6: Isar Local Control Layer

Local users, profiles, settings, and session information are planned to move into persistent Isar-based storage in a later phase.

## Phase 7: Authorization and Menu Scope

Authorization mapping, user-specific menu scope, and stronger local control models remain planned.

## Phase 8: Main Database Connection

Controlled connection to the external operational database remains planned.

## Phase 9: Operational Modules

Main business modules that consume operational data are planned to be added into the shell later.

## Phase 10: Security and Hardening

Authentication, storage, access control, and production hardening remain future work.

## Next Likely Steps

- continue keeping the shell-first structure stable while expanding behavior carefully
- prepare later password creation / change / reset flows separately from login
- carry session-backed local control behavior toward future persistence work
- continue strengthening authenticated shell behavior without widening the architecture unnecessarily

## Deferred and Known

- the `connection_profile_form` overflow on the settings side remains known
- it was not a target of this checkpoint and should not be treated as newly completed work

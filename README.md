# The Circle Utility

A modern PowerShell WPF utility with secure, admin-controlled access and user profiles.

## Setup

1. Download or clone this repo.
2. Place your real `keys.json` and `profiles.json` in the same folder as `CircleUtility.ps1`.
   - Use `keys_template.json` and `profiles_template.json` as a starting point.
3. Run `CircleUtility.ps1` in PowerShell.

## Admin Controls

- To add a new user, add a one-time key to `keys.json` under `"valid_keys"`.
- To revoke access, remove the user from `profiles.json`.
- Only you (the admin) should have access to the real keys and profiles files.

## User Flow

- On first launch, user enters a one-time key and creates a profile.
- The key is marked as used and cannot be reused.
- On subsequent launches, the user logs in with their profile.

## Security

- Do NOT commit real `keys.json` or `profiles.json` with sensitive data to a public repo.
- Distribute keys securely to users.

## Requirements

- PowerShell 5.1 or later
- Windows 10 or later #   C i r c l e U t i l i t y  
 #   C i r c l e U t i l i t y  
 
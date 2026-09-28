
# (27/09/2026)

PKCE AND OATH CONCEPTIAL FLOW

Generate verifier
      ↓
Hash it → challenge
      ↓
Generate state
      ↓
Send challenge + state to GitHub
      ↓
User authorizes
      ↓
GitHub returns code + state
      ↓
Verify returned state
      ↓
Exchange:
code + original verifier + app credentials
      ↓
Receive user token



-------------------------------------------------------------------------------------------------

Do a tiny OAuth + PKCE test first. Generate a verifier/challenge/state, open GitHub's authorization page, authorize your own account, catch the 127.0.0.1 callback, then exchange the returned code for a ghu_... user access token. GitHub currently requires the client ID, client secret and authorization code for that exchange; because we're using PKCE, we'll also provide the original verifier. GitHub Docs

Test the token against GitHub GraphQL. Before touching our existing grid, we'll ask GitHub for your contribution calendar. This is also where we test our big security question: with the GitHub App currently configured with essentially no permissions, exactly what contribution information can we retrieve? If private aggregate contributions don't work, we'll establish the smallest additional read-only permission necessary rather than guessing.

Prove our permission boundary. We want to end up knowing exactly what the token can access, rather than just knowing that the query works. GitHub App user tokens are constrained by the intersection of what the app is permitted to access and what the user can access. GitHub Docs

Then build the real Swift auth layer. Once we've proved the flow manually, we'll understand what we're implementing: Connect GitHub → browser → GitHub → loopback callback → token exchange → Keychain. GitHub specifically recommends PKCE for native/public clients because the shipped client secret can't truly be kept confidential. GitHub Docs

Then connect it to the widget. GraphQL's contribution dates/counts feed the date mapping you've already built, totalContributions replaces the temporary title number, and we add caching/refresh behaviour.

Finally handle the production stuff: refresh tokens, token expiry, logout/revoke behaviour, errors, offline/cache behaviour, documentation, and packaging the client secret appropriately. GitHub's expiring user tokens default to 8 hours and come with a refresh token, so users shouldn't need to repeatedly sign in.




----------------------------------------------------------------
GitTracker should have no ability to alter the user's GitHub content wherever GitHub's permission model allows us to enforce that.

1. Register GitTracker as a GitHub App
              ↓
2. Configure the absolute minimum permissions
              ↓
3. Install/authorize GitTracker on YOUR GitHub account
              ↓
4. Obtain a test authentication token
              ↓
5. Send the exact GraphQL query GitTracker will eventually use
              ↓
6. Check what contribution data comes back
              ↓
7. Specifically test:
   • public contributions
   • private contribution COUNTS
   • no private repository contents
   • no write capabilities
              ↓
8. Adjust permissions ONLY if something required doesn't work
              ↓
9. Repeat until we've found our minimum permission set
              ↓
10. Lock that permission design in
              ↓
11. Build the OAuth/PKCE flow in Swift
              ↓
12. Connect GraphQL data → our existing widget

----------------------------------------------
# (26/09/2026)

# Git hub connecting conceptial arcitecture

GitTracker macOS app
       │
       │  Connect GitHub
       ▼
GitHub authorization
       │
       │  user approves access
       ▼
GitTracker receives user access token
       │
       ▼
GitHub GraphQL API
       │
       ▼
contributionCalendar
       │
       ▼
Our Swift models
       │
       ▼
Match GitHub date → squareDate
       │
       ▼
Colour each square




---------------------------------------------------------------------------------
Pinned month remains while the next month label is at column 2 or farther right.
When the next month label reaches column 1, remove the pinned month.

The outgoing label gets clamped to column 0. It remains there while the next month's anchor is at column 2 or greater. When that next anchor reaches column 1, the outgoing label disappears.
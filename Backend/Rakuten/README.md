# Rakuten provider

Rakuten credentials belong on the Viora backend only.

Environment variables:
- RAKUTEN_CLIENT_ID
- RAKUTEN_CLIENT_SECRET
- RAKUTEN_SID

Never commit their values.

Flow:
1. Backend obtains a short-lived Bearer token from Rakuten.
2. Backend calls Product Search.
3. XML results are normalized into Viora's Product JSON.
4. iOS receives only normalized product data and tracked product URLs.

The iOS app must never receive the Rakuten Client Secret.

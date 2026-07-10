### Data: Firebase (Firestore)

- Firestore is NoSQL/document — model for your read patterns; denormalize deliberately
  rather than forcing relational joins. Document the shape of each collection in code.
- **Security Rules are the authorization layer** and must be written and tested for every
  collection. The client SDK talks straight to the DB — client code cannot be trusted;
  rules enforce access. Update rules in the same change as new collections.
- Use the Admin SDK only server-side (it bypasses rules). Client uses the web SDK.
- Watch cost/perf: avoid unbounded queries, paginate, and be aware every document read
  is billable. Use composite indexes where queries need them.
- Config values (apiKey etc.) are public identifiers, not secrets — but service-account
  credentials ARE secret and stay server-side.

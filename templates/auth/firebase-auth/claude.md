### Auth: Firebase Auth

- Client signs in with the web SDK and gets an ID token. For any privileged server work,
  verify that token with the Admin SDK (`verifyIdToken`) — don't trust a uid sent from
  the client.
- Firestore/Storage Security Rules should reference `request.auth.uid` to enforce access;
  auth + rules work together. Write and test rules alongside auth changes.
- Use custom claims for roles/permissions; set them via the Admin SDK server-side and
  re-check on the server.
- Admin/service-account credentials are secret and server-only; the client config is not.

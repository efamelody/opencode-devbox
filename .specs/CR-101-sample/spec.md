# CR-101: Implement Rate Limiting Middleware

- **Target Project:** `nextjs-app`
- **Assigned Skill:** `security-audit`

## Requirements
1. Intercept incoming requests on `/api/*`.
2. Return HTTP 429 Too Many Requests when IP rate limit is exceeded.

## Acceptance Criteria
- Unit tests verify allowed requests and blocked requests.
- Verification gate `./devbox gate nextjs-app` exits with 0 errors.
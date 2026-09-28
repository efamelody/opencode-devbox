# Skill: Security & Authentication

When handling auth or security logic:
1. Always sanitize user inputs and parameters.
2. Never hardcode credentials, secrets, or tokens—use environment variables.
3. Ensure unauthenticated requests return explicit HTTP 401/403 status codes with clean JSON responses.
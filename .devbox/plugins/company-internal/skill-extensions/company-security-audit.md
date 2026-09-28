# Skill: Company Security Audit (Extended)

Extends the base security-audit skill with company-specific requirements.

## Additional Requirements

1. **Secrets Management**: All secrets MUST use the company vault (HashiCorp Vault / AWS Secrets Manager). No `.env` files in repos.
2. **Dependency Scanning**: Run `npm audit` / `pip-audit` / `go vulncheck` in every gate.
3. **SAST Integration**: Code must pass Semgrep/CodeQL scans with company ruleset.
4. **Container Security**: Docker images must pass Trivy scan with company policy.
5. **Compliance Headers**: All HTTP responses must include security headers (CSP, HSTS, X-Frame-Options).

## Company-Specific Patterns

### Authentication
- Use company SSO (OIDC) for all services
- JWT tokens must include `company_id` and `team_id` claims
- Session cookies must be `Secure; HttpOnly; SameSite=Strict`

### Data Protection
- PII fields must be encrypted at rest using company KMS
- Audit logs required for all data access (read/write)
- Data retention policies enforced via database triggers

### Network
- All inter-service communication via mTLS
- Egress restricted to company-approved endpoints
- Kubernetes NetworkPolicies required for all deployments

## Verification Checklist

- [ ] No hardcoded secrets in code
- [ ] Dependency scan passes
- [ ] SAST scan passes
- [ ] Container scan passes
- [ ] Security headers present
- [ ] Authentication uses company SSO
- [ ] PII encryption verified
- [ ] Audit logging implemented
- [ ] mTLS configured
- [ ] NetworkPolicies applied
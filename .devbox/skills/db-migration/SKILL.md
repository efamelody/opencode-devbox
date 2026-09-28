# Skill: Database Migration Guidance

When executing database schema changes on any target project:
1. Never edit existing migration files: Always create a new versioned migration script.
2. Backward Compatibility: Ensure schema additions are non-breaking for existing application code.
3. Local Verification: Run migration scripts locally before running project gates.
# Checklist for New Features

This is a checklist for developers to confirm whether a feature is ready to be reviewed.

## General

- [ ] Pull request is linked to the relevant GitHub issue.
- [ ] Acceptance criteria have been met.
- [ ] The developer has completed a self-review before requesting a team code review.

## Code Quality

- [ ] Code adheres to the team's backend [coding standards](https://github.com/minvws/nl-mgo-coordination-private/tree/develop/backend/agreements).
- [ ] Branch naming follows team conventions (e.g., feature/48-short-description).
- [ ] Commit messages are clear, concise, and follow agreed formatting.

## Testing

- [ ] Unit tests cover all business logic. Any uncovered code is justified and has been discussed with the team.
- [ ] At least one integration test verifies the happy flow.
- [ ] All tests pass successfully in the CI pipeline.
- [ ] QA has been informed via an issue comment and on Slack.

## Security

- [ ] No sensitive data are logged or stored in plain text.
- [ ] All external dependencies are up to date and have been scanned for known vulnerabilities.

## Documentation

- [ ] Code is documented where it is not self-explanatory, including edge cases and exceptions.
- [ ] API endpoints are documented in OpenAPI/Swagger (if applicable).
- [ ] Technical documentation or README files are updated to reflect new functionality and setup.
- [ ] Deployment instructions are present and documented in `HOSTING_CHANGELOG.md`.

## Deployability

- [ ] New functionality is gated behind feature flags, if applicable.

## Monitoring & Logging

- [ ] Logging provides sufficient detail for monitoring, debugging, and auditing purposes.

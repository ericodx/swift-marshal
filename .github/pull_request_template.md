## Summary

<!-- What does this change do? Keep it concise. -->

## Type of Change

- [ ] feat: A new feature has been added.
- [ ] fix: A bug has been fixed.
- [ ] perf: A code change that improves performance.
- [ ] refactor: A code change that neither fixes a bug nor adds a feature.
- [ ] test: Addition or correction of tests.
- [ ] docs: Changes only to the documentation.
- [ ] ci: Changes related to continuous integration and deployment scripts.
- [ ] build: Changes that affect the build system or external dependencies.
- [ ] chore: Other changes that do not fit into the previous categories.
- [ ] revert: Reverts a previous commit.

## Invariants Checklist

- [ ] Reordering is deterministic (same config + same input → same output)
- [ ] No members are lost or duplicated after reordering
- [ ] `check` never modifies source files
- [ ] `fix` produces output that passes `check` with the same config
- [ ] Member positions (file, line) are accurate
- [ ] Trivia and formatting are preserved for non-moved members
- [ ] Swift 6 Strict Concurrency compatible
- [ ] Pipeline stages remain stateless pure transformations

## Pipeline Impact

Which stages are affected?

- [ ] FileDiscovery
- [ ] Parse
- [ ] Classify
- [ ] Reorder
- [ ] RewritePlan
- [ ] ApplyRewrite
- [ ] Report
- [ ] CLI / Configuration
- [ ] None

## Testing

- [ ] Unit tests added or updated
- [ ] Tests use `ModelFactories` / `SyntaxFactories` / `ParsingHelpers` / `FileHelpers` where appropriate
- [ ] Snapshot tests added or updated (if output format changed)
- [ ] Integration tests added or updated (if pipeline or CLI behavior changed)
- [ ] Both `check` and `fix` paths covered where applicable
- [ ] All tests pass locally (`swift test`)

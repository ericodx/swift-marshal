# Contributing to Swift Marshal

Thank you for your interest in contributing to **Swift Marshal**.

Swift Marshal is an AST-based CLI that organizes the internal structure of Swift types.
It does **not** format code, rewrite syntax, or infer developer intent.

For an overview of the project goals and scope, see the README.

---

## Code of Conduct

Be respectful, professional, and constructive in all interactions.
This project follows the [Contributor Covenant Code of Conduct](CODE_OF_CONDUCT.md).

---

## Technical Principles

Swift Marshal follows a strict set of technical principles:

- Structural changes must be **explicit and deterministic**
- The tool must **preserve trivia** (comments, whitespace)
- No syntax rewriting or formatting is performed
- No intent is inferred beyond what is explicitly configured

Changes that violate these principles will not be accepted, even if they pass tests or improve performance.

---

## AI-Assisted Contributions

AI-assisted contributions are welcome.

When using tools such as GitHub Copilot or other LLMs:

- Treat AI as an **assistant**, not an authority
- Ensure all generated code follows the same standards as human-written code
- Prefer **validation over transformation**
- Do not introduce speculative or inferred behavior

Project-specific AI guardrails are defined in [copilot-instructions](.github/copilot-instructions.md).

---

## Pull Requests

All Pull Requests must:

- Follow the repository PR template
- Be focused on a single concern
- Reference an existing issue when applicable
- Respect the technical principles described above

AI-generated changes are reviewed under the same criteria as human-written code.

---

## Workflow

1. Open an issue describing the problem or proposal
2. Wait for maintainer feedback
3. Implement the change in a focused branch
4. Open a Pull Request referencing the issue

Unapproved structural changes may be closed without review.

---

## Testing

- Snapshot tests are mandatory for structural changes
- Tests must prove determinism and safety
- Golden files must be reviewed carefully

---

## Communication

All communication happens publicly via GitHub Issues and Discussions.
Private contact is discouraged.

---

## License

By contributing, you agree that your contributions are licensed under the [BSD 3-Clause License](./LICENSE).

# Code quality directive

Purpose: enforce FAANG-level, OOP-sound code on every change.
Apply this on top of feature-specific SKILL files.

## Before writing

- State the single responsibility of the class or function first.
- If it needs "and" to describe, split it.
- Identify which layer this code belongs to (UI, domain, data).
  Never let logic leak across layers.
- List the interfaces/abstractions involved before touching classes.

## SOLID, non-negotiable

- **S** — one reason to change per class. No god classes, no god widgets.
- **O** — extend via new classes, not by editing working ones.
- **L** — a subtype must be swappable for its base without surprises.
- **I** — small, focused interfaces. No fat interfaces forcing unused methods.
- **D** — depend on abstractions. Inject dependencies, never construct
  them inline inside business logic.

## Structure rules

- Max ~200 lines per file, ~30-40 per method. Split when exceeded.
- No nested ternaries. No more than 2 levels of nested conditionals.
- Extract magic numbers and strings into named constants.
- Prefer composition over inheritance unless a true is-a relationship exists.
- Pure functions where possible. Isolate side effects at the edges.

## Naming

- Names say what, not how. `calculateTotalPrice`, not `loopAndSum`.
- Booleans read as questions: `isLoading`, `hasError`, `canSubmit`.
- No abbreviations except industry-standard ones (`id`, `url`, `api`).

## Error handling

- Never swallow exceptions silently. Log or propagate, always with intent.
- Fail fast at boundaries (input validation, API responses).
- Use typed/sealed error results over generic exceptions where the
  language supports it.

## Testability

- Every public method should be testable without mocking the world.
- If a class needs 5+ mocks to test, its dependencies are wrong.
- Write the test contract in comments before or alongside the code.

## Self-review checklist (run before returning code)

- [ ] Could a new engineer understand this without asking me anything?
- [ ] Does removing any line break exactly one test, not five?
- [ ] Any duplicated logic that should be a shared function?
- [ ] Any class doing UI work and business logic at once?
- [ ] Any dependency constructed inside a class instead of injected?
- [ ] Would this survive a senior engineer's code review with zero
      "why did you do it this way" comments?

## Flutter/Dart specifics

- Widgets stay dumb. No business logic, no direct API/storage calls in
  build methods.
- `const` constructors everywhere possible.
- No `setState` outside the smallest widget that needs it.
- Extract repeated widget trees into named widgets, not helper methods
  that return widgets.
- Null-safety respected — no `!` without a preceding real check.

## Output contract

When generating code, always report:
1. Which SOLID principle(s) shaped the design.
2. Any tradeoff made and why.
3. What you deliberately left out and why (YAGNI).
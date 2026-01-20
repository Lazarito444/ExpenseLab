# AGENTS.md

This file defines **mandatory rules, conventions, and best practices** that any artificial intelligence agent must follow when working on this Flutter project.

The goals are:

- Maintain **consistent code quality**
- Avoid over-engineering
- Respect the **offline-first + event sourcing** design
- Produce **maintainable, testable, and predictable** code

These rules are **not suggestions**.

---

## 1. General principles

### 1.1 Offline-first is non-negotiable

- No functionality may depend on an internet connection.
- Everything must work fully offline.
- Any future synchronization is **optional and decoupled**.

### 1.2 Event sourcing as the source of truth

- **Never** write directly to state tables (read models).
- Every domain mutation must generate **DomainEvents**.
- Projections are recalculated exclusively from events.

### 1.3 UI contains no business logic

- The UI **must not calculate balances, budgets, or aggregates**.
- The UI only consumes **read models / projections**.
- All financial logic lives outside the UI layer.

---

## 2. Flutter architecture

### 2.1 Feature-first is mandatory

- Code must be organized by **features**, not by global layers.
- Each feature contains:
  - domain
  - data
  - ui

Valid example:

```
features/transactions/
  domain/
  data/
  ui/
```

Invalid example:

```
models/
services/
widgets/
```

---

### 2.2 Clear separation of responsibilities

| Layer  | Responsibility                     |
| ------ | ---------------------------------- |
| domain | Pure business rules                |
| data   | Persistence, events, projections   |
| ui     | Rendering and interaction handling |

---

## 3. Strict Dart rules

### 3.1 Explicit typing is mandatory

- **Never use `var`.**
- Always declare explicit types.
- Sort imports alphabetically in code and pubspec.yaml.
- Use `const` whenever possible.
- Use double quotes for strings.

❌ Incorrect:

```dart
var total = 0;
```

✅ Correct:

```dart
int total = 0;
```

### 3.1.1 Code documentation is mandatory

- Always document your code with docstrings.
- Use `@override` for overridden methods.
- Use package imports instead of relative imports.

---

### 3.2 Immutability by default

- Use `final` whenever possible.
- Avoid mutating shared objects.

---

### 3.3 Strict null safety

- Do not abuse `!`.
- Prefer explicit validations.

❌ Incorrect:

```dart
value!.amount
```

✅ Correct:

```dart
if (value == null) {
  return;
}
```

---

## 4. State and UI

### 4.1 Simple widgets

- Small, focused widgets.
- One widget = one visual responsibility.
- GetX for state management.

---

### 4.2 No financial logic in widgets

❌ Forbidden:

```dart
final double total = expenses.fold(0, (a, b) => a + b.amount);
```

✅ Correct:

```dart
final double total = summary.totalExpenses;
```

---

## 5. Database and persistence

### 5.1 Never access SQLite from UI

- All reads/writes must go through repositories.
- Use Drift ORM for database access.

---

### 5.2 Events first

- Every write operation:
  1. Validates rules
  2. Generates an event
  3. Persists the event
  4. Updates projections

---

### 5.3 Idempotent projections

- Reprocessing the same event **must not duplicate data**.
- Every projection must support full rebuild from events.

> Important: Always store datetime values as UTC. Never store local time. Parse to local time only when displaying to the user.

---

## 6. Financial model

### 6.1 Transfers

- A transfer:
  - Is not an expense
  - Is not income
  - Affects two accounts

---

### 6.2 Multi-currency

- Every transaction stores:
  - Original currency
  - Exchange rate used

- Never recalculate history with current rates.

---

## 7. Budgets

### 7.1 Budgets observe, they do not block

- A transaction is **never** rejected due to a budget.
- Budgets only provide visual feedback.

---

## 8. Security

### 8.1 Financial data must be encrypted

- The database must be encrypted.
- Never store sensitive data in plain text.

---

### 8.2 App lock

- Automatic lock on background.
- PIN or biometric support.

---

## 9. Export

### 9.1 The user owns their data

- Always export from read models.
- Minimum formats:
  - CSV
  - JSON

---

## 10. Testing

### 10.1 Domain tests first

- Test financial rules without UI.
- Test projections with event sequences.

---

### 10.2 Do not over-test Flutter UI

- Prioritize logic tests.
- UI tests only for critical flows.

---

## 11. Performance

### 11.1 Optimize by design, not hacks

- Use read models.
- Avoid real-time calculations in UI.

---

## 12. What NOT to do

- ❌ Do not introduce mandatory cloud
- ❌ Do not introduce unnecessary AI
- ❌ Do not break offline-first
- ❌ Do not put financial logic in widgets
- ❌ Do not use `var`

---

## 13. Final rule

If a technical decision:

- Complicates the code
- Breaks offline-first
- Mixes layers

Then it is **incorrect**, even if it works.

This file has priority over any other automated suggestion.

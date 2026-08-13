---
name: react
description: React guidance for avoiding unnecessary useEffect and preferring simpler data flow.
---

# React

- Avoid `useEffect` for derived values, event handling, or transformations that can happen during render.
- Prefer direct calculations, pure functions, and component composition.
- Use `useEffect` only when synchronizing with an external system or another imperative API.
- Before adding an effect, explain why render-time logic, an event handler, or a more direct data flow is not sufficient.
- Preserve the existing public behavior and add or update tests when changing behavior.

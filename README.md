# Breezz Skills

Public Agent Skills for Salesforce Breezz and related tooling. Each skill lives in its own folder under `skills/` with a `SKILL.md` file (YAML frontmatter with `name` and `description`).

## Repository layout

```
skills/
  <skill-id>/
    SKILL.md          # required; frontmatter name should match <skill-id>
    ...               # optional supporting files referenced by the skill
```

## Validate locally

```bash
npx skills add forvendi/breezz-skills --list
```

Install one skill into Cursor’s skills path (example):

```bash
npx skills add forvendi/breezz-skills --skill SKILL_FOLDER_NAME -a cursor -y
```

## License

See [LICENSE](./LICENSE).

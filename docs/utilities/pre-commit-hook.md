https://pre-commit.com/

**Example
```
repos:  
  - repo: local  
    hooks:  
      - id: run-docker-command  
        name: Generate alerts, rules, tests  
        language: script  
        entry: ./src/run_docker.sh  
        always_run: true  
        files: .  
  - repo: https://github.com/pre-commit/pre-commit-hooks  
    rev: v2.4.0  
    hooks:  
      - id: trailing-whitespace  
      - id: end-of-file-fixer  
      - id: check-added-large-files  
      - id: check-merge-conflict  
      - id: mixed-line-ending  
      - id: check-yaml  
      - id: no-commit-to-branch  
        name: branch needs format bugfix|feature/JIRA-123  
        args: ["--pattern", '^(?!((bugfix|feature)\/[A-Z]+-[0-9]+)$)']  
  - repo: https://github.com/igorshubovych/markdownlint-cli  
    rev: v0.39.0  
    hooks:  
      - id: markdownlint  
        args: ["--fix"]  
  - repo: local  
    hooks:  
      - id: Commit message check  
        name: commit message needs format "JIRA-123:\sText message"  
        language: pygrep  
        entry: '\A([A-Z]+-[0-9]+:\s\S+)'  
        args: [--multiline, --negate]  
        stages: [commit-msg]  
  - repo: local  
    hooks:  
      - id: check-new-files  
        name: New untracked files found  
        entry: bash -c 'if git status --porcelain teams common_templates | grep "^??"; then echo "New untracked files found!"; exit 1; fi'  
        language: system  
        always_run: true
```

**Usage** for any operations with resources in repo on pre commit stage
---
name: using-jujutsu
description: Guides version control operations using jujutsu (jj) instead of git. Use when the repository contains a .jj directory or when asked to perform version control operations in a jj-managed repo.
---

# Using Jujutsu (jj)

Use `jj` commands instead of `git` for all version control operations when the repository is managed by jujutsu (indicated by a `.jj/` directory).

*Always* include your Co-Authored-By when making commits

## Key Differences from Git

- No staging area—all changes are automatically tracked in the working copy
- Commits are mutable by default and can be edited at any time
- The working copy is itself a commit (the `@` revision)
- Branches are optional bookmarks, not required for commits

## Common Operations

### Check status
```bash
jj status          # or jj st
```

### View history
```bash
jj log             # shows commit graph
jj log -r @        # show current commit only
```

### Create a new commit
```bash
jj new             # create new empty commit on top of @
jj commit -m "message"  # describe @ and create new commit
jj commit -m "message" file1.txt file2.txt  # commit only specified files
```

### Edit commit message
```bash
jj describe -m "new message"    # edit current commit's message
jj describe -r <rev> -m "msg"   # edit specific revision's message
```

### View changes
```bash
jj diff            # diff of working copy
jj diff -r <rev>   # diff of specific revision
jj show <rev>      # show commit details and diff
```

### Amend current commit
```bash
# Changes are automatically included in @, no explicit amend needed
# To move changes into a different commit:
jj squash          # squash @ into parent
jj squash --into <rev>  # squash @ into specific revision
```

### Create and manage bookmarks (branches)
```bash
jj bookmark create <name>        # create bookmark at @
jj bookmark set <name> -r <rev>  # move bookmark to revision
jj bookmark list                 # list all bookmarks
```

### Restore files or changes
```bash
jj restore                        # restore all paths in @ to parent state (empties the commit)
jj restore file1.txt file2.txt    # restore specific files in @ to parent state
jj restore --from <rev>           # restore all paths in @ from a specific revision
jj restore --from <rev> file.txt  # restore a single file in @ from a specific revision
jj restore --changes-in <rev>     # undo the changes introduced by a revision
```

### Undo operations
```bash
jj undo            # undo last operation
jj op log          # view operation history
jj op restore <id> # restore to specific operation
```

### Working with remotes
```bash
jj git fetch       # fetch from remote
jj git push        # push current bookmark
jj git push -b <bookmark>  # push specific bookmark
```

### Rebase and edit history
```bash
jj rebase -r <rev> -d <destination>  # rebase single commit
jj rebase -s <rev> -d <destination>  # rebase commit and descendants
jj edit <rev>      # make revision the working copy to edit it
```

### Resolve conflicts
```bash
jj status          # shows conflicted files
# Edit files to resolve, conflicts are marked with conflict markers
jj resolve         # interactive conflict resolution
```

## Revision Syntax

- `@` — working copy (current commit)
- `@-` — parent of working copy
- `@--` — grandparent
- `<bookmark>` — revision at bookmark
- `<commit_id>` — specific commit (prefix match works)
- `root()` — the root commit

## Important Notes

- Never use `git` commands directly—they may corrupt jj state
- Use `jj git` subcommands for git interop (fetch, push, clone)
- Commits don't need messages immediately; use `jj describe` later
- Empty commits are allowed and useful for organizing work

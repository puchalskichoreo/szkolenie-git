# Git workshop

Welcome! In the next 35 minutes you will go through the full team workflow. You will:

- create a branch,
- undo a bad commit,
- make a change,
- solve a merge conflict,
- open a Pull Request,
- review a colleague's work,
- get the checks green.

Nothing here can break anything. Everyone has **their own branch and their own file**, so you cannot get in anyone's way.

## What is in this repo

| Path | What it is |
|---|---|
| `queries/<your-name>.sql` | **Your** SQL report. Touch only this file. |
| `data/` | Small sample data: `campaigns` and `daily_spend` tables. |
| `ci/check.py` | The robot that checks your SQL (see the last step). |

## Your mission

Use the terminal (Git Bash, PowerShell or your editor's terminal). `<your-name>` is your branch name, e.g. `anna-kurach`.

### 1. Clone & branch

```bash
git clone <repo-url>
cd <repo-folder>
git checkout <your-name>
git checkout -b <your-name>-work
```

### 2. Find & revert the bad commit

Someone left a commit called **"WIP: quick experiment, DO NOT MERGE"** on your branch. It breaks the report. Undo it. Don't edit the file by hand: let Git create a commit that reverses it.

```bash
git log --oneline
git revert <hash> --no-edit
```

### 3. Make your change

Open `queries/<your-name>.sql` and do the TODO:

> **Keep only active campaigns (`status = 'active'`) and add a `total_spend` column (`SUM(spend)`).**

```bash
git add queries/<your-name>.sql
git commit -m "Keep active campaigns, add total_spend"
```

### 4. Push & open a Pull Request

```bash
git push -u origin HEAD
```

On GitHub, open a Pull Request from `<your-name>-work` to `main`. Add your partner as a reviewer.

Look at the PR page: GitHub says **"This branch has conflicts that must be resolved"**. While you were working, `main` moved on and changed the same lines. Let's fix that on your machine.

### 5. Merge main, solve the conflict

Bring the changes from `main` into your branch:

```bash
git merge origin/main
```

Git will stop with a **CONFLICT**. Open the file. You will see something like this:

```
<<<<<<< HEAD
your version
=======
the version from main
>>>>>>> origin/main
```

Don't just pick one side: **keep what both sides wanted**, then delete the marker lines.

```bash
git add queries/<your-name>.sql
git commit --no-edit
git push
```

Refresh the PR: the conflict warning is gone.

Panicking? `git merge --abort` takes you back to before the merge.

### 6. Review in pairs

Open your partner's PR, go to **Files changed** and read the SQL carefully. **There is a hidden bug in every branch.** It's not a syntax error: it's something that quietly gives wrong numbers. The top of every SQL file says **what the finished report must do**. Compare that with what the code *does*.

1. **Reviewer:** click the line and leave a comment.
2. **Author:** fix it, `git add`, `git commit -m "..."`, `git push`.
3. **Reviewer:** check the fix and click **Resolve conversation**. The reviewer resolves, not the author.
4. **Reviewer:** **Approve**.

### 7. Green checks → merge

Every push runs the **check** robot on your PR. It checks:

- no conflict markers left,
- SQL style (keywords in UPPER CASE),
- the result of your query on the sample data equals the expected result.

Red is normal until you're done: the hidden bug alone keeps it red. Click **Details** to read the message.

When the check is green, all conversations are resolved and you have an approval, click **Merge**. 🎉

## Safety net

| Command | What it does |
|---|---|
| `git status` | Where am I? What changed? |
| `git diff` | Show my uncommitted changes |
| `git log --oneline --graph --all` | Draw the graph |
| `git restore <file>` | Throw away uncommitted changes in a file |
| `git restore --staged <file>` | Un-stage a file (keeps your edits) |
| `git reset --hard` | Throw away **all** uncommitted changes. Careful! |
| `git merge --abort` | Back out of a conflict and start again |

## Running the check yourself (optional)

```bash
pip install duckdb sqlfluff
python ci/check.py queries/<your-name>.sql
```

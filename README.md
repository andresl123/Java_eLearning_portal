Java_eLearning_portal

🔁 1. Branching Strategy to Use

We’ll use GitHub Flow — it’s simple, works well with CI/CD, and keeps our main branch always deployable.

Branches we’ll use:

main: Stable and production-ready

Feature branches: Created from main for each task

PRs: Open a pull request for every change

🧱 2. Branch Naming Conventions

Use descriptive, lowercase names with slashes to group by type:

Type

Format

Example

Feature

feature/<short-description>

feature/login-page

Bugfix

bugfix/<short-description>

bugfix/fix-login-error

Hotfix

hotfix/<short-description>

hotfix/fix-api-crash

Chore

chore/<short-description>

chore/update-packages

Release

release/<version>

release/v1.2.0

🔸 Tip: Keep it short and clear. Use hyphens instead of spaces or underscores.


To summarize the text above: you will create a new branch for the task you're working on based on the table, and after merging it into the main branch, you should delete the branch you created.

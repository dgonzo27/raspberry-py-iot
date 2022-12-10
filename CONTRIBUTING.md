---
title: Contributing
---

# Contributing to raspberry-py-iot

If you would like to become an active contributor to this project, please submit an [issue](https://github.com/dgonzo27/raspberry-py-iot/issues) with the _contributor_ template.

## Branching Strategy

In this strategy, there is only a single branch or _"source of truth"_ - the `master` branch. The idea behind this strategy is to minimize the amount of human interaction required to maintain branches and to minimize the overrall number of maintained branches in general.

- When developing a new feature or resolving a bug, checkout to a `features/*` or `bugs/*` branch using your approved GitHub issue number. For example, `features/git-issue-6`.

- When you are finished developing, you'll push your code and create a pull request to the `master` branch.

- Once the branch is approved and merged the branch will be deleted.

## Local Development Commands

1. Clone the repository or pull the latest changes from `master`.

   ```sh
   git clone git@github.com:dgonzo27/raspberry-py-iot.git && cd raspberry-py-iot

   git pull origin master
   ```

2. Install and enable [pre-commit](https://pre-commit.com).

   ```sh
   pre-commit install
   ```

3. Checkout to a `features/*` or `bugs/*` branch.

   ```sh
   git checkout -b features/git-issue-27
   ```

## Code of Conduct

Before contributing to this repository, please review the [code of conduct](./CODE_OF_CONDUCT.md).

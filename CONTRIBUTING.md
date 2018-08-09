# Contributing to DAL

Thanks for thinking about contributing to DAL. Please review this document
first and also take a look at our [Code of Conduct](CODE_OF_CONDUCT.md), to
help us keep this project inclusive to all those that may wish to contribute
also.

## Opening Issues

We classify bugs as any unexpected behaviour that occurs based on the code in
the project, and we really appreciate it when users take the time to [create an
issue](https://github.com/expert360/dal/issues).

Please take time to add as much detail as you can to any bug reports, consider
including things like the version of Elixir you are using and any reproduction
steps you can provide. The more context the better.

If you are thinking about adding a feature, you should the check the
[issues](https://github.com/expert360/dal/issues) first, someone else may have
started already, or it might be a feature we've decided not to implement
intentionally.

## Submitting Pull Requests

Whether you're fixing a bug, or proposing a feature you'd like to see included, you can submit Pull Requests by
following this guide:

1. [Fork this repository](https://github.com/expert360/dal/fork) and then clone it locally:

  ```bash
  git clone https://github.com/expert360/dal
  ```

2. Create a topic branch for your changes:

  ```bash
  git checkout -b fix-nasty-bug
  ```

3. Commit a failing test for the bug:

  ```bash
  git commit -am "Add a failing test that demonstrates the bug"
  ```

4. Commit a fix that makes the test pass:

  ```bash
  git commit -am "Fix nasty bug"
  ```

5. Run the tests:

  ```bash
  mix test
  ```

6. If everything looks good, push to your fork:

  ```bash
  git push origin fix-nasty-bug
  ```

7. [Submit a pull request.](https://help.github.com/articles/creating-a-pull-request)


## Style guidelines

We support the common conventions found in Elixir, if you're in doubt take a
look at the code in the project, and we would like to keep the style consistent
throughout.

# raiden 0.1.0

-   Create `raidenApp()` and `gather_*()` functions
-   `pkgdown` builds
    -   `pkgdown` #4: Commit [f26e040](https://github.com/mjfrigaard/raiden/commit/f26e04073763e8a412905febf55c515af83489ad) (FAIL)
        -   error with `purrr` (see [issue #1](https://github.com/mjfrigaard/raiden/issues/1))
            -   install with `pak`, `renv::snapshot()` , `pkgdown::build_site_github_pages()`, commit/push
    -   
        -   Added `purrr` to `DESCRIPTION`
            -   loaded, documented, installed
            -   `renv::snapshot()`
                -   "\* The lockfile is already up to date"
            -    `pkgdown::build_site_github_pages()`
            -   commit/push

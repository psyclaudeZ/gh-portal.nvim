# gh-portal.nvim (WIP)

Open your file in the corresponding GitHub repo, if applicable.

## Why

Because the marginal cost of creating a productive GitHub experience inside a
terminal is too high, and no one has nailed it yet. Additionally:

1. With tmux, I really don't see how those popular git plugins shine.
2. If one can't/doesn't aim to solve all the problems, there better be a clear line drawn between GitHub and CLI. Otherwise it's Stockholm syndrome.

## Customization

```lua
require('gh-portal').setup({
    # Used for extracting and generating the URL. Defaults to "github.com".
    enterprise_url = "url",

    # Overwrites the branch segment in the generated URL. Defaults to "main".
    branch = "develop",
})
```

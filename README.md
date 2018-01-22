
# DiffHighlight

(C) John Mair (banisterfiend)

Applies syntax highlighting to a `git diff`. Use as follows:

```
git diff | diff_highlight | less
```

Output:

![img](https://i.imgur.com/DcO4txF.png)


## Features

* Makes its best guess at the language appearing in the diff and uses appropriate highlighter
* Supports Ruby, Javascript, C, YAML, Rakefiles, CSS, HTML, etc
* Supports multiple languages in the same diff
* Supports streaming input

## How to use

This gem provides the `diff_highlight` executable. Just install the gem and the executable should be available :)
Use as follows: `git diff | diff_highlight | less`

Or setup a git alias:

In `~/.gitconfig`:

```
[alias]
    diffc="!f() { git diff $@ | diff_highlight | less; }; f"
```

And use like so:

```
git diffc HEAD^2
```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

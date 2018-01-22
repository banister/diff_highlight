
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
* Supports streaming input

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

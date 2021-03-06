# Asha

![Asha logo](asha.gif)

*Asha* is a static site generating system.

The purpose of *asha* is to show how to construct domain-specific language with Common Lisp, or to show how to write a system with Common Lisp.

## Installation

Put this repository into your ASDF path.
Or if you use [Roswell](https://github.com/roswell/roswell), type `ros install t-sin/asha` in shell.

## Usage

First of all, call `create-blog` function in REPL for initialing static site called 'blog'.

```lisp
CL-USER> (setf blogpath (truename "~/myblog"))
#P"~/myblog"
CL-USER> (asha:create-blog blogpath)
...
```

A function `load-blog` read specified pathnames and return static site informataion.

```lisp
CL-USER> (setf article-set (asha:load-blog blogpath))
...
```

If you want to add a new blog post, there is a function `new-post` for that.
`new-post` takes a plist represent a post.
Note that `new-post` modifies `article-set`.
Example usage is like this:

```lisp
CL-USER> (setf post '(:name "my-first-post"
                      :title "First post!"
                      :body (:article
                             (:h1 "First post!")
                             (:p "Hi, this is my blog."
                                 "This blog is generated by static site generator.")
                             (:p "It's my first post!"))))
...
CL-USER> (new-post blogpath post article-set)
...
```

Posts are three required key  `:name`, `:title` and `:body`.
`:body` should be a list, especially be a SHTML (S-expression HTML).
For details, see [`src/shtml.lisp`](src/shtml.lisp).

To save article set into file, use `save-blog` function.

```lisp
CL-USER> (save-blog blogpath article-set)
...
```

To render entire static site, `render-blog` is for it.

```lisp
CL-USER> (setf outpath (truename "~/www/"))
#P"~/www/"
CL-USER> (render-blog article-set blogpath outpath)
...
```

And then, there is a static site files.

## Author

- TANAKA Shinichi <shinichi.tanaka45@gmail.com>

## License

*Asha* is licensed under the MIT license. See [COPYING](COPYING).

# Pashua: Native macOS dialogs for scripting languages

Pashua is a macOS application for creating native dialog windows from almost any programming language. Typically, it is used with languages that have none or only limited support for graphic user interfaces on macOS, such as AppleScript, Bash scripts, JavaScript, Perl, PHP, Python, Ruby, Tcl and others – and if your favourite language is not yet supported: writing the glue code for communicating with Pashua is pretty simple.

Pashua was written in Objective-C/Cocoa and should run on macOS/OS X 10.9 or later.


## Related links

* Pashua homepage: https://www.bluem.net/en/projects/pashua/ (including download link for compiled application)
* Pashua Bindings repository: https://github.com/BlueM/Pashua-Bindings

## Author

Author: Carsten Blüm, Website: [www.bluem.net](https://www.bluem.net)


# About the code

Pashua’s history goes back to 2003. Most of the code was written between 2003 and 2010, and the codebase never experienced a major refactoring. In other words: **When inspecting the code, you will find generally mediocre code quality, lack of SOLID principles etc., and you should in no way use Pashua’s codebase as a reference for how macOS applications should be built**. Despite that, Pashua is still a valuable tool used all over the world, which is why I released it as Open Source Software (3-clause BSD license).


# Compiling

It should be able to compile the project with Xcode 9 out of the box. Older versions are untested.

Of course you don’t have to compile Pashua yourself if you only want to use it – on Pashua’s [website](https://www.bluem.net/jump/pashua/), you will find a download link.


# Future plans

I do not have any roadmap for Pashua. Probably, I will have almost no time for working on it (as it was the case in the last few years), so its future will to some degree depend on contributions by other developers.

Over the years, I got a lot of feature requests, but due to lack of time and motivation (for more information, see [some of my thoughts regarding Apple](https://www.bluem.net/en/news-and-beyond/about-apple/)), I hardly implemented any of them. Meanwhile, I have added a number of these requests as issues. This does not necessarily imply that I intend to resolve any of them.


# Contributing

I am open to pull requests, both to existing issues and for new topics. The usual constraints apply:

* One pull request per topic. I.e.: if you would like to contribute a new feature and two bugfixes, open three pull requests.
* All commit messages are in English and any namings introduced in the PR are English.
* Ideally, all non-obvious features or changes should be shortly explained. This might not only include what you committed, but also why you did it (motivation, usage scenario, …).
* Before creating a PR that modifies a substantial part of the code or changes how things work, you should probably contact me, as otherwise it is likely that I will not merge the PR.


# License

Pashua’s source code is released under the 3-clause BSD license

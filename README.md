⚠️ **Pashua needs a new maintainer** ⚠️

This project has been more or less inactive since 2018. In part, this is due to a lack of time, but even more due to a lack of interest. I haven’t used Pashua myself in years, and meanwhile have a rather ambivalent relationship to Apple and macOS, wich is why I hardly do any macOS development any more. All of this means that Pashua clearly does not have a bright future, at least not with me as the maintainer. Pashua turns 20 in November 2023, so it’s time to let go, right?

**If you are reading this and are interested in taking over the project, please let me know.**


# Pashua: Native macOS dialogs for scripting languages

Pashua is a macOS application for creating native dialog windows from almost any programming language. Typically, it is used with languages that have none or only limited support for graphic user interfaces on macOS, such as AppleScript, Bash scripts, JavaScript, Perl, PHP, Python, Ruby, Tcl and others – and if your favourite language is not yet supported: writing the glue code for communicating with Pashua is pretty simple. See the **[Pashua Bindings repository](https://github.com/BlueM/Pashua-Bindings)** for code and more information.

Pashua was written by Carsten Blüm ([www.bluem.net](https://www.bluem.net)) in Objective-C/Cocoa and should run on macOS/OS X 10.9 or later.


# About the code

Pashua’s history goes back to 2003. Most of the code was written between 2003 and 2010, and the codebase never experienced a major refactoring. In other words: **When inspecting the code, you will find generally mediocre code quality, lack of SOLID principles etc., and you should in no way use Pashua’s codebase as a reference for how macOS applications should be built**. Despite that, Pashua is still a valuable tool used all over the world (albeit not used by me …), which is why I released it as Open Source Software (3-clause BSD license).


# Compiling

It should be able to compile the project with Xcode 9 out of the box. Older versions are untested.

For pre-compiled binaries, see the [Releases](https://github.com/BlueM/Pashua/releases) page.


# Future plans

I do not have any roadmap for Pashua. Probably, I will have almost no time for working on it (as it was the case in the last few years), so its future is currently unclear.

Over the years, I got a lot of feature requests, but due to lack of time and motivation, I hardly implemented any of them. Meanwhile, I have added a number of these requests as issues. This does not necessarily imply that I intend to resolve any of them.


# License

Pashua’s source code is released under the 3-clause BSD license

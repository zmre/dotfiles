Why?
====
Although I've screened out files that are specific to me, I've really posted
my dotfiles as a way to keep them in sync between different machines.  At the
same time, the way I've setup my bashrc stuff is to have files automatically
read in from the profile.d directory and this base model may be of some use to
others.  The functions and other things represent years of working on Linux,
FreeBSD and Mac so there may be a bit of cruft, but it doesn't seem to do me
any harm.

Installation
============
To install you'll want to backup any files you have that may conflict, first
and foremost, since my directions don't talk about that.  Then do this:

    git clone git://github.com/zmre/dotfiles.git ~/
    git submodule update --init
    git submodule foreach git checkout master

But because the .vim dir is a submodule with submodules and its own
instructions, go follow the install directions listed in
`~/.vim/README.markdown` -- namely you'll want to init each subdir and build
the CommandT plugin.

Updating
========
Because of the use of submodules (and submodules within submodules), the steps
to update are slightly more involved than a simple git pull.  This should do
it for you:

    cd ~
    git pull
    git submodule foreach git pull
    cd ~/.vim
    git submodule foreach git pull


[![Build Status](https://travis-ci.org/wyeworks/rubygoal.png)](https://travis-ci.org/wyeworks/rubygoal)
[![Code Climate](https://codeclimate.com/github/wyeworks/rubygoal.png)](https://codeclimate.com/github/wyeworks/rubygoal)
[![Inline docs](http://inch-ci.org/github/wyeworks/rubygoal.png?branch=master)](http://inch-ci.org/github/wyeworks/rubygoal)

#Welcome to RubyGoal!

## What is RubyGoal?

RubyGoal is a game in which you will be coaching your football team.

You will be coding your strategy in RUBY :D .

## Dependencies

GNU/Linux, Make sure you have all dependencies installed.

Ubuntu/Debian:

```bash
# Gosu's dependencies for both C++ and Ruby
sudo apt-get install build-essential libsdl2-dev libsdl2-ttf-dev
libpango1.0-dev \
                     libgl1-mesa-dev libfreeimage-dev libopenal-dev
                     libsndfile-dev
```

For other distros:  https://github.com/jlnr/gosu/wiki/Getting-Started-on-Linux

## How do i run it?

```bash
gem install rubygoal
```

Run the game with example `Coach`
```bash
rubygoal
```

Run the game with your custom `Coach` implementation
```bash
rubygoal coach_1.rb
```

Run the game with your home and away `Coach` implementations
```bash
rubygoal coach_1.rb coach_2.rb
```

If you want to run the game from the source code, clone the project and
run the following commands:

```bash
BUNDLE_GEMFILE=Gemfile.dev bundle install
BUNDLE_GEMFILE=Gemfile.dev bundle exec ruby gui/bin/rubygoal
```

## How do i write my own coach class?

Take a look to the already defined `Coach` at `lib/rubygoal/coaches`.
Specially pay attention to the file `lib/rubygoal/coaches/template.rb`



## Legal
All source code, except the files under the `media/` folder, is
licensed under the Apache License 2.0. Please see the `LICENSE` file under
the gem root folder.

All media files under the `media/` folder are licensed under the Creative
Commons 4.0 Attribution license. Please see https://creativecommons.org/licenses/by/4.0/

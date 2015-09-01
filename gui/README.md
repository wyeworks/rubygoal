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

Run the game with example `CoachDefinition`
```bash
rubygoal
```

Run the game with your custom `CoachDefinition` implementation
```bash
rubygoal coach_1.rb
```

Run the game with your home and away `CoachDefinition` implementations
```bash
rubygoal coach_1.rb coach_2.rb
```

If you want to run the game from the source code, clone the project and
run the following commands:

```bash
BUNDLE_GEMFILE=Gemfile.dev bundle install
BUNDLE_GEMFILE=Gemfile.dev bundle exec ruby gui/bin/rubygoal [coach_file] [coach_file]
```

Also, you can simulate a game without the GUI by running

```bash
bundle install
bundle exec ruby bin/rubygoal [coach_file] [coach_file]
```

When you simuate a game, a JSON file is created in the same folder. You
could run this using our experiment webcomponent to play Rubygoal in the
web: https://github.com/jmbejar/rubygoal-webplayer

## How do i write my own coach class?

You can find a complete guide explaining how to program a coach in
www.rubygoal.com

Aditionally, you can take a look to the already defined `CoachDefinition` at
`lib/rubygoal/coach_definition`.
Specially pay attention to the example coaches in `lib/rubygoal/coaches/`


## Legal
All source code, except the files under the `media/` folder, is
licensed under the Apache License 2.0. Please see the `LICENSE` file under
the gem root folder.

All media files under the `media/` folder are licensed under the Creative
Commons 4.0 Attribution license. Please see https://creativecommons.org/licenses/by/4.0/

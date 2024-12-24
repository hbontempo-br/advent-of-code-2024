# My Advent of Code Sollutions

Day | 01 | 02 | 03 | 04 | 05 | 06 | 07 | 08 | 09 | 10
:-|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:
Part 1 |⭐|⭐|⭐|⭐|⭐|⭐|⭐|⭐|⭐|⭐
Part 2 |⭐|⭐|⭐|⭐|⭐|⭐|⭐|⭐|⭐|⭐

Day | 11 | 12 | 13 | 14 | 15 | 16 | 17 | 18 | 19 | 20
:-|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:
Part 1 |⭐|⭐|⭐|⭐|⭐|⭐|⭐|⭐|⭐|⭐
Part 2 |⭐|⭐|⭐|⭐|⭐|⭐|⭐|⭐|⭐|⭐

Day | 21 | 22 | 23 | 24 | 25
:-|:-:|:-:|:-:|:-:|:-:
Part 1 |⭐|⭐|⭐| | 
Part 2 | |⭐|⭐| | 


## Setup

This is an Elixir project. Make sure you have the Elixir version described at [.tools-version]() installed OR use the [REMOTE_CONTAINER.md] steps to setup the development container locally on through Github Codespaces.

The inputs are automaticaly downloaded, for this you need get your AdventOfCode's session cookie and register it in the project secrets.

### Retrie the session cookie

Go to AdventofCode's [website](https://adventofcode.com/), login in into it, and using the browser's development tools get the session cookie ([tip](https://developer.chrome.com/docs/devtools/application/cookies)).

### Register the session cookie

Simple, just edit it into the file `/config/secrets.exs`

## Running the scripts

Use the `mix` task:

```sh
# Running Day 1 - Part 1 script:
mix d01.p1
```

Benchmarking the execution:

```sh
# Benchmarking Day 1 - Part 1 script:
mix d01.p1 -b
```

## Running tests

No suprise here:

```sh
mix test
```

> 📚🧑‍💻 Base project structure copied from https://github.com/mhanberg/advent-of-code-elixir-starter.
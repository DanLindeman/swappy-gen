# Swappy Level Generator
This is a project for Dan Lindeman's CIS 693 graduate project at Grand Valley State Univeristy, Fall Semester, 2018.

## Scope
The scope of the project is to procedurally generate levels for the puzzle game Swappy.

## Swappy
Swappy is a game originally conceived by Dan Lindeman in which colored tokens must get to their same-colored goals. Think of it like a many-player maze.
The catch is that players may be physically separated from their goal. 

They might be separated by walls or by doors they cannot use.
Character Tokens may only move through doors that share a color with them.
This would be troubling for most maze-tokens...but Swappy tokens are special.

`If two character tokens ever line up horizontally or vertically, they may swap places.`

---

This application has been developed on python 3.7.0.

Installation
```
pip install requirements.txt
```

Install `clingo`
[clingo homepage](https://potassco.org/clingo/)

This application has been developed on clingo version 5.3.0.

```
$ clingo --version
clingo version 5.3.0
Address model: 64-bit

libclingo version 5.3.0
Configuration: without Python, with Lua 5.3.4
libclasp version 3.3.4 (libpotassco version 1.1.0)
```

The generator code is wrapped in a Fire CLI, to invoke it run.

Usage:
```bash 
python gen.py generate
```

By default this will generate a 10x10 level with two characters.
You may wish to add more characters or generate larger or smaller levels to do so pass the following arguments to the `generate` function. For example three character tokens is a 20x20 level would be.

```bash 
python gen.py generate --players=3 --width=20
```

Parameter | Explanation
--- | --- 
--width | width of generated map
--players | number of character tokens in the map (max 4)
-- number_of_moves | The number of moves each player should take to solve the level
-- show_paths | Show the paths taken by the solver
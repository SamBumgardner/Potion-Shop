# Potion-Shop
This is a potion shop-running simulation game created in 8(ish) weeks by Sam Bumgardner and Alex Mullins, a pair of students from Missouri State University.

The main purpose of this project was to build a fun game while building a flexible UI system that could (hopefully) be reused in future projects. 
In the end, I learned a lot about designing UI systems that I'll be able to use in the future. Unfortunately, the game ended up being more of a playable proof-of-concept
(there's nothing for the player to spend money on, there's no tutorial, and some customers want potions that the player can't make) but with a bit more development and 
polish it could definitely become a solid game!

## Overview

Play as an entrepreneurial alchemist running a mystical potion shop!

The game does not currently run in-browser (I may get it to work at some point) but you can still play the game by following the steps below!

## Getting Started

To build and run Potion-Shop on Windows or Linux (note: only tested on Windows), follow the steps below:

1. Ensure you have [Haxe](http://www.haxe.org/download) and [HaxeFlixel](http://www.haxeflixel.com) installed on your computer.
  * Installing HaxeFlixel should also automatically install [OpenFl](http://www.openfl.org/learn/docs/getting-started/) and [Lime](https://lib.haxe.org/p/lime).
2. Run the command `haxelib git flixel https://github.com/HaxeFlixel/flixel.git remove-logic-refactoring` to switch to the proper dev branch of HaxeFlixel.
  * Without a certain fix from this development branch, the game will crash during transitions between states & substates.
3. Clone or download this repository to your computer.	
4. Open a command prompt in the newly created `\Potion-Shop` folder.
5. Run the command `haxelib run lime test neko` to build and run the executable.
  * The executable is located in `\Potion-Shop\export\windows\neko\bin`.
  * To run in debug mode, run the command `haxlib run lime test -debug neko`. The debug console can be accessed with the backquote key.
  
## Contribution guidelines

If you're interested in making contributions to this game, please follow the steps outlined below.

* Fork this repository using the button at the top-right part of the page.
* Create a branch off of `develop` with a name that describes what sort of changes you plan to make.
* Make changes/additions/deletions, committing them to your branch as you go. 
 * Aim to make your commits atomic, each dealing with a single subject.
* When finished, come back to this repository and open a pull request from your branch to `master`.
 * See existing pull requests for a general format to follow.
* Your pull request will be reviewed and responded to, and hopefully merged in!

## Contacts

* [@SamBumgardner](https://github.com/SamBumgardner) - Programmer and Designer.
* Alex Mullins - Artist and Designer.

Feel free to send me an email at sambumgardner1@gmail.com!
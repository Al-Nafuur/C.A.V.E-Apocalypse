# C.A.V.E. Apocalypse

C.A.V.E. Apocalypse is an online game for the Atari 2600. It uses PlusROM functions which are supported by [Gopher2600](https://github.com/JetSetIlly/Gopher2600), [My Javatari fork](https://github.com/Firmaplus/javatari.js) and the [PlusCart](https://pluscart.firmaplus.de)

The game is programmed in [batari Basic](https://github.com/batari-Basic/batari-Basic), but to compile it the PlusROM extensions of my [batari Basic fork](https://github.com/Al-Nafuur/batari-Basic) have to be used, see this [AtariAge thread](https://atariage.com/forums/topic/314343-plusrom-function-online-gaming-support-for-batari-basic) howto include the PlusROM extensions.

Various code examples from [randomterrain's awesome batari Basic webpage](https://www.randomterrain.com/atari-2600-memories.html#batari_basic) and various AtariAge threads are used in this code.

## Technical Description 
When starting a game or changing a room the room information is requested from the server (/server/a.php) and the state of the room left is send in the request to store it in the server side session.

The website for the level/room editor can be found [here](https://cave-apocalypse.firmaplus.de/editor.php), but the rooms can only be viewed so far, editing on the website is not working yet. The level files (in /server/data/) have to be edit on the server manually. In the future everyone can register his PlusCart or his emulator account at the backend to build and edit his own levels and submit them to the public repro.

## Known issues and todos:
* Titlescreen with level selection (my designs generally look ugly, so I hope someone will make a nice design for a titlescreen)
* Helicopter in middle position (facing to you when turning around)
* The enemies don't shot
* Touching anything execpt the soldiers and the filling station will be "deadly" (or at least decrement your score) in the final version
* leaving the first room to the top "crashes" the game (the ROM sends a request, but the server doesn't have a room stored at this position)
* occasional crashes when exiting/entering a new room (only on PlusCart and mostly when exiting shortly after entering the room)
* when the fuel runs out (Game Over) the game makes a short sound and then stops (restart with reset and then pressing the joystick button)
* The online level Editor is currently just a viewer and don't shows the enemies

## Screenshots

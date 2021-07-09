# C.A.V.E. Apocalypse

C.A.V.E. Apocalypse is an online game for the Atari 2600. It uses PlusROM functions which are supported by [Gopher2600](https://github.com/JetSetIlly/Gopher2600), [My Javatari fork](https://github.com/Firmaplus/javatari.js) and the [PlusCart](https://pluscart.firmaplus.de)

The game is programmed in [batari Basic](https://github.com/batari-Basic/batari-Basic), but to compile it the PlusROM extensions of my [batari Basic fork](https://github.com/Al-Nafuur/batari-Basic) have to be used, see this [AtariAge thread](https://atariage.com/forums/topic/314343-plusrom-function-online-gaming-support-for-batari-basic) howto include the PlusROM extensions.

Various code examples from [randomterrain's awesome batari Basic webpage](https://www.randomterrain.com/atari-2600-memories.html#batari_basic) and various AtariAge threads are used in this code.

## Technical Description 
When starting a game or changing a room the room information is requested from the server (/server/a.php) and the state of the room left is send in the request to store it in the server side session.

The website for the level/room editor can be found [here](https://cave-apocalypse.firmaplus.de/editor.php), but the rooms can only be viewed so far, editing on the website is not working yet. The level files (in /server/data/) have to be edit on the server manually. In the future everyone can register his PlusCart or his emulator account at the backend to build and edit his own levels and submit them to the public repro.

## Known issues and todos:
* Return to titlescreen with joystick button when game is over. 
* Titlescreen has no music
* Game-Number and level on titlescreen reset after game over.

## Screenshots

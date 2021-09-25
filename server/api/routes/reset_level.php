<?php

// live lost reset to last safe point
$old_room  = $game_status["r"];
$game_status["s"][$old_room] = array_slice($Request->data, 0, -1);
$game_status["r"] = $game_status["sr"];
include("./data".$game_status["dir"]."/Level_".$game_status["l"]."/Room_".$game_status["r"].".php");

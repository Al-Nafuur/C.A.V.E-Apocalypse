<?php
/*
 * game start request from client.
 * 
 * responses:
 * 0 = OK goto Map
 * 1 = OK goto Team Select
 * 2 = Error
 * 
 */
        // Player has moved to another room.
        $level = $game_status["l"];
        $old_room  = $game_status["r"];
        $game_status["s"][$old_room] = array_slice($Request->data, 0, -1);
        $direction = $Request->api_route - 3;
        include("./data".$game_status["dir"]."/Level_".$level."/Room_". $old_room.".php");
        if($room["exit"][$direction] != -1){
            $game_status["r"] = $room["exit"][$direction];
            include("./data".$game_status["dir"]."/Level_".$level."/Room_".$game_status["r"].".php");
        }

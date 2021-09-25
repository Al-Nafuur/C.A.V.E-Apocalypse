<?php
/*
 * game start request from client.
 * 
 * responses:
 * 
 */

$game_status["l"] = dechex($Request->data[0]) * 10000 + dechex($Request->data[1]) * 100 + dechex($Request->data[2]);
$game_status["gn"] = $Request->data[3];
$game_status["r"] = 0;
$game_status["sr"] = 0;
$game_status["s"] = [];
$game_status["dir"] = ($game_status["gn"] > 4 && $game_status["ud"]) ? $game_status["ud"] : $game_status["pd"];
if( isRandomGame ($game_status["gn"]) ){
    $game_status["avl"] = range(1, ($game_status["gn"] > 4 && $game_status["ud"]) ?$game_status["ul"] :$game_status["pl"]); // available levels
    shuffle($game_status["avl"]);
    $game_status["l"] = array_shift($game_status["avl"]);
}
$directory = "./data".$game_status["dir"]."/Level_".$game_status["l"];
// Level Bonus timer
$rooms_counter = count( scandir($directory)) -2;
$game_status["lbp"] = $rooms_counter < 5 ? 0x30 : ($rooms_counter > 16 ? 0x99 : hexdec($rooms_counter * 6 ));
include($directory."/Room_0.php");

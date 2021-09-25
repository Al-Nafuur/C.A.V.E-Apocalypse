<?php
/*
 * Select Team request from client.
 * 
 * responses:
 * 0 = Error
 * 1 = OK Team select
 * 
 */

function sendScoreToHSC($PlusStoreId, $score_array, $level){

    $data = chr($level >> 16 & 0xFF).chr($level >>  8 & 0xFF).chr($level & 0xFF). // Level to 3 byte number
            chr($score_array[0]).chr($score_array[1]).chr($score_array[2]).
            chr(39); // C.A.V.E. Apocalypse game ID in HSC DB

    if($_SERVER['HTTP_PLUSROM_INFO']){
        $plusrom_header = "PlusROM-Info: " . $_SERVER['HTTP_PLUSROM_INFO'];
    }else{
        $plusrom_header = "PlusStore-ID: " . $_SERVER['HTTP_PLUSSTORE_ID'];
    }
    
    $options = array (
        'http' => array (
            'method' => 'POST',
            'header'=> "Content-Type: application/octet-stream\r\n".
                       "Content-Length: " . strlen($data) . "\r\n".
                       $plusrom_header . "\r\n",
            'content' => $data
        )
    );
    $context  = stream_context_create($options);

    file_get_contents("https://h.firmaplus.de/a.php", false, $context);
}

// end level goto next level
if($game_status["gn"] < 5){  // send public Levels to the HSC
    $HSC_level = ($game_status["gn"] & 1 ) ? $game_status["l"] : $game_status["l"] + 25;
    sendScoreToHSC($PlusStoreId, $Request->data, $HSC_level);
}
if( isRandomGame ($game_status["gn"]) ){
    if(empty($game_status["avl"])){
        $game_status["avl"] = range(1, ($game_status["gn"] > 4 && $game_status["ud"]) ?$game_status["ul"] :$game_status["pl"]);
        shuffle($game_status["avl"]);
    }
    $game_status["l"] = array_shift($game_status["avl"]);
} else {
    $game_status["l"]++;
}

if(! is_dir("./data".$game_status["dir"]."/Level_".$game_status["l"])){
    // start in level 1 again after last level?
    $game_status["l"] = 1;
}
$game_status["r"] = 0;
$game_status["sr"] = 0;
$game_status["s"] = [];
$directory = "./data".$game_status["dir"]."/Level_".$game_status["l"];

// Level Bonus timer
$rooms_counter = count( scandir($directory)) -2;
$game_status["lbp"] = $rooms_counter < 5 ? 0x30 : ($rooms_counter > 16 ? 0x99 : hexdec($rooms_counter * 6 ));

// Count number of files and store them to variable..
$num_files = count($files)-2;
include($directory."/Room_0.php");

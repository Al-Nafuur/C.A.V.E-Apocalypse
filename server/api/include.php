<?php
spl_autoload_register(function ($class_name){
    include './api/classes/'.$class_name . '.php';
});

$config = [
    "prefix_room" => "Room_",
    "prefix_level" => "Level_",
];

$api_routes = [
 "game_start",      // 0
 "level_done",      // 1
 "game_over",       // 2
 "leave_room",      // 3 left
 "leave_room",      // 4 top
 "leave_room",      // 5 right
 "leave_room",      // 6 bottom
 "reset_level",     // 7
 "set_save_point",  // 8
 "load_menu",       // 9

];

function isRandomGame($gn){
    return ($gn == 3 || $gn == 4 || $gn > 6 );
}

function logging($Request){
    file_put_contents ("../../extras/clog/cave-apocalypse.log", date("Y-m-d H:i:s").": PS-ID: ".$Request->plusrom_header_raw." LENGHT: ".$Request->data_length." BYTES: ".implode ( ", " , $Request->data )."\n", FILE_APPEND );
}


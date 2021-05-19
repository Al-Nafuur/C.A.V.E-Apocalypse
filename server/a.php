<?php

function loging($PlusStoreId, $post_array, $post_data_len){
    file_put_contents ("../../extras/clog/cave-apocalypse.log", date("Y-m-d H:i:s").": PlusStore-ID: ".$PlusStoreId." POST_DATA_LENGHT: ".$post_data_len." POST_DATA_BYTES: ".implode ( ", " , $post_array )."\n", FILE_APPEND );
}


if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $PlusStoreId = $_SERVER['HTTP_PLUSSTORE_ID'];
    $PlusStoreId_parts   = explode(" ", $PlusStoreId);
    $device_id           = array_pop( $PlusStoreId_parts );
    $nickname_or_version = implode( " ", $PlusStoreId_parts );
    $isWebEmulator =  (substr( $device_id, 0, 2 ) == "WE" );

    session_id($device_id);
    session_start(["use_cookies" => false, "use_only_cookies" => false, "use_trans_sid" => false]);

    $post_data = file_get_contents("php://input");
    $post_data_len = strlen($post_data);
    $post_array = [];
    $actions = ["Load", "Level-Up", "Game-Over", "Left","Up","Right","Down","Reset", "Safe Point", "Game Menu"];
    for ( $pos=0; $pos < $post_data_len; $pos ++ ) {
        $post_array[] = ord(substr($post_data, $pos));
    }

    loging($PlusStoreId, $post_array, $post_data_len );
    
    header('Content-Type: application/octet-stream');
    if( $isWebEmulator)
        header('Access-Control-Allow-Origin: *');

    $game_status = $_SESSION;
    $req = array_pop($post_array) ;
    $action = $req & 127;
    if ($action > 47){
        $action -= 48;
    }
    $tv_mode = ($req > 127)?1:0; // 0=NTSC 1=PAL
    $resp = "";
    $load_room = true;
    $save_session = true;

    if( $action == 0 ){
        $level = dechex($post_array[0]) * 10000 + dechex($post_array[1]) * 100 + dechex($post_array[2]);
        $game_number = $post_array[3];
        $game_status = ["gn" => $game_number, "l" => $level, "r" => 0, "sr" => 0,  "s" => []];
        if($game_number == 2 || $game_number == 4){
            $game_status["avl"] = range(1, 3); // available levels
            shuffle($game_status["avl"]);
            $game_status["l"] = array_shift($game_status["avl"]);
        }
        include("./data/Level_".$game_status["l"]."/Room_00.php");
    }elseif($action == 1){
        // end level goto next level
        if($game_status["gn"] == 2 || $game_status["gn"] == 4){
            if(empty($game_status["avl"])){
                $game_status["avl"] = range(1, 3);
                shuffle($game_status["avl"]);
            }
            $game_status["l"] = array_shift($game_status["avl"]);
        } else {
            $game_status["l"]++;
        }

        if(! is_dir("./data/Level_".$game_status["l"])){
            // start in level 1 again after last level?
            $game_status["l"] = 1;
        }
        $game_status["r"] = 0;
        $game_status["sr"] = 0;
        $game_status["s"] = [];
        include("./data/Level_".$game_status["l"]."/Room_00.php");
    }elseif($action == 2){
        // game lost (todo save score for this level in High Score List)
        unset( $_SESSION );
        $load_room = false;
        $save_session = false;
    }elseif($action == 7){
        // live lost reset to last safe point
        $game_status["r"] = $game_status["sr"]; 
        include("./data/Level_".$game_status["l"]."/Room_".sprintf("%'.02d",$game_status["r"]).".php");
    }elseif($action == 8){
        // safe point (fuel station) in current room reached
        $game_status["sr"] = $game_status["r"];
        $load_room = false;
    }elseif($action == 9){
        // load game menu ( max public levels 3xBCD and max private levels 3xBCD)
        unset( $_SESSION );
        $load_room = false;
        $save_session = false;
        $resp .= chr(0).chr(0).chr(0x03).chr(0).chr(0).chr(0);
    }else{
        // Player has moved to another room.
        $level = $game_status["l"];
        $old_room  = $game_status["r"];
        $game_status["s"][$old_room] = $post_array;
        $direction = $action - 3;
        include("./data/Level_".$level."/Room_".sprintf("%'.02d", $old_room).".php");
        if($room["exit"][$direction] != -1){
            $game_status["r"] = $room["exit"][$direction];
            include("./data/Level_".$level."/Room_".sprintf("%'.02d",$game_status["r"]).".php");
        }
    }


    if($load_room){
        $resp .= chr($room["first_last"]);

        $cl_len = count($room["color_".$tv_mode]);
        for ( $pos=0; $pos < $cl_len; $pos++ ) {
            $resp .= chr($room["color_".$tv_mode][$pos]);
        }
    
        // check if we have been in this room before.
        if(isset($game_status["s"][$game_status["r"]]) && count($game_status["s"][$game_status["r"]]) > 0 ){
            // add extra wall and enemy status from session cache!
            $ew_len = count($game_status["s"][$game_status["r"]]);
            for ( $pos=0; $pos < $ew_len; $pos ++ ) {
                $resp .= chr($game_status["s"][$game_status["r"]][$pos]);
            }
    
        }else{
            // add extra wall and enemy status from room definition!
            $ew_len = count($room["interior"]);
            for ( $pos=0; $pos < $ew_len; $pos ++ ) {
                $resp .= chr($room["interior"][$pos]);
            }
        }
        $pf_len = count($room["pf"]);
        for ( $pos=0; $pos < $pf_len; $pos ++ ) {
            $resp .= chr($room["pf"][$pos]);
        }

    }


    $resp_len = strlen($resp);
    file_put_contents ("../../extras/clog/cave-apocalypse.log", "action: ".$actions[$action]." to room: ".$game_status["r"]." lvl: ".$game_status["l"]." TV: ".$tv_mode." cache_len: ".count($game_status["s"])." respsize ".$resp_len."\n", FILE_APPEND );
    header('Content-Length: '.($resp_len + 1) );

    echo chr($resp_len).$resp;
    if($save_session)
        $_SESSION = $game_status; // todo cache for 6 min ?

}else if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
        header('Access-Control-Allow-Origin: *');
        header('Access-Control-Allow-Headers: PlusStore-ID,Content-Type');
}else{
    echo "Wrong Request Method!\r\n";
}
?>
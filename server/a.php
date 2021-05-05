<?php
include("../../extras/global_FileCache.php");

function loging($PlusStoreId, $post_array, $post_data_len){
    file_put_contents ("../../extras/clog/cave-apocalypse.log", date("Y-m-d H:i:s").": PlusStore-ID: ".$PlusStoreId." POST_DATA_LENGHT: ".$post_data_len." POST_DATA_BYTES: ".implode ( ", " , $post_array )."\n", FILE_APPEND );
}


if ($_SERVER['REQUEST_METHOD'] === 'POST') {
/*
    if(sleep(1) !== false){
        file_put_contents ("../../extras/clog/cave-apocalypse.log", "sleep success " , FILE_APPEND );
    }else{
        file_put_contents ("../../extras/clog/cave-apocalypse.log", "sleep failed " , FILE_APPEND );
    }
*/

    $PlusStoreId = $_SERVER['HTTP_PLUSSTORE_ID'];
    $PlusStoreId_parts   = explode(" ", $PlusStoreId);
    $device_id           = array_pop( $PlusStoreId_parts );
    $nickname_or_version = implode( " ", $PlusStoreId_parts );
    $isWebEmulator =  (substr( $device_id, 0, 2 ) == "WE" );

    $options = array('cache_dir' => 'cavea');
    $cache = new FileCache($options);

    $post_data = file_get_contents("php://input");
    $post_data_len = strlen($post_data);
    $post_array = [];
    $actions = ["load", "level-up", "game-over", "Left","Up","Right","Down"];
    for ( $pos=0; $pos < $post_data_len; $pos ++ ) {
        $post_array[] = ord(substr($post_data, $pos));
    }

    loging($PlusStoreId, $post_array, $post_data_len );
    
    header('Content-Type: application/octet-stream');
    if( $isWebEmulator)
        header('Access-Control-Allow-Origin: *');

//    include("php_img/cave_apocalypse_1.php");

    $game_status = $cache->get( $PlusStoreId );
    $action = empty($game_status)?0:array_pop($post_array);
    if( $action == 0 || $action == 48 ){
        $game_status = ["r" => 0, "l" => 1, "s" => []];
        include("./data/Level_1/Room_00.php");
    }elseif($action == 1){ // end level goto next level
        $game_status["l"]++;
        if(! is_dir("./data/Level_".$game_status["l"])){ // start in level 0 again after last level?
            $game_status["l"] = 0;
        }
        $game_status["r"] = 0;
        $game_status["s"] = [];
    }elseif($action == 2){ // game lost
        $cache->delete( $PlusStoreId );
        header('Content-Length: 1' );
        echo chr(0);
        exit;
    }else{ // Player has moved to another room.
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

    $resp = ""; // = file_get_contents(); // binary room definition from file..

    // check if we have been in this room before.
    if(isset($game_status["s"][$game_status["r"]]) && count($game_status["s"][$game_status["r"]]) > 0 ){// add extra wall and enemy status from session cache!
        $ew_len = count($game_status["s"][$game_status["r"]]);
        for ( $pos=0; $pos < $ew_len; $pos ++ ) {
            $resp .= chr($game_status["s"][$game_status["r"]][$pos]);
        }

    }else{// add extra wall and enemy status from room definition!
        $ew_len = count($room["interior"]);
        for ( $pos=0; $pos < $ew_len; $pos ++ ) {
            $resp .= chr($room["interior"][$pos]);
        }
    }
    $pf_len = count($room["pf"]);
    for ( $pos=0; $pos < $pf_len; $pos ++ ) {
        $resp .= chr($room["pf"][$pos]);
    }

    $resp_len = strlen($resp);
    file_put_contents ("../../extras/clog/cave-apocalypse.log", "action: ".$actions[$action]." room: ".$game_status["r"]." cache_len: ".count($game_status["s"])." respsize ".$resp_len."\n", FILE_APPEND );
    header('Content-Length: '.($resp_len + 1) );

    echo chr($resp_len).$resp;
    $cache->save( $PlusStoreId , $game_status, 360 ); // cache for 6 min!
    
}else if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
        header('Access-Control-Allow-Origin: *');
        header('Access-Control-Allow-Headers: PlusStore-ID,Content-Type');
}else{
    echo "Wrong Request Method!\r\n";
}
?>
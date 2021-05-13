<?php
include("../../extras/global_FileCache.php");

function loging($PlusStoreId, $post_array, $post_data_len){
    file_put_contents ("../../extras/clog/cave-apocalypse.log", date("Y-m-d H:i:s").": PlusStore-ID: ".$PlusStoreId." POST_DATA_LENGHT: ".$post_data_len." POST_DATA_BYTES: ".implode ( ", " , $post_array )."\n", FILE_APPEND );
}


if ($_SERVER['REQUEST_METHOD'] === 'POST') {
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
    $actions = ["Load", "Level-Up", "Game-Over", "Left","Up","Right","Down","Reset"];
    for ( $pos=0; $pos < $post_data_len; $pos ++ ) {
        $post_array[] = ord(substr($post_data, $pos));
    }

    loging($PlusStoreId, $post_array, $post_data_len );
    
    header('Content-Type: application/octet-stream');
    if( $isWebEmulator)
        header('Access-Control-Allow-Origin: *');

    $game_status = $cache->get( $PlusStoreId );
    $req = array_pop($post_array) ;
    $action = empty($game_status)?0:($req & 127);
    $tv_mode = ($req > 127)?1:0; // 0=NTSC 1=PAL
    if( $action == 0 || $action == 48 ){
        $level = 1;
        $game_status = ["r" => 0, "l" => $level, "sr" => 0,  "s" => []];
        include("./data/Level_".$game_status["l"]."/Room_00.php");
    }elseif($action == 1){ // end level goto next level
        $game_status["l"]++;
        if(! is_dir("./data/Level_".$game_status["l"])){ // start in level 1 again after last level?
            $game_status["l"] = 1;
        }
        $game_status["r"] = 0;
        $game_status["sr"] = 0;
        $game_status["s"] = [];
        include("./data/Level_".$game_status["l"]."/Room_00.php");
    }elseif($action == 7){ // live lost reset to last safe point
        $game_status["r"] = $game_status["sr"]; 
        include("./data/Level_".$game_status["l"]."/Room_".sprintf("%'.02d",$game_status["r"]).".php");
    }elseif($action == 8){ // save point (fuel station) in current room reached
        $game_status["sr"] = $game_status["r"];
        $cache->save( $PlusStoreId , $game_status, 360 ); // cache for 6 min!
        header('Content-Length: 1' );
        echo chr(0);
        exit;
    }elseif($action == 2){ // game lost (todo save points for this level in High Score List)
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

    $resp = chr($room["first_last"]);

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

    $resp_len = strlen($resp);
    file_put_contents ("../../extras/clog/cave-apocalypse.log", "action: ".$actions[$action]." to room: ".$game_status["r"]." lvl: ".$game_status["l"]." TV: ".$tv_mode." cache_len: ".count($game_status["s"])." respsize ".$resp_len."\n", FILE_APPEND );
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
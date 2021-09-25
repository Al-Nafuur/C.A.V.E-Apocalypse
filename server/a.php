<?php

if ($_SERVER['REQUEST_METHOD'] === 'POST' && ( array_key_exists('HTTP_PLUSSTORE_ID', $_SERVER) || array_key_exists('HTTP_PLUSROM_INFO', $_SERVER))) {
    include("./api/include.php");

    $Request = new PlusROMrequest();
    $Response = new PlusROMresponse();

    session_id($Request->device["id"]);
    session_start(["use_cookies" => false, "use_only_cookies" => false, "use_trans_sid" => false]);

    logging($Request );

    $game_status = $_SESSION;

    $load_room = true; // both to $Request ?
    $save_session = true;

//    print_r($Request);

    if(array_key_exists($Request->api_route, $api_routes) ){
        include("./api/routes/".$api_routes[$Request->api_route].".php");
    }

//    print_r($game_status);

    if($load_room){
        // Level data
        $Response->add_byte($game_status["lbp"]); // max level bonus BCD value (todo add to editor API and room["lpb"]!)
        $Response->add_byte($room["mtr_c"]);      // men to rescue
        // room data
        $Response->add_byte($room["first_last"]);
        $cl_len = count($room["color_".$Request->tv_mode]);
        for ( $pos=0; $pos < $cl_len; $pos++ ) {
            $Response->add_byte($room["color_".$Request->tv_mode][$pos]);
        }
        // check if we have been in this room before.
        if(isset($game_status["s"][$game_status["r"]]) && count($game_status["s"][$game_status["r"]]) > 0 ){
            // add extra wall and enemy status from session cache!
            $ew_len = count($game_status["s"][$game_status["r"]]);
            for ( $pos=0; $pos < $ew_len; $pos ++ ) {
                $Response->add_byte($game_status["s"][$game_status["r"]][$pos]);
            }
        }else{
            // add extra wall and enemy status from room definition!
            $ew_len = count($room["interior"]);
            for ( $pos=0; $pos < $ew_len; $pos ++ ) {
                $Response->add_byte($room["interior"][$pos]);
            }
            if($ew_len == 8){
                $Response->add_bytes([200, 200]); // disable second wall !
            }
        }
        $pf_len = count($room["pf"]);
        for ( $pos=0; $pos < $pf_len; $pos ++ ) {
            $Response->add_byte($room["pf"][$pos]);
        }
    }

//    print_r($Response);
file_put_contents ("../../extras/clog/cave-apocalypse.log", " info: level ".$game_status["l"]." room ".$game_status["r"]."\n", FILE_APPEND );

    $Response->send();

    if($save_session)
        $_SESSION = $game_status; // todo cache for 6 min ?

}else if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    header('Access-Control-Allow-Origin: '.$_SERVER['HTTP_ORIGIN']);
    header('Access-Control-Allow-Headers: PlusRom-Info,PlusStore-ID,Content-Type');
}else{
    echo "Wrong Request Method!\r\n";
}


?>
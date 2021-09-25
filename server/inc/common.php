<?php

function getLevelNrListByUserName($username, $base_path){
    $level_nr_list = [];
    if ($handle = opendir($base_path.$username)) {
        while (false !== ($entry = readdir($handle))) {
            if(substr_compare($entry, $GLOBALS["config"]["prefix_level"], 0, strlen($GLOBALS["config"]["prefix_level"]) ) == 0){
                $level_nr_list[] = intval( str_replace($GLOBALS["config"]["prefix_level"], "", $entry));
            }
        }
        sort ($level_nr_list, SORT_NUMERIC);
        closedir($handle);
    }
    return $level_nr_list;
}

function isRandomGame($gn){
    return ($gn == 3 || $gn == 4 || $gn > 6 );
}

function sendScoreToHSC($PlusStoreId, $score_array, $level){

    $data = chr($level >> 16 & 0xFF).chr($level >>  8 & 0xFF).chr($level & 0xFF). // Level to 3 byte number
            chr($score_array[0]).chr($score_array[1]).chr($score_array[2]).
            chr(39); // C.A.V.E. Apocalypse game ID in HSC DB

    $options = array (
        'http' => array (
            'method' => 'POST',
            'header'=> "Content-Type: application/octet-stream\r\n".
                       "Content-Length: " . strlen($data) . "\r\n".
                       "PlusStore-ID: " . $PlusStoreId . "\r\n",
            'content' => $data
        )
    );
    $context  = stream_context_create($options);

    file_get_contents("https://h.firmaplus.de/a.php", false, $context);


}
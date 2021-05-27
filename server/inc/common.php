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

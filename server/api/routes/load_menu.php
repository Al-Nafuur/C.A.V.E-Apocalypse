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



// load game menu ( max public levels 3xBCD and max private levels 3xBCD)
$db = new mysqli("DB-Server", "DB-User", "passwort", "Database");

$query = "SELECT users.username FROM users, plusrom_devices WHERE plusrom_devices.user_id = users.id AND plusrom_devices.device_hash = '".$Request->device["id"]."' ";
$result = $db->query($query);
if($result->num_rows == 1 ){
    $user = $result->fetch_assoc();
    $user_dir = "/".$user["username"];
    $user_level = count(getLevelNrListByUserName($user["username"], "./data/"));
}else{
    $user_dir = false;
    $user_level = 0;
}
$game_status = ["ul" => $user_level, "pl" => count(getLevelNrListByUserName("admin", "./data/")), "ud" => $user_dir, "pd" => "/admin" ];

$Response->add_bytes([hexdec(intval($game_status["pl"] / 10000)),
                     hexdec(intval($game_status["pl"] / 100)),
                     hexdec(intval($game_status["pl"])),
                     hexdec(intval($game_status["ul"] / 10000)),
                     hexdec(intval($game_status["ul"] / 100)),
                     hexdec(intval($game_status["ul"]))]);

$load_room = false;

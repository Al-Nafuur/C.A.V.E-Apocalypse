<?php
class Player {
    protected mysqli $db;
    protected string $device_hash;
    protected array $data;

    function __construct($device_hash) {
        $this->device_hash = $device_hash;
        $this->db = new mysqli("DB-Server", "DB-User", "passwort", "Database");
        $this->get_player_data();
    }

    public function __get($var){
        return ($var != "db" && isset($this->$var)) ? $this->$var : false;
    }

    private function get_player_data(){
        $query = "SELECT users.username FROM users, plusrom_devices WHERE plusrom_devices.user_id = users.id AND plusrom_devices.device_id = '".$Request->device["id"]."' ";
        $result = $this->db->query($query);
        if($result->num_rows == 1 ){
            $this->data = $result->fetch_assoc();
            $this->user_dir = "/".$user["username"];
            $this->user_level = count(getLevelNrListByUserName($user["username"], "./data/"));
        }else{
            $this->user_dir = false;
            $this->user_level = 0;
        }
    }
}

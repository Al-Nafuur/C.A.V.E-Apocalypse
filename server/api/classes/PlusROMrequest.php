<?php
class PlusROMrequest {
    protected array $data;
    protected int $api_route;
    protected int $data_length;
    protected int $tv_mode;
    protected string $plusrom_header_raw;
    protected array $device;

    function __construct() {
        $this->parse_request_payload();
        $req = end($this->data) ;
        $this->api_route = $req & 127;
        if ($this->api_route > 47){ // send char as action ?
            $this->api_route -= 48;
        }
        $this->tv_mode = ($req > 127)?1:0; // 0=NTSC 1=PAL

        if($_SERVER['HTTP_PLUSROM_INFO']){
            $this->plusrom_header_raw = $_SERVER['HTTP_PLUSROM_INFO'];
            $this->parse_plusrom_header();
        }else{
            $this->plusrom_header_raw = $_SERVER['HTTP_PLUSSTORE_ID'];
            $plusrom_header_raw_parts  = explode(" ", $this->plusrom_header_raw);
            $this->device["id"] = array_pop( $plusrom_header_raw_parts );
            if( substr( $this->device["id"], 0, 2 ) == "WE" || strlen($this->device["id"]) != 24 || !ctype_xdigit($this->device["id"]) ){
                $this->device["agent"] = "Emulator";
                $this->device["hash"] = $this->device["id"];
                $this->device["nick"] = implode( " ", $plusrom_header_raw_parts );
                if($this->device["nick"] == "v0.6.0"){
                    $this->device["nick"] = "unknown";
                }
            }else{
                $this->device["agent"] = "PlusCart";
                $this->device["nick"] = "unknown";
                $this->device["id"] = md5($this->device["id"]); // old PlusCart firmware doesn't hash the device_id, but to match them after an update in our DB
            }
        }
    
    }

    public function __get($var){
        return ($var != "db" && isset($this->$var)) ? $this->$var : false;
    }

    private function parse_request_payload(){
        $post_data = file_get_contents("php://input");
        $post_data_len = strlen($post_data);
        $this->data = [];
        for ( $pos=0; $pos < $post_data_len; $pos ++ ) {
            $this->data[] = ord(substr($post_data, $pos));
        }
        $this->data_length = count($this->data);
    }


    private function parse_plusrom_header(){
        // Explode the plusrom header string using a series of semicolons
        $pieces = array_filter(array_map('trim', explode(';', $this->plusrom_header_raw )));

        if (empty($pieces) ) {
            return false;
        }

        // Add the plusrom header pieces into the parsed data array
        foreach ($pieces as $part) {
            $plusrom_header_parts = explode('=', $part, 2);
            $key = trim($plusrom_header_parts[0]);

            if (count($plusrom_header_parts) == 2) {
                // Be sure to strip wrapping quotes
                $this->device[$key] = trim($plusrom_header_parts[1], " \n\r\t\0\x0B\"");
            }
        }
        if(empty($this->device["nick"]) ){
            $this->device["nick"] = "unknown";
        }
        $this->device["device_hash"] = $this->device["id"];
    }
}
<?php
class PlusROMresponse {
    protected array $data;

    function __construct() {
        $this->data = [];
    }

    public function __get($var){
        return $this->$var;
    }

    public function add_byte($value){
        $this->data[] = $value;
    }

    public function add_bytes($values){
        foreach($values as $value){
            $this->data[] = $value;
        }
    }

    public function add_char($value){
        $this->data[] = ord($value);
    }

    public function add_string($value){
        $array_value = str_split($value );
        foreach($array_value as $value){
            $this->data[] = ord($value);
        }
    }

    public function send(){
        $payload_length = count($this->data);

        // 1 byte response 0 byte payload..
        header('Content-Type: application/octet-stream');
        if( $_SERVER['HTTP_ORIGIN'] )
            header('Access-Control-Allow-Origin: '.$_SERVER['HTTP_ORIGIN']);
        header('Content-Length: '.( $payload_length + 1 ) );
        echo chr($payload_length); // First byte ist Content-Length of the payload
        foreach($this->data as $value)
            echo chr($value);
    }
}
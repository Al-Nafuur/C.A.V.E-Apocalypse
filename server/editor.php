<?php
$level = ($_GET["level"] && ( preg_match('/^Level_\d+$/', $_GET["level"]) || preg_match('/^Level_t_\d+$/', $_GET["level"])) )?$_GET["level"]:"Level_1";

?><!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-type" content="text/html; charset=utf-8">
	<meta name="viewport" content="width=device-width,initial-scale=1,user-scalable=no">
    <link rel="shortcut icon" href="/favicon.ico">
	<title>C.A.V.E. Apocalypse Map Editor</title>
    <script charset="utf8" src="https://code.jquery.com/jquery-3.3.1.js"></script>

 <link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css"> 
 <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">

 <link rel="stylesheet" href="./assets/css/editor.css"> 
 <script src="./assets/js/editor.js"></script>
<script>
$(document).ready(function() {
<?
    $rooms_rendered = [];
    echo "var element = $('#LevelMap td:first');\n";
    foreach (glob("./data/".$level."/Room_*.php") as $filename) {
        include($filename);
        $room_id = basename($filename, ".php");
        if($room_id != "Room_0"){
            // find a Room that is already rendered in the exits of the new room here.
            foreach($room["exit"] As $id => $exit_id ){
                $exit = sprintf("%'.02d", $exit_id);
                if(in_array ("Room_".$exit, $rooms_rendered) ){
                    switch ($id) { // room_nr: left, top, right, bottom
                        case 0: // left
                            echo "addColumn(true);\n";
                            echo "element = $('#Room_".$exit."').next('td');\n";
                            break;
                        case 1: // top
                            echo "addRow(true);\n";
                            echo "element = $('#Room_".$exit."').closest('tr').next().children().eq($('#Room_".$exit."').index());\n";
                            break;
                        case 2: // right
                            echo "addColumn(false);\n";
                            echo "element = $('#Room_".$exit."').prev('td');\n";
                            break;
                        case 3: // bottom
                            echo "addRow(false);\n";
                            echo "element = $('#Room_".$exit."').closest('tr').prev('tr').children().eq($('#Room_".$exit."').index());\n";
                            break;
                    }
                }
            }
        }
        echo "element.attr('id', '".$room_id."').attr('title', '".$room_id."');\n";
        echo "element.html(renderSmallRoom(".json_encode($room)."));\n";
        $rooms_rendered[] = $room_id;
    }
    echo "/* rooms_rendered: ".print_r($rooms_rendered, true)."\n */";
?>

});
</script>

</head>
<body>

<div class="box nav-box">
<h1><a href="index.php">C.A.V.E. Apocalypse Map Editor</a></h1>
<form id="main_form" method="GET">
<div class="w3-bar w3-black">
<?
    if ($handle = opendir("./data")) {
        while (false !== ($entry = readdir($handle))) {
            if($entry != "."  && $entry != ".."  ){
                echo '<button class="w3-bar-item w3-button'.($level==$entry?' w3-blue':'').'" name="level" value="'.$entry.'">'.$entry.'</button>';
            }
        }
        closedir($handle);
    }
?>
</div> 
</form>
</div>

<div class="box content-box level-map">
<div class="function-container">
<button class="w3-button w3-black" onclick="addColumn(false)">Add Column Left</button>
<button class="w3-button w3-black" onclick="addRow(false)">Add Row Top</button>
<button class="w3-button w3-black" onclick="addRow(true)">Add Row Bottom</button>
<button class="w3-button w3-black" onclick="addColumn(true)">Add Column Right</button>
</div>
<div class="map-container w3-padding-16">
<table id="LevelMap" class="w3-centered display" border="0" cellpadding="0" cellspacing="0">
    <tr class="grid"><td class="grid"></td></tr>
</table>
</div>
</div>

<div id="room_editor" class="w3-modal">
  <div class="w3-modal-content w3-animate-top" style="height: 90%">

    <header class="w3-container w3-text-white" style="background-color: #37609f">
      <span onclick="document.getElementById('player_stat').style.display='none'"
      class="w3-button w3-display-topright">&times;</span>
      <h2>Edit Room </h2>
    </header>

    <div class="w3-container" id="room_content" style="height: 90%; overflow: auto">
    </div>

  </div>
</div> 

<div id="patch_lightbox" class="w3-modal" onclick="this.style.display='none'"></div>

</body>
</html>
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

<script>
var tCell = '<td class="grid"><span onclick="addRoom()" class="w3-button w3-blue">+Room</span></td>';

function showPlayerInfo(room){
    $("#room_content").load("edit-room.php?room=" + encodeURIComponent(room));
    $("#room_editor h2").text("Edit Room " + room);
    document.getElementById('room_editor').style.display="block";
    return false;
}

function openLightbox(img_hash){
    $("#patch_lightbox").html('<span class="w3-button w3-hover-red w3-xlarge w3-display-topright">&times;</span>' +
                              '<div class="w3-modal-content w3-animate-zoom"><img src="/directus/public/plusrom-high-score-club/assets/' + img_hash + '?key=lightbox" style="width:100%"></div>').show();
}

function addRow(append){
    var rows = $("#LevelMap").find("tr.grid:first td.grid").length;
    if(append)
        $('#LevelMap tr.grid:last').after('<tr class="grid">' + tCell.repeat(rows) + '</tr>');
    else
        $('#LevelMap tr.grid:last').before('<tr class="grid">' + tCell.repeat(rows) + '</tr>');
}

function addColumn(append){
    $('#LevelMap tr.grid').each(function(){
        var trow = $(this);
        if(append){
            trow.append(tCell);
        } else {
            trow.prepend(tCell);
        }
    });
}

function renderSmallRoom( room ){ 
//    var ar = [ [0xff,room.pf[3],room.pf[6] ],  [room.pf[0],room.pf[2],room.pf[5]],  [0xff,room.pf[1],room.pf[4] ] ];
    var pos_brk_wall = room.interior[5] - 15;// (room.brk_wall & 0xFC) - 8; // 8 - 152  (0x08 - 0x98)
    var pos_eny_bot = 200;//(room.eny_lmp[0] & 0xFC) - 8; // 8 - 152  (0x08 - 0x98)
    var pos_eny_mid = 200;//(room.eny_lmp[1] & 0xFC) - 8; // 8 - 152  (0x08 - 0x98)
    var pos_lmp_top = 200;//(room.eny_lmp[2] & 0xFC) - 8; // 8 - 152  (0x08 - 0x98)
    var eny_color = ["yellow", "green", "blue", "magenta" ];
    var ret = '';
    ret += '<table border="0" cellpadding="0" cellspacing="0"><tr>';
    room.pf.forEach( (pf_b, block_id) => {
        var i = 0;
        for(; i<8; i++){
            var mask = (block_id % 2 == 0)?(2 ** (7-i)):(2 ** i);
            ret += "<td style=\"background" + ((pf_b & mask)>0?"-color: brown":": rgba(0, 0, 0, 0)")  + "\">&nbsp</td>"
        }
        if(block_id == 3 || block_id == 7)
            ret += "</tr><tr>";
    });
    ret += "</tr></table>";
    if(pos_brk_wall >= 0 &&  pos_brk_wall <= 144){
        ret += '<div class="brk_wall" style="left: ' + pos_brk_wall + 'px; ' + ((room.interior[4] > 0) ? 'animation: magma_wall 2s infinite alternate' :'background-color: brown') + '"></div>';
    }
    if(pos_eny_bot >= 0 &&  pos_eny_bot <= 144){
        ret += '<div class="eny_bot" style="left: ' + pos_eny_bot + 'px; background-color: ' +  eny_color[(room.eny_lmp[0] & 3)] + '"></div>';
    }
    if(pos_eny_mid >= 0 &&  pos_eny_mid <= 144){
        ret += '<div class="eny_mid" style="left: ' + pos_eny_mid + 'px; background-color: ' + eny_color[(room.eny_lmp[1] & 3)] + '"></div>';
    }
    if(pos_lmp_top >= 0 &&  pos_lmp_top <= 144){
        ret += '<div class="lmp_top" style="left: ' + pos_lmp_top + 'px; background-color: white;"></div>';
    }
    return ret;
}

$(document).ready(function() {
<?
    $rooms_rendered = [];
    echo "var element = $('#LevelMap td:first');\n";
    foreach (glob("./data/".$level."/Room_*.php") as $filename) {
        include($filename);
        $room_id = basename($filename, ".php");
        if($room_id != "Room_0"){
            // find a Room that is allready rendered in the exits of the new room here.
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
<style>
body {background-color: #37609f; font-family: 'Droid Sans', 'Helvetica', 'Arial', sans-serif; color: #333}
.box {width:80%; border: 2px solid black; padding:10px; margin: auto}
@media only screen and (max-device-width: 640px) {
   .box {width:100%; border: 0; padding:0px}
   .w3-bar .w3-bar-item { padding: 8px 4px}
}
.nav-box {background-image: linear-gradient(to right, #37609f 0%, #67b9DD 80%)}
.content-box {background-color: #f0f0f0; margin-top: 10px }
.level-map {overflow-x: scroll}
.description {background-color: #ccc; padding: 0 5px; margin: 5px 0 0 0; max-height: 220px; overflow-y: auto;}
h1 a {color: #fff; text-decoration: none}
.nav-box label {color: #fff; font-weight: bold; padding: 20px 16px; display: block; background-color: #000}
#LevelMap, td.grid { border: 1px solid black; border-collapse: collapse; margin:auto; }
.thumbnail:hover { cursor:zoom-in }
td.grid { background-color: black}
.brk_wall {
 position: relative;
 width: 8px;
 height: 22.5px;
 top: -45px;
 margin-bottom: -22.5px;
}
.lmp_top {
 position: relative;
 width: 8px;
 height: 22.5px;
 top: -67.5px;
 margin-bottom: -22.5px;
 z-index: -2;
}

.eny_mid {
 position: relative;
 width: 8px;
 height: 22.5px;
 top: -45px;
 margin-bottom: -22.5px;
}
.eny_bot {
 position: relative;
 width: 8px;
 height: 22.5px;
 top: -22.5px;
 margin-bottom: -22.5px;
}

@keyframes magma_wall {
  from {background-color: #440008;}
  to {background-color: #960640;}
}


</style>
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
<?php
require_once './users/init.php';  //make sure this path is correct!
require_once $abs_us_root.$us_url_root.'users/includes/template/prep.php';
if (!securePage($_SERVER['PHP_SELF'])){die();}

?>

 <link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css"> 

 <script src="https://cdn.jsdelivr.net/npm/spectrum-colorpicker2/dist/spectrum.min.js"></script>
 <link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/npm/spectrum-colorpicker2/dist/spectrum.min.css">

 <link rel="stylesheet" href="./assets/css/editor.css"> 
 <script src="./assets/js/editor.js"></script>
<script>
$(document).ready(function() {
  $(document).mouseup(function () {
    isMouseDown = false;
  });

  loadLevels(false);
  $( "#room_form_mate_range" ).on( "input", function() {
     $( "#mate_range_value" ).html( this.value);
  });
  $( "#room_form_wall_range" ).on( "input", function() {
     $( "#wall_range_value" ).html( this.value);
  });

  $('.color-picker').spectrum({
    type: "color",
    showPaletteOnly: true,
    palette: [
      ["#000000","#1a1a1a","#393939","#5b5b5b","#7e7e7e","#a2a2a2","#c7c7c7","#ededed"],
      ["#190200","#3a1f00","#5d4100","#826400","#a78800","#ccad00","#f2d219","#fefa40"],
      ["#370000","#5e0800","#832700","#a94900","#cf6c00","#f58f17","#feb438","#fedf6f"],
      ["#470000","#730000","#981300","#be3216","#e45335","#fe7657","#fe9c81","#fec6bb"],
      ["#440008","#6f001f","#960640","#bb2462","#e14585","#fe67aa","#fe8cd6","#feb7f6"],
      ["#2d004a","#570067","#7d058c","#a122b1","#c743d7","#ed65fe","#fe8af6","#feb5f7"],
      ["#0d0082","#3300a2","#550fc9","#782df0","#9c4efe","#c372fe","#eb98fe","#fec0f9"],
      ["#000091","#0a05bd","#2822e4","#4842fe","#6b64fe","#908afe","#b7b0fe","#dfd8fe"],
      ["#000072","#001cab","#033cd6","#205efd","#4081fe","#64a6fe","#89cefe","#b0f6fe"],
      ["#00103a","#00316e","#0055a2","#0579c8","#239dee","#44c2fe","#68e9fe","#8ffefe"],
      ["#001f02","#004326","#006957","#008d7a","#1bb19e","#3bd7c3","#5dfee9","#86fefe"],
      ["#002403","#004a05","#00700c","#09952b","#28ba4c","#49e06e","#6cfe92","#97feb5"],
      ["#002102","#004604","#086b00","#289000","#49b509","#6bdb28","#8ffe49","#bbfe69"],
      ["#001501","#103600","#305900","#537e00","#76a300","#9ac800","#bfee1e","#e8fe3e"],
      ["#1a0200","#3b1f00","#5e4100","#836400","#a88800","#cead00","#f4d218","#fefa40"],
      ["#380000","#5f0800","#842700","#aa4900","#d06b00","#f68f18","#feb439","#fedf70"]
    ]
  });

  $('.color-picker-pal').spectrum({
    type: "color",
    showPaletteOnly: true,
    palette: [
      ["#000000","#1a1a1a","#393939","#5b5b5b","#7e7e7e","#a2a2a2","#c7c7c7","#ededed"],
      ["#000000","#1a1a1a","#393939","#5b5b5b","#7e7e7e","#a2a2a2","#c7c7c7","#ededed"],
      ["#1e0000","#3f1c00","#633d00","#886000","#ad8300","#d2a806","#f9cd26","#fef64a"],
      ["#002100","#004600","#0d6a00","#2d9000","#4fb500","#71da06","#95fe26","#c0fe4d"],
      ["#3a0000","#620600","#882500","#ad4500","#d2671b","#f98b3b","#feb05e","#fedb87"],
      ["#002500","#004b00","#007200","#0d9600","#2cbb1c","#4ee13d","#70fe5f","#9cfe8a"],
      ["#470000","#720007","#970f25","#bd2e45","#e34f68","#fe728b","#fe98b2","#fec2dd"],
      ["#002100","#004505","#006c26","#009046","#1cb569","#3ddb8c","#5ffeb1","#88fedd"],
      ["#410026","#6c004f","#920473","#b82298","#de43bd","#fe65e3","#fe8afe","#feb6fe"],
      ["#00112a","#00344f","#005975","#047c9a","#22a0bf","#43c5e5","#65ebfe","#8cfefe"],
      ["#2a0065","#530092","#7804b9","#9c22e0","#c242fe","#e865fe","#fe8afe","#feb6fe"],
      ["#00006b","#001f94","#0040bc","#1d62e2","#3d85fe","#5fa9fe","#84d1fe","#abf9fe"],
      ["#08008e","#2d00bc","#4e10e4","#712ffe","#9550fe","#bb75fe","#e39bfe","#fec2fe"],
      ["#000090","#0608bd","#2425e4","#4445fe","#6667fe","#8b8dfe","#b2b3fe","#dadbfe"],
      ["#000000","#1a1a1a","#393939","#5b5b5b","#7e7e7e","#a2a2a2","#c7c7c7","#ededed"],
      ["#000000","#1a1a1a","#393939","#5b5b5b","#7e7e7e","#a2a2a2","#c7c7c7","#ededed"]
    ]
  });


});
</script>


<div class="box nav-box"><div class="w3-bar w3-black" id="NaviBox"></div></div>

<div class="box content-box level-map">
<div class="function-container">

<button class="w3-button w3-black" onclick="addLevel()">Create New Level</button>
<button class="w3-button w3-black" onclick="saveLevel()">Save Level</button>

Tool: 
<select id="edittool">
 <option value="0">Add Playfield Block</option>
 <option value="1">Delete Playfield Block</option>
 <option value="2">Toggle Playfield Block</option>
 <option value="3">Edit Room</option>
<!-- <option value="7">Delete Room</option> -->
</select>
<br>
<button class="w3-button w3-black" onclick="addColumn(false)">Add Column Left</button>
<button class="w3-button w3-black" onclick="addRow(false)">Add Row Top</button>
<button class="w3-button w3-black" onclick="addRow(true)">Add Row Bottom</button>
<button class="w3-button w3-black" onclick="addColumn(true)">Add Column Right</button>

</div>
<div class="map-container w3-padding-16">
<table id="LevelMap" class="w3-centered display" border="0" cellpadding="0" cellspacing="0">
    
</table>
</div>
<div>
<table style="margin: auto">
 <tr>
  <td><div class="enemy" style="margin-bottom:0; background-color: yellow"></div></td><td>Tank </td>
  <td><div class="enemy" style="margin-bottom:0; background-color: magenta"></div></td><td>Soldiers </td>
  <td><div class="enemy" style="margin-bottom:0; background-color: red"></div></td><td>Air missile </td>
  <td><div class="enemy" style="margin-bottom:0; background-color: blue"></div></td><td>Fuel station </td>
  <td><div class="enemy" style="margin-bottom:0; background-color: brown"></div></td><td>Wall or Laser </td>
 </tr>
</table>
</div>
</div>

<div id="room_editor" class="w3-modal">
  <div class="w3-modal-content w3-animate-top" style="height: 90%">

    <header class="w3-container w3-text-white" style="background-color: #37609f">
      <span onclick="modifyRoomData()" class="w3-button w3-display-topleft">Change</span>
      <span onclick="document.getElementById('room_editor').style.display='none'" class="w3-button w3-display-topright">&times;</span>
      <h2 class="w3-center">Edit Room </h2>
    </header>

    <div class="w3-container" id="room_content" style="height: 90%; overflow: auto">
    <form class="w3-container">
    <input type="hidden" id="room_form_room_id">
    <h2>Roommate</h2>
<div class="w3-row-padding">
  <div class="w3-half">
    <label>Type</label>
    <select class="w3-select w3-border" id="room_form_mate_type">
     <option value="0" style="background-color: yellow; color: black">Tank</option>
     <option value="1" style="background-color: red; color: white">Air Missile</option>
     <option value="2" style="background-color: blue; color: white">Fuel station</option>
     <option value="3" style="background-color: magenta; color: white">Soldiers</option>
    </select>
  </div>
  <div class="w3-half">
    <label class="wide-label">X-Range (to the right)</label>
    <input type="range" min="0" max="150" value="50" class="slider" id="room_form_mate_range">
    <span id="mate_range_value"></span>
  </div>
</div> 
<div class="w3-row-padding">
  <div class="w3-half">
    <label class="wide-label">X-Start Position</label>
    <input class="w3-input w3-border" type="text" id="room_form_mate_x">
  </div>
  <div class="w3-half">
    <label class="wide-label">Y-Start Position (disabled = 200)</label>
    <input class="w3-input w3-border" type="text" id="room_form_mate_y" style="width: 25%; display: inline-block">
    <select class="w3-select w3-border" style="width: 72%" onChange="$('#room_form_mate_y').val(this.value)">
     <option selected disabled value="200"><-- Predefined values</option>
     <option value="200">Disabled</option>
     <option value="48">Soldier/Tank on bottom row</option>
     <option value="24">Soldier/Tank on middle row</option>
     <option value="71">Fuel on bottom row</option>
     <option value="48">Fuel on middle row</option>
     <option value="66">Air Missile in bottom row</option>
     <option value="44">Air Missile in middle row</option>
    </select>
  </div>
</div> 
<h2>Wall / Laser</h2>
<div class="w3-row-padding">
  <div class="w3-half">
    <label>Type</label>
    <select class="w3-select w3-border" id="room_form_wall_type">
     <option value="0">Shootable Wall/Laser</option>
     <option value="1">Solid Wall/Laser</option>
     <option value="2">Shootable blinking Wal/Laser</option>
     <option value="3">Solid blinking Wall/Laser</option>
    </select>
  </div>
  <div class="w3-half">
    <label class="wide-label">Wall X-Range / Blink Frequency</label>
    <input type="range" min="0" max="150" value="50" class="slider" id="room_form_wall_range">
    <span id="wall_range_value"></span>
  </div>
</div> 
<div class="w3-row-padding">
  <div class="w3-half">
    <label>Wall width</label>
    <select class="w3-select w3-border" id="room_form_wall_w">
     <option value="0">1px "x"</option>
     <option value="1">2px "xx"</option>
     <option value="2">4px "xxxx"</option>
     <option value="3">8px "xxxxxxxx"</option>
    </select>
  </div>
  <div class="w3-half">
    <label>Wall height (default: 23) </label>
    <input class="w3-input w3-border" type="text" id="room_form_wall_h">
  </div>
</div> 
<div class="w3-row-padding">
  <div class="w3-half">
    <label>X-Start Position (disabled = 200)</label>
    <input class="w3-input w3-border" type="text" id="room_form_wall_x">
  </div>
  <div class="w3-half">
    <label class="wide-label">Y-Start Position</label>
    <input class="w3-input w3-border" type="text" id="room_form_wall_y" style="width: 25%; display: inline-block">
    <select class="w3-select w3-border" style="width: 72%" onChange="$('#room_form_wall_y').val(this.value)">
     <option selected disabled value="47"><-- Predefined values</option>
     <option value="47">Wall/Laser in middle row</option>
     <option value="71">Wall/Laser in bottom row</option>
     <option value="23">Wall/Laser in top row</option>
    </select>
  </div>
</div> 
<div class="w3-row-padding">
  <div class="w3-half">
    <label>X-Start Position Second Wall</label>
    <input class="w3-input w3-border" type="text" id="room_form_wall_2_x">
  </div>
  <div class="w3-half">
    <label class="wide-label">Y-Start Position Second Wall</label>
    <input class="w3-input w3-border" type="text" id="room_form_wall_2_y" style="width: 25%; display: inline-block">
    <select class="w3-select w3-border" style="width: 72%" onChange="$('#room_form_wall_2_y').val(this.value)">
     <option selected disabled value="47"><-- Predefined values</option>
     <option value="47">Wall/Laser in middle row</option>
     <option value="71">Wall/Laser in bottom row</option>
     <option value="23">Wall/Laser in top row</option>
    </select>
  </div>
</div> 

<h2>Colors</h2>
<div class="w3-row-padding">
  <div class="w3-half">
   <label>NTSC Colors</label>
    <input class="color-picker" id="room_form_color_ntsc_top" value="#000" />
    <input class="color-picker" id="room_form_color_ntsc_middle" value="#000" />
    <input class="color-picker" id="room_form_color_ntsc_bottom" value="#000" />
  </div>
  <div class="w3-half">
   <label>PAL Colors</label>
   <input class="color-picker-pal" id="room_form_color_pal_top" value="#000" />
   <input class="color-picker-pal" id="room_form_color_pal_middle" value="#000" />
   <input class="color-picker-pal" id="room_form_color_pal_bottom" value="#000" />
  </div>
</div> 

<h2>Misc</h2>
<div class="w3-row-padding">
  <div class="w3-half">
    <input class="w3-check" type="checkbox" id="room_form_first_last">
    <label>Room cannot be left uppwards (Start room)</label>
  </div>
  <div class="w3-half">
    <input class="w3-check" type="checkbox" id="room_form_change_all_rooms_color">
    <label>Change all room colors!</label>
    </div>
</div> 
</form>
    </div>
  </div>
</div> 

</body>
</html>
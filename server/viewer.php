<?php
require_once './users/init.php';  //make sure this path is correct!
require_once $abs_us_root.$us_url_root.'users/includes/template/prep.php';
if (!securePage($_SERVER['PHP_SELF'])){die();}

?>

 <link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css"> 


 <link rel="stylesheet" href="./assets/css/editor.css"> 
 <script src="./assets/js/editor.js"></script>
<script>
$(document).ready(function() {
  loadLevels(true);
  $( "#room_form_mate_range" ).on( "input", function() {
     $( "#mate_range_value" ).html( this.value);
  });
  $( "#room_form_wall_range" ).on( "input", function() {
     $( "#wall_range_value" ).html( this.value);
  });
});
</script>


<div class="box nav-box"><div class="w3-bar w3-black" id="NaviBox"></div></div>

<div class="box content-box level-map">
<div class="map-container w3-padding-16">
    <table id="LevelMap" class="w3-centered display" border="0" cellpadding="0" cellspacing="0"></table>
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
</body>
</html>
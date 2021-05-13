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
        $('#LevelMap tr.grid:first').before('<tr class="grid">' + tCell.repeat(rows) + '</tr>');
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
/*
    'interior' => [16,48,22, 48,63,200],
    'pf' => [192,0,0,192,0,0,0,192,254,0,0,192],
    'color_0' => [0x22,0x24,0,0,0,0x26],
    'color_1' => [0x42,0x44,0,0,0,0x46],
   r_roommate_type_and_range = r106   ; $03 is P0 type (00=enemy, 01=air missile, 10=Fuel station, 11=soldier)
   r_roommate_y_startpos = r107
   r_roommate_x_startpos = r108
   r_extra_wall_width = r109        ; todo wall type ($03) and width (D4 and D5) 
   r_extra_wall_type = r110         ; todo wall range  or blink frequenz (laser!)
   r_extra_wall_startpos = r111
    */   
    var pos_brk_wall = room.interior[5] - 15;
    var pos_mate_bot = room.interior[1] > 48 && room.interior[1] < 200 ? (room.interior[2] - 15):200;
    var pos_mate_mid = room.interior[1] > 24 && room.interior[1] < 49  ? (room.interior[2] - 15):200;
    var pos_mate_top = room.interior[1] < 25 ? (room.interior[2] - 15):200;
    var eny_color = ["yellow", "red", "blue", "magenta" ];
    var ret = '';
    ret += '<table border="0" cellpadding="0" cellspacing="0"><tr>';
    color_row = 0;
    room.pf.forEach( (pf_b, block_id) => {
        var i = 0;
        for(; i<8; i++){
            var mask = (block_id % 2 == 0)?(2 ** (7-i)):(2 ** i);
              ret += "<td class=\"color_ntsc_" + ((pf_b & mask)>0?room.color_0[color_row].toString(16):"00") + "\">&nbsp;</td>";
        }
        if(block_id == 3 || block_id == 7){
            ret += "</tr><tr>";
            color_row++;
            if(color_row == 2)
                color_row = 5;
        }
    });
    ret += "</tr></table>";
    if(pos_brk_wall >= 0 &&  pos_brk_wall <= 144){
        ret += '<div class="brk_wall color_ntsc_' + room.color_0[1].toString(16) + '" style="left: ' + pos_brk_wall + 'px; ' + ((room.interior[4] > 0) ? 'animation: moving_wall 3s infinite alternate' :'') + '"></div>';
    }
    if(pos_mate_bot >= 0 &&  pos_mate_bot <= 144){
        ret += '<div class="eny_bot" style="left: ' + pos_mate_bot + 'px; background-color: ' + eny_color[(room.interior[0] & 3)] + '"></div>';
    }
    if(pos_mate_mid >= 0 &&  pos_mate_mid <= 144){
        ret += '<div class="eny_mid" style="left: ' + pos_mate_mid + 'px; background-color: ' + eny_color[(room.interior[0] & 3)] + '"></div>';
    }
    if(pos_mate_top >= 0 &&  pos_mate_top <= 144){
        ret += '<div class="lmp_top" style="left: ' + pos_mate_top + 'px; background-color: ' + eny_color[(room.interior[0] & 3)] + ';"></div>';
    }
    return ret;
}

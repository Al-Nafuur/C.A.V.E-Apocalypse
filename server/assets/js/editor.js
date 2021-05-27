var tCell = '<td class="grid"><span onclick="addRoom(this)" class="w3-button w3-blue">+Room</span></td>';
var CurrentLevelData = null;
var CurrentLevelId = null
var isMouseDown = false;

var ntsc_palette = {
    "0": "#000000",    "2": "#1a1a1a",    "4": "#393939",    "6": "#5b5b5b",    "8": "#7e7e7e",    "a": "#a2a2a2",    "c": "#c7c7c7",    "e": "#ededed",    
    "10": "#190200",    "12": "#3a1f00",    "14": "#5d4100",    "16": "#826400",    "18": "#a78800",    "1a": "#ccad00",    "1c": "#f2d219",    "1e": "#fefa40",    
    "20": "#370000",    "22": "#5e0800",    "24": "#832700",    "26": "#a94900",    "28": "#cf6c00",    "2a": "#f58f17",    "2c": "#feb438",    "2e": "#fedf6f",
    "30": "#470000",    "32": "#730000",    "34": "#981300",    "36": "#be3216",    "38": "#e45335",    "3a": "#fe7657",    "3c": "#fe9c81",    "3e": "#fec6bb",
    "40": "#440008",    "42": "#6f001f",    "44": "#960640",    "46": "#bb2462",    "48": "#e14585",    "4a": "#fe67aa",    "4c": "#fe8cd6",    "4e": "#feb7f6",    
    "50": "#2d004a",    "52": "#570067",    "54": "#7d058c",    "56": "#a122b1",    "58": "#c743d7",    "5a": "#ed65fe",    "5c": "#fe8af6",    "5e": "#feb5f7",    
    "60": "#0d0082",    "62": "#3300a2",    "64": "#550fc9",    "66": "#782df0",    "68": "#9c4efe",    "6a": "#c372fe",    "6c": "#eb98fe",    "6e": "#fec0f9",    
    "70": "#000091",    "72": "#0a05bd",    "74": "#2822e4",    "76": "#4842fe",    "78": "#6b64fe",    "7a": "#908afe",    "7c": "#b7b0fe",    "7e": "#dfd8fe",    
    "80": "#000072",    "82": "#001cab",    "84": "#033cd6",    "86": "#205efd",    "88": "#4081fe",    "8a": "#64a6fe",    "8c": "#89cefe",    "8e": "#b0f6fe",    
    "90": "#00103a",    "92": "#00316e",    "94": "#0055a2",    "96": "#0579c8",    "98": "#239dee",    "9a": "#44c2fe",    "9c": "#68e9fe",    "9e": "#8ffefe",
    "a0": "#001f02",    "a2": "#004326",    "a4": "#006957",    "a6": "#008d7a",    "a8": "#1bb19e",    "aa": "#3bd7c3",    "ac": "#5dfee9",    "ae": "#86fefe",
    "b0": "#002403",    "b2": "#004a05",    "b4": "#00700c",    "b6": "#09952b",    "b8": "#28ba4c",    "ba": "#49e06e",    "bc": "#6cfe92",    "be": "#97feb5",
    "c0": "#002102",    "c2": "#004604",    "c4": "#086b00",    "c6": "#289000",    "c8": "#49b509",    "ca": "#6bdb28",    "cc": "#8ffe49",    "ce": "#bbfe69",    
    "d0": "#001501",    "d2": "#103600",    "d4": "#305900",    "d6": "#537e00",    "d8": "#76a300",    "da": "#9ac800",    "dc": "#bfee1e",    "de": "#e8fe3e",    
    "e0": "#1a0200",    "e2": "#3b1f00",    "e4": "#5e4100",    "e6": "#836400",    "e8": "#a88800",    "ea": "#cead00",    "ec": "#f4d218",    "ee": "#fefa40",
    "f0": "#380000",    "f2": "#5f0800",    "f4": "#842700",    "f6": "#aa4900",    "f8": "#d06b00",    "fa": "#f68f18",    "fc": "#feb439",    "fe": "#fedf70",
}

var pal_palette ={
    "0": "#000000","2": "#1a1a1a","4": "#393939","6": "#5b5b5b","8": "#7e7e7e","a": "#a2a2a2","c": "#c7c7c7","e": "#ededed",
    "10": "#000000","12": "#1a1a1a","14": "#393939","16": "#5b5b5b","18": "#7e7e7e","1a": "#a2a2a2","1c": "#c7c7c7","1e": "#ededed",
    "20": "#1e0000","22": "#3f1c00","24": "#633d00","26": "#886000","28": "#ad8300","2a": "#d2a806","2c": "#f9cd26","2e": "#fef64a",
    "30": "#002100","32": "#004600","34": "#0d6a00","36": "#2d9000","38": "#4fb500","3a": "#71da06","3c": "#95fe26","3e": "#c0fe4d",
    "40": "#3a0000","42": "#620600","44": "#882500","46": "#ad4500","48": "#d2671b","4a": "#f98b3b","4c": "#feb05e","4e": "#fedb87",
    "50": "#002500","52": "#004b00","54": "#007200","56": "#0d9600","58": "#2cbb1c","5a": "#4ee13d","5c": "#70fe5f","5e": "#9cfe8a",
    "60": "#470000","62": "#720007","64": "#970f25","66": "#bd2e45","68": "#e34f68","6a": "#fe728b","6c": "#fe98b2","6e": "#fec2dd",
    "70": "#002100","72": "#004505","74": "#006c26","76": "#009046","78": "#1cb569","7a": "#3ddb8c","7c": "#5ffeb1","7e": "#88fedd",
    "80": "#410026","82": "#6c004f","84": "#920473","86": "#b82298","88": "#de43bd","8a": "#fe65e3","8c": "#fe8afe","8e": "#feb6fe",
    "90": "#00112a","92": "#00344f","94": "#005975","96": "#047c9a","98": "#22a0bf","9a": "#43c5e5","9c": "#65ebfe","9e": "#8cfefe",
    "a0": "#2a0065","a2": "#530092","a4": "#7804b9","a6": "#9c22e0","a8": "#c242fe","aa": "#e865fe","ac": "#fe8afe","ae": "#feb6fe",
    "b0": "#00006b","b2": "#001f94","b4": "#0040bc","b6": "#1d62e2","b8": "#3d85fe","ba": "#5fa9fe","bc": "#84d1fe","be": "#abf9fe",
    "c0": "#08008e","c2": "#2d00bc","c4": "#4e10e4","c6": "#712ffe","c8": "#9550fe","ca": "#bb75fe","cc": "#e39bfe","ce": "#fec2fe",
    "d0": "#000090","d2": "#0608bd","d4": "#2425e4","d6": "#4445fe","d8": "#6667fe","da": "#8b8dfe","dc": "#b2b3fe","de": "#dadbfe",
    "e0": "#000000","e2": "#1a1a1a","e4": "#393939","e6": "#5b5b5b","e8": "#7e7e7e","ea": "#a2a2a2","ec": "#c7c7c7","ee": "#ededed",
    "f0": "#000000","f2": "#1a1a1a","f4": "#393939","f6": "#5b5b5b","f8": "#7e7e7e","fa": "#a2a2a2","fc": "#c7c7c7","fe": "#ededed",
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


function saveLevel(){
    $.ajax({
        type: 'POST',
        url: './api.php',
        data: {route: "save_level", level: CurrentLevelId, rooms: JSON.stringify(CurrentLevelData)},
        dataType: 'json',
        complete: function ( jqXHR, textStatus){ alert ("Response: " + textStatus); }
    });  
}

function addRoom(element){
    var cur_cell = $(element).parent();
    var room_left = cur_cell.prev('td');
    var room_top = cur_cell.closest('tr').prev('tr').children().eq(cur_cell.index());
    var room_right = cur_cell.next('td');
    var room_bottom = cur_cell.closest('tr').next().children().eq(cur_cell.index());
    var new_room_id = CurrentLevelData.length;
    if( new_room_id > 0 && (
       (room_left.length == 0 || ! room_left.attr('id') ) &&
       (room_top.length == 0 || ! room_top.attr('id') ) &&
       (room_right.length == 0 || ! room_right.attr('id') ) &&
       (room_bottom.length == 0 || ! room_bottom.attr('id') ) ) ){

        alert("No valid room among neighbours!");
        return;
    }

    var room = {"interior":[0,30,200,0,48,23,200,47],
                "pf":[255,0,0,255,192,0,0,192,255,0,0,255],
                "color_0": new_room_id > 0 ? CurrentLevelData[0].color_0.slice():[0x22,0x24,0,0,0,0x26], // Colors of first room (copy)
                "color_1": new_room_id > 0 ? CurrentLevelData[0].color_1.slice():[0x42,0x44,0,0,0,0x46],
                "exit":[-1,-1,-1,-1],
                "first_last": new_room_id > 0 ? 0:1 };

    // add new exits to the (old) neighbours
    if(room_left.attr('id')){
        room.exit[0] = parseInt(room_left.attr('id').replace("Room_",""));
        CurrentLevelData[room.exit[0]].exit[2] = new_room_id;
    }
    if(room_top.attr('id')){
        room.exit[1] = parseInt(room_top.attr('id').replace("Room_",""));
        CurrentLevelData[room.exit[1]].exit[3] = new_room_id;
    }
    if(room_right.attr('id')){
        room.exit[2] = parseInt(room_right.attr('id').replace("Room_",""));
        CurrentLevelData[room.exit[2]].exit[0] = new_room_id;
    }
    if(room_bottom.attr('id')){
        room.exit[3] = parseInt(room_bottom.attr('id').replace("Room_",""));
        CurrentLevelData[room.exit[3]].exit[1] = new_room_id;
    }

    CurrentLevelData[new_room_id] = room;
    cur_cell.attr('id', "Room_" + new_room_id ).attr('title', "Room_" + new_room_id).html(renderSmallRoom( room ))
    .find("td").mousedown(function () {
        isMouseDown = true;
        pfBitClicked($(this));
        return false;
    }).mouseenter(function () {
        if (isMouseDown) {
            pfBitClicked($(this));
        }
    }).on("selectstart", function () {
        return false;
    });
}


function pfBitClicked(cell_element) {
    var block_id = parseInt( cell_element.index() / 8 ) + cell_element.closest("tr").index() * 4;
    var bit_id =  cell_element.index() % 8;
    var room_id = parseInt(cell_element.closest("td.grid").attr('id').replace("Room_",""));
    var room = CurrentLevelData[room_id];
    var mask = (block_id % 2 == 0)?(2 ** (7-bit_id)):(2 ** bit_id);
    var selected_tool = $("select#edittool option:checked").val();
    var pf_row_color = room.color_0[(block_id > 7)?5:(block_id > 3?1:0 )];

    if(selected_tool == 0){
        cell_element.removeClass().addClass("color_ntsc_" + pf_row_color.toString(16));
        room.pf[block_id] = room.pf[block_id] | mask;
    }else if(selected_tool == 1){
        cell_element.removeClass().addClass("color_ntsc_00");
        room.pf[block_id] = room.pf[block_id] & ( mask ^ 0xff );
    }else if(selected_tool == 2){ // toggle Playfield !
        if((room.pf[block_id] & mask) > 0 ){
            cell_element.removeClass().addClass("color_ntsc_00");
            room.pf[block_id] = room.pf[block_id] & ( mask ^ 0xff );
        }else{
            cell_element.removeClass().addClass("color_ntsc_" + pf_row_color.toString(16));
            room.pf[block_id] = room.pf[block_id] | mask;
        }
    }else if(selected_tool == 6){ // edit room form
        $("#room_form_room_id").val(room_id);

        var ntsc_colors = room.color_0;
        $("#room_form_color_ntsc_top").spectrum("set", ntsc_palette[ntsc_colors[0].toString(16)]);
        $("#room_form_color_ntsc_middle").spectrum("set", ntsc_palette[ntsc_colors[1].toString(16)]);
        $("#room_form_color_ntsc_bottom").spectrum("set", ntsc_palette[ntsc_colors[5].toString(16)]);

        var pal_colors = room.color_1;
        $("#room_form_color_pal_top").spectrum("set", pal_palette[pal_colors[0].toString(16)]);
        $("#room_form_color_pal_middle").spectrum("set", pal_palette[pal_colors[1].toString(16)]);
        $("#room_form_color_pal_bottom").spectrum("set", pal_palette[pal_colors[5].toString(16)]);

        $("#room_form_color_0").val(JSON.stringify(room.color_0));
        $("#room_form_color_1").val(JSON.stringify(room.color_1));
    
        $("#room_form_mate_type").val( room.interior[0] & 3);
        $("#room_form_mate_range").val( room.interior[0] & 0xFC );
        $("#mate_range_value").html( room.interior[0] & 0xFC);
        $("#room_form_mate_x").val( room.interior[1] );
        $("#room_form_mate_y").val( room.interior[2] );

        $("#room_form_wall_type").val( room.interior[3] & 3);
        $("#room_form_wall_range").val( room.interior[3] & 0xFC );
        $("#wall_range_value").html( room.interior[3] & 0xFC);
        $("#room_form_wall_w").val( room.interior[4] >> 4 );
        $("#room_form_wall_h").val( room.interior[5] );
        $("#room_form_wall_x").val( room.interior[6] );
        $("#room_form_wall_y").val( room.interior[7] );
        $('#room_form_first_last').prop('checked', ( room.first_last == 1) );

        

        $("#room_editor").show();
    }

    console.log(room.interior);
    console.log("def pf: " + room.pf[block_id] + " selected_tool " + selected_tool);

}

function getNTSCcolor(css_rgb_value){
    return parseInt(Object.keys(ntsc_palette).find(key => ntsc_palette[key] === css_rgb_value), 16 );
}

function getPALcolor(css_rgb_value){
    return parseInt( Object.keys(pal_palette).find(key => pal_palette[key] === css_rgb_value), 16);
}

function modifyRoomData() {
    var room_id = $("#room_form_room_id").val();
    var room = CurrentLevelData[room_id];

    room.color_0[0] = getNTSCcolor($("#room_form_color_ntsc_top").val());
    room.color_0[1] = getNTSCcolor($("#room_form_color_ntsc_middle").val());
    room.color_0[5] = getNTSCcolor($("#room_form_color_ntsc_bottom").val());

    room.color_1[0] = getPALcolor($("#room_form_color_pal_top").val());
    room.color_1[1] = getPALcolor($("#room_form_color_pal_middle").val());
    room.color_1[5] = getPALcolor($("#room_form_color_pal_bottom").val());


    room.interior[0] = ($("#room_form_mate_type").val() & 3 ) +  ( $("#room_form_mate_range").val() & 0xFC);
    room.interior[1] = parseInt($("#room_form_mate_x").val());
    room.interior[2] = parseInt($("#room_form_mate_y").val());

    room.interior[3] = ($("#room_form_wall_type").val() & 3 ) +  ( $("#room_form_wall_range").val() & 0xFC);
    room.interior[4] = $("#room_form_wall_w").val() << 4;
    room.interior[5] = parseInt($("#room_form_wall_h").val());
    room.interior[6] = parseInt($("#room_form_wall_x").val());
    room.interior[7] = parseInt($("#room_form_wall_y").val());
    room.first_last = $('#room_form_first_last').prop('checked') ? 1 : 0;

    $("#room_editor").hide();
    renderCurrentLevel();
}



function renderSmallRoom( room ){ 
    var wall_pos_x = room.interior[6] - 15;
    var wall_pos_y = room.interior[7];
    var mate_pos_x = room.interior[1] - 15;
    var mate_pos_y = room.interior[2];
    var mate_type = (room.interior[0] & 3);
    var mate_colors = ["yellow", "red", "blue", "magenta" ];
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
    if(wall_pos_x >= 0 &&  wall_pos_x <= 144){
        ret += '<div class="brk_wall color_ntsc_' + room.color_0[1].toString(16) + 
               (((room.interior[3] & 2 ) == 2 ) ? ' blink' :'') +
               (((room.interior[3] & 2 ) == 0 && room.interior[3] > 2  ) ? ' move' :'') +
               '"' +
               ' style="width: ' + Math.pow(2, (room.interior[4] >> 4 )) + 'px;' +
               ' top: -' + ( 92.5 - wall_pos_y ) + 'px;' +
               ' left: ' + wall_pos_x + 'px;"></div>';
    }
    if(mate_pos_y < 200 && mate_pos_x >= 0 &&  mate_pos_x <= 144){
        ret += '<div class="enemy" style="left: ' + mate_pos_x + 'px; ' + 
                'top: -' + ( 92.5 - mate_pos_y ) + 'px; ' +
                'background-color: ' + mate_colors[mate_type] + '"></div>';
    }
    return ret;
}

function renderCurrentLevel(){
    var rooms_rendered = [];
    if(CurrentLevelData.length == 0){
        $('#LevelMap').empty().append('<tr class="grid">' + tCell + '</tr>');
    }else{
        $('#LevelMap').empty().append('<tr class="grid"><td class="grid"></td></tr>');
        var element = $('#LevelMap td:first');
        $.each(CurrentLevelData, function( room_id, room ) {
            if(room_id > 0){
                // find a Room that is already rendered in the exits of the new room here.
                $.each(room.exit, function( id, exit_id ) {
                    if(rooms_rendered.includes( exit_id ) ){
                        switch (id) { // room_nr: left, top, right, bottom
                            case 0: // left
                                if($('#Room_' + exit_id).next('td').length == 0)
                                    addColumn(true);
                                element = $('#Room_' + exit_id).next('td');
                                break;
                            case 1: // top
                                if($('#Room_' + exit_id).closest('tr').next().children().eq($('#Room_' + exit_id).index()).length == 0)
                                    addRow(true);
                                element = $('#Room_' + exit_id).closest('tr').next().children().eq($('#Room_' + exit_id).index());
                                break;
                            case 2: // right
                                if($('#Room_' + exit_id).prev('td').length == 0)
                                    addColumn(false);
                                element = $('#Room_' + exit_id).prev('td');
                                break;
                            case 3: // bottom
                                if($('#Room_' + exit_id).closest('tr').prev('tr').children().eq($('#Room_' + exit_id).index()).length == 0)
                                    addRow(false);
                                element = $('#Room_' + exit_id).closest('tr').prev('tr').children().eq($('#Room_' + exit_id).index());
                                break;
                        }
                    }
                });
            }
            element.attr('id', "Room_" + room_id).attr('title', "Room " + room_id);
            element.html(renderSmallRoom( room ));
            rooms_rendered.push(parseInt(room_id));
        });
        $('td.grid td').mousedown(function () {
            isMouseDown = true;
            pfBitClicked($(this));
            return false;
        }).mouseenter(function () {
            if (isMouseDown) {
                pfBitClicked($(this));
            }
        }).on("selectstart", function () {
            return false;
        });
    }
}

function loadLevel(level_nr){
    $("button").removeClass("w3-blue");
    $("button[value='Level_"+level_nr+"']").addClass("w3-blue");
    CurrentLevelId = level_nr;
    $.get( "./api.php?route=get_level&level=" + level_nr , function( data ) {
        CurrentLevelData = data;
        renderCurrentLevel();
    });
}

function loadLevels(){
    $.get( "./api.php?route=get_levels", function( data ) {
        $('#NaviBox').empty();
        $.each(data, function( key, level_id ) {
            $('#NaviBox').append('<button class="w3-bar-item w3-button" name="level" onClick="loadLevel(' + level_id  + ')" value="Level_' + level_id + '">Level ' + level_id + '</button>');
        })
    })
}

function addLevel(){
    $.get( "./api.php?route=add_level", function( data ) {
        if(data.new_level_nr ){
            $('#NaviBox').append('<button class="w3-bar-item w3-button" name="level" onClick="loadLevel(' + data.new_level_nr  + ')" value="Level_' + data.new_level_nr + '">Level ' + data.new_level_nr + '</button>');
            alert("success");
        }else{
            alert("failed!");
        }
    })
}
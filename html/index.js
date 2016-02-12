
function get_xmlHttp_obj() {

    var xmlHttp = null;
    try {           // Firefox, Opera 8.0+, Safari
        xmlHttp = new XMLHttpRequest();
    }
    catch (e) {     // Internet Explorer
        try {
            xmlHttp = new ActiveXObject("Msxml2.XMLHTTP");
        }
        catch (e) { // Internet Explorer 5.5
            xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
        }
    }
    return xmlHttp;
};

function get_dates() {
    var camera_select=document.getElementById('camera_select');	
    
	var xmlHttp = get_xmlHttp_obj();	
	xmlHttp.open('GET', 'ajax.php' + '?get_date=1'+'&'+Math.random(), true);	
	xmlHttp.onreadystatechange = function() {	
	if (xmlHttp.readyState == 4) {
		xmlHttp.onreadystatechange = null; // plug memory leak
		if(xmlHttp.status == 200) {
			var html_data='';
			var obj_data = eval("( "+xmlHttp.responseText+" )");			
			//var dates = data.split(';');		
			for (var i = 0; i < obj_data.length; i++)
			{					
				html_data+='<option value="'+obj_data[i]["date_value"]+'">'+obj_data[i]["date_title"]+'</option>';
			}			
			document.getElementById('date_select').innerHTML=html_data;
		}
	};	
	}
	xmlHttp.send(null);
	var mode_select=document.getElementById('mode_select');
	mode_select.selectedIndex=0;
    
}	

function get_cameras() {    
	var xmlHttp = get_xmlHttp_obj();
	var camera_select=document.getElementById('camera_select');	
    var selcam = (camera_select.selectedIndex>-1)?camera_select.selectedIndex:0;
	xmlHttp.open('GET', 'ajax.php' + '?get_cameras=1'+'&'+Math.random(), true);	
	xmlHttp.onreadystatechange = function() {	
	if (xmlHttp.readyState == 4) {
		xmlHttp.onreadystatechange = null; // plug memory leak
		if(xmlHttp.status == 200) {
			var html_data='';
			var obj_data = eval("( "+xmlHttp.responseText+" )");		
					
			for (var i = 0; i < obj_data.length; i++)
			{						
				html_data+='<option value="'+obj_data[i]["feed"]+'">'+obj_data[i]["title"]+'</option>';
			}
			camera_select.innerHTML=html_data;
            camera_select.selectedIndex=(selcam<camera_select.length)?selcam:0;
		}
	};	
	}
	xmlHttp.send(null);	
    
}

var movies =[];
var current_movie=0;
var timeoutid=0;
var player=document.getElementById('player');

var loading=new Image();
loading.src='loading.gif';
loading.style.position='absolute';
loading.style.width='32px';
loading.style.height='32px';
loading.style.bottom=Math.round(player.clientHeight/2)-10+'px';
loading.style.right=Math.round(player.clientWidth/2)-10+'px';
loading.style.zIndex=-1;
loading.style.border=0;

var onlineimg=new Image();
onlineimg.style.width='100%';
onlineimg.style.height='95%';
onlineimg.style.zIndex=1;
onlineimg.style.border=0;


function change_mode() {	
	var mode_select = document.getElementById('mode_select');	
	if (mode_select.selectedIndex == 1) {
		show_movie();
	}
	else {
		get_movies();
	}	
}
 

function get_movies() {		
	var xmlHttp = get_xmlHttp_obj();	
	var camera_select=document.getElementById('camera_select');	
	var acamera = (camera_select.children.length>0)?camera_select.children[camera_select.selectedIndex].value:"";	
	var date_select=document.getElementById('date_select');
	var adate = (date_select.children.length>0)?date_select.children[date_select.selectedIndex].value:"";				
	var mode_select=document.getElementById('mode_select');
	movies.length = 0;
	current_movie = 0;	
	
	player.innerHTML='';
	onlineimg.src='';
	player.appendChild(loading);
	
	
	timeoutid=setTimeout(function() {			
			if (mode_select.selectedIndex==0) {
				acamera = (camera_select.children.length>0)?camera_select.children[camera_select.selectedIndex].value:"";									
				if (player.children.length > 1) {				
					//player.children[0].src='/ramdisk/'+acamera+'/snap/last.jpg?'+Math.random();				
					onlineimg.src='/ramdisk/'+acamera+'/snap/last.jpg?'+Math.random();
				}
				else {
					//player.innerHTML='<img src="/ramdisk/'+acamera+'/snap/last.jpg?'+Math.random()+'" width="100%">';										
					player.appendChild(onlineimg);					
				}				
				setTimeout(arguments.callee,2000);
			}
	}, 2000);

	
	xmlHttp.open('GET', 'ajax.php' + '?get_movies=1&camera='+acamera+'&date='+adate+'&'+Math.random(), true);	
	xmlHttp.onreadystatechange = function() {	
	if (xmlHttp.readyState == 4) {
		xmlHttp.onreadystatechange = null; // plug memory leak
		if(xmlHttp.status == 200) {
			var obj_data = eval("( "+xmlHttp.responseText+" )");		
			var html_data='';
			var tline_html='';
			var title='';									
				
			for (var i = 0; i < obj_data.length; i++)
			{			
				title=obj_data[i]["name"];				
				movies[i]=obj_data[i]["url"];
				html_data+='<span onclick="show_movie('+i+');">&nbsp;'+title+'&nbsp;<br></span>';				
			}		
			document.getElementById('playlist').innerHTML=html_data;				
		}
	};	
	}
	xmlHttp.send(null);
	mode_select.selectedIndex=0;
}

function show_movie(movie_index)
{	
	if (movies.length == 0) {
	    return;
	}
	if (movie_index!==undefined) {
		current_movie=movie_index;
	}
	else {
		movie_index=current_movie;
	}
	var mode_select=document.getElementById('mode_select');
	mode_select.selectedIndex=1;
	var playlist=document.getElementById('playlist').children;
	for (var i=0; i<playlist.length;i++) {
		if (i!=current_movie) {
			playlist[i].classList.remove('archive_hlight');
		}
		else {
			playlist[i].classList.add('archive_hlight');
		}
	}	
	player.innerHTML="<div id='player_obj'></div>";
	video_player({id:'player_obj', name: movies[movie_index], width: player.clientWidth, height: player.clientHeight});
	if (document.getElementById('html5player')) {
		var html5player = document.getElementById('html5player');
		html5player.onloadeddata=html5VideoLoaded;				
		html5player.onseeked=html5VideoScrolled;
		html5player.ontimeupdate=html5VideoProgress;
		html5player.onended=html5VideoFinished;
	} 
}

function init() {
	get_dates();
	get_cameras();		
	get_movies();	
	player.appendChild(loading);
}

var tm=0;
var paused=false;

///////////////////FLASHPLAYER EVENTS//////////////////////////////

function ktVideoProgress(time) {
// вызывается каждую секунду проигрывания видео
	tm=parseInt(time,10);		
}

function ktVideoFinished() {
	tm=0;
	if (current_movie<movies.length-1)
		show_movie(++current_movie);
}

function ktVideoScrolled(time) {
// вызовется при перемотке видео
	tm=parseInt(time,10);
}

function ktVideoStarted() {
// вызовется при нажатии на кнопку play
	paused=false;
}

function ktVideoPaused() {
// вызовется при нажатии на кнопку pause
	paused=true;
}

function ktVideoStopped() {
// вызовется при нажатии на кнопку stop
	paused=true;
}

function ktPlayerLoaded() {
	tm=0;
	document.onkeydown = function(e) {
		if (document.getElementById('flashplayer')) {
			var flashplayer=document.getElementById('flashplayer');
			switch (e.which) {
			case 39:
				if (flashplayer['jsScroll']) {
					tm+=1;
					if (tm<=movie_duration-1)
						flashplayer.jsScroll(tm);
				}
				break;
			case 37:
				if (flashplayer['jsScroll']) {
					tm-=1;	
					if (tm>=1)
						flashplayer.jsScroll(tm);
				}
				break;
			case 32:
				if (paused) {
					if (flashplayer['jsPlay']) {
						flashplayer.jsPlay();
						paused=false;
					}
				}
				else {
					if (flashplayer['jsPause']) {
						flashplayer.jsPause();
						paused=true;
					}
				}
				break;
			}
		}
	}
}

/////////////////HTML5PLAYER EVENTS/////////////////////////

function html5VideoProgress() {
	if (document.getElementById('html5player')) {
		var html5player=document.getElementById('html5player');
		/*var rate=1;
		if (current_play_accel<4)
			rate=0.5;
		if (current_play_accel>4)
			rate=2;
			
		html5player.playbackRate=rate;*/
		tm=html5player.currentTime;
	}	
	
}

function html5VideoScrolled() {
	if (document.getElementById('html5player')) {
		var html5player=document.getElementById('html5player');
		tm=html5player.currentTime;
	}
}

function html5VideoFinished() {
	tm=0;
	if (current_movie<movies.length-1)
		show_movie(++current_movie);
}

function html5playerPlayPause() {
	if (document.getElementById('html5player')) {
		var html5player=document.getElementById('html5player');
		if (html5player.paused)
			html5player.play();
		else
			html5player.pause();
	}	
}

function html5VideoLoaded() {
	document.onkeydown = function(e) {
		if (document.getElementById('html5player')) {
			var html5player=document.getElementById('html5player'); 			
			switch (e.which) {
			case 39:
				tm+=1;
				if (tm<=html5player.duration-1)
					html5player.currentTime=tm;
				break;
			case 37:
				tm-=1;
				if (tm>=1)
					html5player.currentTime=tm;
				break;
			case 32:
				html5playerPlayPause();
				tm=html5player.currentTime;
				break;
			}
			tm=html5player.currentTime;
		}
	}
};


init();

	

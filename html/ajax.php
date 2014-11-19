<?php
ini_set("display_errors",0);
header('Content-Type: text/plain; charset=utf-8');
$user=!empty($_SERVER["PHP_AUTH_USER"])?$_SERVER["PHP_AUTH_USER"]:"";
$ini_file="../service/config.ini";
#if (!is_file($ini_file)) {
#    $ini_file="../service/config.ini";
#}

if (isset($_GET["get_date"]))
{
	$ini_arr = parse_ini_file($ini_file, false);	
	$rootdir=$ini_arr["rootdir"];

	$files=scandir("$rootdir",1);
	$ret="{";
	$length=0;
	for ($i=0;$i<count($files);$i++)
	{		
		$entry=$files[$i];
		$adate=date_parse_from_format("Ymd",$entry);
		$str_date=str_pad($adate["day"],2,'0',STR_PAD_LEFT)." / ".str_pad($adate["month"],2,'0',STR_PAD_LEFT)." / ".$adate["year"];
		if(($entry != '.') && ($entry != '..') && (is_dir("$rootdir/$entry")))
		{	
			if ($ret=='{')
				$ret.="\"$length\":{\"date_value\":\"$entry\",\"date_title\":\"$str_date\"}";
			else 
				$ret.=",\"$length\":{\"date_value\":\"$entry\",\"date_title\":\"$str_date\"}";
			//echo "$str_date;";
			$length++;
		}
	}	
	if ($ret=='{')
		$ret.="\"length\":\"$length\"";
	else 
		$ret.=",\"length\":\"$length\"";
	$ret.='}';
	echo $ret;
	exit;
}
if (isset($_GET["get_cameras"]))
{		
	$ini_arr = parse_ini_file($ini_file, true);
	$user_feeds=explode(' ',$ini_arr["Global"]["${user}_feeds"]);
	$ret='{';
	$length=0;
	foreach ($ini_arr as $section => $values)	
	{		
		if (strtolower($section)!='global')
		{
			//$val=$values["feed_path"];
			$feed=$section;
			if (in_array($feed,$user_feeds)) 
			{
			    $title=$values["title"];
			    $snapshot_interval=$values["snapshot_interval"];
			    if ($ret=='{')
				$ret.="\"$length\":{\"feed\":\"$feed\",\"title\":\"$title\",\"snapshot_interval\":\"$snapshot_interval\"}";
			    else 
				$ret.=",\"$length\":{\"feed\":\"$feed\",\"title\":\"$title\",\"snapshot_interval\":\"$snapshot_interval\"}";
			    $length++;
			}
		}		
	}
	if ($ret=='{')
		$ret.="\"length\":\"$length\"";
	else 
		$ret.=",\"length\":\"$length\"";
	$ret.='}';
	echo $ret;
	exit;
}
if (isset($_GET["get_movies"]))
{
	$ini_arr = parse_ini_file($ini_file, true);	
	$rootdir=$ini_arr["Global"]["rootdir"];
	$user_feeds=explode(' ',$ini_arr["Global"]["${user}_feeds"]);
	$feed=$user_feeds[0];
	
	$camera=!empty($_GET["camera"])?substr(strip_tags(stripslashes(trim($_GET["camera"]))),0,255):"$feed";
	$date=!empty($_GET["date"])?substr(strip_tags(stripslashes(trim($_GET["date"]))),0,255):date("Ymd");
	$rootdir.="/$date/$camera/movie/";	
	$url="/screenshots/$date/$camera/movie/";
	$ret="{";
	$length=0;
	if (is_dir($rootdir))
	{
		$files=scandir($rootdir,0);		
		for ($i=0;$i<count($files);$i++)
		{		
			$entry=$files[$i];
			if(($entry != '.') && ($entry != '..') && (is_file($rootdir.$entry)))
			{	
				$mname=substr($entry,0,strpos($entry,'.'));
				$res_name='';
				$ind=0;
				for ($j=0;$j<strlen($mname);$j++)
				{		
					if ($mname[$j]!='-')
					{
						$ind++;
						if (($ind % 2) == 1)
							$res_name.=$mname[$j];
						elseif(($j<strlen($mname)-1)&&($mname[$j+1]!='-'))
							$res_name.=$mname[$j].":";
						else
							$res_name.=$mname[$j];
					}
					else
						$res_name.=" - ";
				}			
				
				if ($ret=='{')
					$ret.="\"$length\":{\"name\":\"$res_name\",\"url\":\"$url$entry\"}";
				else 
					$ret.=",\"$length\":{\"name\":\"$res_name\",\"url\":\"$url$entry\"}";
				$length++;
			}
		}	
	}
	if ($ret=='{')
		$ret.="\"length\":\"$length\"";
	else 
		$ret.=",\"length\":\"$length\"";
	
	$ret.='}';
	echo $ret;
	exit;
}

?>
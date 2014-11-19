#!/usr/bin/php
<?php
//Генерация ключа-изображения
function getimageid($image)
{
    $h=20;
    $w=20;
	//Размеры исходного изображения
	$size=getimagesize($image);
	if ($size === false) return false;

	// Определяем исходный формат по MIME-информации, предоставленной
	// функцией getimagesize, и выбираем соответствующую формату
	// imagecreatefrom-функцию.
	$format = strtolower(substr($size['mime'], strpos($size['mime'], '/')+1));
	$icfunc = "imagecreatefrom" . $format;
	if (!function_exists($icfunc)) return false;
	
	//Исходное изображение
	$image=$icfunc($image);
	
	//Маска
	$zone=imagecreate($w,$h);
	
	//Копируем изображение в маску
	imagecopyresized($zone,$image,0,0,0,0,$w,$h,$size[0],$size[1]);
	
	//Будущая маска
	$colormap=array();
	
	//Базовый цвет изображения
	$average=0;
	
	//Результат
	$result=array();
	
	//Заполняем маску и вычисляем базовый цвет
	for($x=0;$x<$w;$x++) 
	for($y=0;$y<$h;$y++)
	{
		$color=imagecolorat($zone,$x,$y);
		$color=imagecolorsforindex($zone,$color);
	
		//Вычисление яркости было подсказано хабраюзером Ryotsuke
		$colormap[$x][$y]= 0.212671 * $color['red'] + 0.715160 * $color['green'] + 0.072169 * $color['blue'];
	
		$average += $colormap[$x][$y];
	}
	
	//Базовый цвет
	if (($w==0) || ($h==0) || $average==0) {
	    return false;
	}
	$average /= $w*$h;
	
	//Генерируем ключ строку
	for($x=0;$x<$w;$x++) {
		for($y=0;$y<$h;$y++)
			$result[]=($x<10?$x:chr($x+97)).($y<10?$y:chr($y+97)).round(2*$colormap[$x][$y]/$average);
	}
	//Возвращаем ключ
	return join(' ',$result);
}

//Вычисление "похожести" двух изображений
function imagediff($image,$desc)
{	
	if ((!$image)||(!$desc)) {
	    return 0;
	}
	$image=explode(' ',$image);
	$desc=explode(' ',$desc);
	
	$result=0;
	
	foreach($image as $bit) {
		if(in_array($bit,$desc))
			$result++;
	}
	return $result/((count($image)+count($desc))/2);
}

$img1=$argv[1];
$img2=$argv[2];

if (is_file($img1) && is_file($img2)) {
	$diff=floor(imagediff(getimageid($img1),getimageid($img2))*100);	
} else {
	$diff=0;
}

echo "$diff\n";

?>

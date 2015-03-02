#!/usr/bin/php
<?php
//��������� �����-�����������
function getimageid($image)
{
    $h=20;
    $w=20;
	//������� ��������� �����������
	$size=getimagesize($image);
	if ($size === false) return false;

	// ���������� �������� ������ �� MIME-����������, ���������������
	// �������� getimagesize, � �������� ��������������� �������
	// imagecreatefrom-�������.
	$format = strtolower(substr($size['mime'], strpos($size['mime'], '/')+1));
	$icfunc = "imagecreatefrom" . $format;
	if (!function_exists($icfunc)) return false;
	
	//�������� �����������
	$image=$icfunc($image);
	
	//�����
	$zone=imagecreate($w,$h);
	
	//�������� ����������� � �����
	imagecopyresized($zone,$image,0,0,0,0,$w,$h,$size[0],$size[1]);
	
	//������� �����
	$colormap=array();
	
	//������� ���� �����������
	$average=0;
	
	//���������
	$result=array();
	
	//��������� ����� � ��������� ������� ����
	for($x=0;$x<$w;$x++) 
	for($y=0;$y<$h;$y++)
	{
		$color=imagecolorat($zone,$x,$y);
		$color=imagecolorsforindex($zone,$color);
	
		//���������� ������� ���� ���������� ����������� Ryotsuke
		$colormap[$x][$y]= 0.212671 * $color['red'] + 0.715160 * $color['green'] + 0.072169 * $color['blue'];
	
		$average += $colormap[$x][$y];
	}
	
	//������� ����
	if (($w==0) || ($h==0) || $average==0) {
	    return false;
	}
	$average /= $w*$h;
	
	//���������� ���� ������
	for($x=0;$x<$w;$x++) {
		for($y=0;$y<$h;$y++)
			$result[]=($x<10?$x:chr($x+97)).($y<10?$y:chr($y+97)).round(2*$colormap[$x][$y]/$average);
	}
	//���������� ����
	return join(' ',$result);
}

//���������� "���������" ���� �����������
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

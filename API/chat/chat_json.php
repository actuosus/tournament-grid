<?
require("../../bitrix/modules/main/include/prolog_before.php");
require_once ("../../bitrix/php_interface/dbconn.php");
$data=Array();
$query = "select * from staff_parametrs where module='stream'"; 
/* Выполнить запрос. Если произойдет ошибка - вывести ее. */ 
$result= mysql_query($query);  
$tempdata=Array();
while ($arr = mysql_fetch_row ($result)) // каждое поле строки присваиваем переменной 
{ 
$tempdata[$arr[0]]=$arr[1];
}  
$data[]=Array (
 "html"=>"<div style=\"width:640px;height:360px\"</div>",
 "icon"=>"http://www.virtuspro.org/images/stream_button_chat.png",
 "anounce"=>"Общий чат, без трансляции",
 "room"=>0,
 "header"=>""
);
if($tempdata["active1"]=="checked"):
	$data[]=Array (
	 "html"=>$tempdata["embed1"],
	 "icon"=>"http://www.virtuspro.org/images/stream_button_".$tempdata["type1"].".png",
	 "anounce"=>$tempdata["name1"],
	 "room"=>1,
	 "header"=>""
	);
	else:
	$data[]=Array (
	 "html"=>"<div style=\"width:640px;height:360px\"</div>",
	 "icon"=>"http://www.virtuspro.org/images/1.gif",
	 "anounce"=>"",
	 "room"=>1,
	 "header"=>""
	);
	
	endif;
if($tempdata["active2"]=="checked"):
	$data[]=Array (
	 "html"=>$tempdata["embed2"],
	 "icon"=>"http://www.virtuspro.org/images/stream_button_".$tempdata["type2"].".png",
	 "anounce"=>$tempdata["name2"],
	 "room"=>2,
	 "header"=>""
	);
	else:
	$data[]=Array (
	 "html"=>"<div style=\"width:640px;height:360px\"</div>",
	 "icon"=>"http://www.virtuspro.org/images/1.gif",
	 "anounce"=>"",
	 "room"=>2,
	 "header"=>""
	);
	
	endif;
if($tempdata["active3"]=="checked"):
	$data[]=Array (
	 "html"=>$tempdata["embed3"],
	 "icon"=>"http://www.virtuspro.org/images/stream_button_".$tempdata["type3"].".png",
	 "anounce"=>$tempdata["name3"],
	 "room"=>3,
	 "header"=>""
	);
	else:
	$data[]=Array (
	 "html"=>"<div style=\"width:640px;height:360px\"</div>",
	 "icon"=>"http://www.virtuspro.org/images/1.gif",
	 "anounce"=>"",
	 "room"=>3,
	 "header"=>""
	);
	
	endif;
if($tempdata["active4"]=="checked"):
	$data[]=Array (
	 "html"=>$tempdata["embed4"],
	 "icon"=>"http://www.virtuspro.org/images/stream_button_".$tempdata["type4"].".png",
	 "anounce"=>$tempdata["name4"],
	 "room"=>4,
	 "header"=>""
	);
	else:
	$data[]=Array (
	 "html"=>"<div style=\"width:640px;height:360px\"</div>",
	 "icon"=>"http://www.virtuspro.org/images/1.gif",
	 "anounce"=>"",
	 "room"=>4,
	 "header"=>""
	);
	
	endif;
if($tempdata["active5"]=="checked"):
	$data[]=Array (
	 "html"=>$tempdata["embed5"],
	 "icon"=>"http://www.virtuspro.org/images/stream_button_".$tempdata["type5"].".png",
	 "anounce"=>$tempdata["name5"],
	 "room"=>5,
	 "header"=>""
	);
	else:
	$data[]=Array (
	 "html"=>"<div style=\"width:640px;height:360px\"</div>",
	 "icon"=>"http://www.virtuspro.org/images/1.gif",
	 "anounce"=>"",
	 "room"=>5,
	 "header"=>""
	);
	
	endif;
echo json_encode($data);
?>
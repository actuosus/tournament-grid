<?
// header("HTTP/1.0 404 Not Found");
require("../../bitrix/modules/main/include/prolog_before.php");
$data=Array();
// прав нет
$data["access"]=Array();
// можно модерировать сообщения
$class="class=\"moderated\"";
// получаем группы
$groups = $_SESSION["SESS_AUTH"]["GROUPS"];
// кто у нас по дефолту
$data["type"]="guest";
// 5 сообщений в 10 секунд
$data["messlimit"]=Array(7,10);
//userid
global $USER;
if ($USER->GetID()) $data["user_id"]=$USER->GetID();
$mess="%s";


if (isset($_SESSION["SESS_AUTH"]["LOGIN"])) 
	{ 
		$data["username"]=$_SESSION["SESS_AUTH"]["LOGIN"];
		$data["type"]="user"; 
	}

if (in_array(7,$groups)) {
	$mod = "";
	$color= "F91F1F";
	$size= " ";
	$data["access"] = Array("ban","html");
	$class="";
	$data["type"]="admin";
	$mess="<b>%s</b>";
}

// if ($_SESSION["SESS_AUTH"]["LOGIN"]=="NorTan") {
	// $mod = "";
	// $color= "000000";
	// $size= " ";
	// $data["access"] = Array("ban","html");
	// $class="";
	// $data["type"]="admin";
	// $mess="%s";
// }


$data["colors"]=Array("<b ".$class.">".$mod."%s</b>"," :: <font ".$size." color='#".$color."'>".$mess."</font>");
		
//
// $group=["SESS_AUTH"]["LOGIN"];
// echo  json_encode($_SESSION);
// echo  json_encode($data);
echo  json_encode($data);
 // echo session_id(); echo json_encode($_SESSION); //echo "\n";
 // echo md5(session_id());echo "<br>";
 // echo session_name();echo "<br>";
 // echo session_regenerate_id($_GET["sid"]);
 
 // echo json_encode($_SESSION);
// echo "<pre>";
// print_r($_SESSION);
// echo "</pre>";
// require($_SERVER["DOCUMENT_ROOT"]."/bitrix/footer.php");?>
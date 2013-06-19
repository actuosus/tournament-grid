<?php
error_reporting(E_ALL);
ini_set('display_errors', '1');
require "predis-0.8/autoload.php";
$client = new Predis\Client(array(
	'host'     => '127.0.0.1',
    'port'     => 6379,
    'database' => 1
));

$data = array(
	'user' => 'Tenkoff',
	'id' => 1
);
   
// $client->expire('test', 60);
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
// echo  json_encode($data);
 // echo session_id(); echo json_encode($_SESSION); //echo "\n";
 // echo md5(session_id());echo "<br>";
 // echo session_name();echo "<br>";
 // echo session_regenerate_id($_GET["sid"]);
 
 // echo json_encode($_SESSION);
// echo "<pre>";
// print_r($_SESSION);
// echo "</pre>";
// require($_SERVER["DOCUMENT_ROOT"]."/bitrix/footer.php");
// print_r($_SESSION);

function refreshSession($client, $uid, $new_ssid){
	if(empty($uid) or empty($new_ssid)){
		return false;
	}
	$old_ssid = $client->get("vp:user:$uid:PHPSESSID");
	if($new_ssid !== $old_ssid){
		$client->del("vp:PHPSESSID:$old_ssid");
		$client->set("vp:PHPSESSID:$new_ssid", $uid);
		$client->set("vp:user:$uid:PHPSESSID", $new_ssid);
		// Update user info
		setUserInfo($client, $uid, 'name', $_SESSION["SESS_AUTH"]["LOGIN"]);
		// Notify about changes
		$client->publish('vp:chat', 'new session');
	}
	return false;
}
function setUserInfo($client, $uid, $name, $data){
	$client->set("vp:user:$uid:$name", json_encode(array("data"=>$data)));
}

refreshSession($client, $_SESSION["SESS_AUTH"]["USER_ID"], $_SESSION["fixed_session_id"]);


// $result = $client->get(
// 	"vp:user:$uid:PHPSESSID"
// );

// if ($result > 0)
// {
// 	$client->del(
// 		"vp:PHPSESSID:$result");
	
// }

// $client->set(
// 	"vp:user:$uid:PHPSESSID",
// 	$ssid
// );

// $client->set(
// 	"vp:PHPSESSID:$ssid",
// 	$uid
// );
// print_r($client->get('vp:'.$_SESSION["fixed_session_id"]));

?>

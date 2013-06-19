<?

require("../../bitrix/modules/main/include/prolog_before.php");
$groups = $_SESSION["SESS_AUTH"]["GROUPS"];

if (in_array(7,$groups)) {
	require 'admin.include.html';
}

?>
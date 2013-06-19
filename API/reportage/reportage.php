<?php
require($_SERVER["DOCUMENT_ROOT"]."/bitrix/modules/main/include/prolog_before.php"); //подключаем ядро для кэширования и рабоыт с бд

//отдаём начальную информацию по репортажу
if (intval($_REQUEST['ID'])>0)
{	global $DB;
	CModule::IncludeModule("iblock");


	$ar_rep=array();
	$arResult=array();
	$res_rep=CIBlockElement::GetList(array(),array("IBLOCK_ID"=>IB_REPORTS,"ACTIVE"=>"Y","=ID"=>$_REQUEST['ID']),false,false,array("ID","IBLOCK_ID","NAME","DATE_ACTIVE_FROM","DATE_ACTIVE_TO","PROPERTY_LINK_G","PROPERTY_LINK_U","DETAIL_TEXT"));
	if($ar_rep=$res_rep->GetNext())	{		$arResult["__v"]=3;
		$arResult["start_date"]=date("Y-m-d\TH:i:s\Z",MakeTimeStamp($ar_rep["DATE_ACTIVE_FROM"]));
		$arResult["end_date"]=date("Y-m-d\TH:i:s\Z",MakeTimeStamp($ar_rep["DATE_ACTIVE_TO"]));
		$arResult["_id"]=$ar_rep['ID'];
		$arResult["_title"]=$ar_rep['NAME'];
		//получаем stages id
		$arResult["stages"]=array();
		$res_stages=$DB->Query("SELECT id FROM r_stages WHERE report_id=".intval($ID));
		while ($ar_stages = $res_stages->Fetch())
		{
			$arResult["stages"][]=$ar_stages['id'];		}
		//получаем team_ref id
		$arResult["team_refs"]=array();
		$res_team=$DB->Query("SELECT id FROM r_team_refs WHERE report_id=".intval($ID));
		while ($ar_teams = $res_team->Fetch())
		{
			$arResult["team_refs"][]=$ar_teams['id'];
		}

		$arResult["match_type"]="team";

		//формирование ответа json
		header("Access-Control-Allow-Origin: *");
		header("Access-Control-Allow-Methods: GET,PUT,POST,DELETE,OPTIONS");
		header("Access-Control-Allow-Headers: accept, origin, content-type, referer, cache-control, pragma, user-agent, X-Requested-With");
		header("Access-Control-Max-Age: 1728000");
		echo json_encode(array('report' => $arResult));	}
	else
		{			include_once($_SERVER['DOCUMENT_ROOT'].'/404.php'); //такого репортажа в базе - нет		}
}
else
	{
		include_once($_SERVER['DOCUMENT_ROOT'].'/404.php');//тут обработка пустого запроса
	}
?>
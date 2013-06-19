<?php
//для ускорения можно немного подправить функцию COUNTRY() и использовать тут, т.к. она кэшируется

$_REQUEST['report_id']="123";
if(intval($_REQUEST['report_id'])>0)
{	require($_SERVER["DOCUMENT_ROOT"]."/bitrix/modules/main/include/prolog_before.php"); //подключаем ядро для кэширования и рабоыт с бд
	CModule::IncludeModule("iblock");

	$arResult=array();
	$res_c=CIBlockElement::GetList(array(),array("IBLOCK_ID"=>IB_COUNTRY,"ACTIVE"=>"Y"),false,false,array("ID","NAME","CODE"));
	while($ar_c=$res_c->GetNext())
	{		$arResult[$ar_c['ID']]["_id"]=$ar_c['ID'];
		$arResult[$ar_c['ID']]["name"]=$ar_c['NAME'];
		$arResult[$ar_c['ID']]["englishName"]=$ar_c['NAME'];
		$arResult[$ar_c['ID']]["germanName"]=$ar_c['NAME'];
		$arResult[$ar_c['ID']]["code"]=$ar_c['CODE'];
		$arResult[$ar_c['ID']]["__v"]=0;
		$arResult[$ar_c['ID']]["_name"]=array("ru"=>$ar_c['NAME'],"en"=>$ar_c['NAME'],"de"=>$ar_c['NAME']);	}
	//формирование ответа json
	header("Access-Control-Allow-Origin: *");
	header("Access-Control-Allow-Methods: GET,PUT,POST,DELETE,OPTIONS");
	header("Access-Control-Allow-Headers: accept, origin, content-type, referer, cache-control, pragma, user-agent, X-Requested-With");
	header("Access-Control-Max-Age: 1728000");
	echo json_encode(array('countries' => array_values($arResult)));}
else
	{
		include_once($_SERVER['DOCUMENT_ROOT'].'/404.php');//тут обработка пустого запроса
	}
?>
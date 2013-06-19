<?php
if(count($_REQUEST['ids'])>0 || (isset($_REQUEST['name']) && trim($_REQUEST['name'])!=""))
{	require($_SERVER["DOCUMENT_ROOT"]."/bitrix/modules/main/include/prolog_before.php"); //подключаем ядро для кэширования и рабоыт с бд
	CModule::IncludeModule("iblock");

	$ar_Filter=array("IBLOCK_ID"=>IB_TEAMS,"ACTIVE"=>"Y");

	if(count($_REQUEST['ids'])>0)
		$ar_Filter['=ID']=$_REQUEST['ids'];
	else
		$ar_Filter['NAME']=trim($_REQUEST['name'])."%";

	$ar_Select=array("ID",
					 "IBLOCK_ID",
					 "NAME",
					 "PROPERTY_GAMERS",
					 "PROPERTY_COUNTRY",
					 "PROPERTY_PRO",
	);

	$arResult=array();
	$arRes=array();
	$res_t=CIBlockElement::GetList(array('NAME'=>"ASC"),$ar_Filter,false,array("nTopCount"=>20),$ar_Select); //ограничим выботку 20 результатами
	while($ar_t=$res_t->GetNext())
	{
		$arRes[$ar_t['ID']]["_id"]=$ar_t['ID'];
		$arRes[$ar_t['ID']]["name"]=$ar_t['NAME'];
		$arRes[$ar_t['ID']]["title"]=$ar_t['NAME'];
		$arRes[$ar_t['ID']]["country_id"]=$ar_t['PROPERTY_COUNTRY_VALUE'];
		$arRes[$ar_t['ID']]["__v"]=0;
		$arRes[$ar_t['ID']]["players"]=$ar_t['PROPERTY_GAMERS_VALUE'];
		$arRes[$ar_t['ID']]["is_pro"]=$ar_t['PROPERTY_PRO_VALUES']!=""?true:false;	}
	$arRes=array_values($arRes);
	if(count($arRes)>0) //если есть результат
	{
			$arResult=array();
			if (isset($_REQUEST['obj'])) $arResult['team']=$arRes[0]; else $arResult['teams']=$arRes;
			send_rest($arResult);
	}
	else
		{
			rest_header("404 Not Found");
			exit();
		}

/*	if(count($arRes)>1)
		$arResult['teams']=$arRes;
	elseif(count($arRes)==1)
		$arResult['team']=$arRes[0];
	elseif(count($arRes)==0)
		{			rest_header("404 Not Found");
			exit();
		}
	//формирование ответа
	send_rest($arResult);*/}
else
	{
		rest_header("404 Not Found"); exit();
	}
?>
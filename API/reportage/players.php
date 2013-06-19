<?php
require($_SERVER["DOCUMENT_ROOT"]."/bitrix/modules/main/include/prolog_before.php");
$REQUEST=rest();

function SelectSQL($id,$name="") //основной запрос
{
	CModule::IncludeModule("iblock");

	$ar_Filter=array("IBLOCK_ID"=>IB_GAMERS,"ACTIVE"=>"Y");

	if(count($id)>0)
		$ar_Filter['=ID']=$id;
	elseif(trim($name)!="")
		$ar_Filter['NAME']=trim($name)."%";
	else
		return array();

	$ar_Select=array("ID",
					 "IBLOCK_ID",
					 "NAME",
					 "PROPERTY_GENDER",
					 "PROPERTY_COUNTRY",
					 "PROPERTY_FIO1",
					 "PROPERTY_FIO2",
					 "PROPERTY_FIO3",
	);

	$arResult=array();
	$res_t=CIBlockElement::GetList(array('NAME'=>"ASC"),$ar_Filter,false,array("nTopCount"=>20),$ar_Select); //ограничим выботку 20 результатами
	while($ar_t=$res_t->GetNext())
	{
		$arResult[$ar_t['ID']]["_id"]=$ar_t['ID'];
		$arResult[$ar_t['ID']]["country_id"]=$ar_t['PROPERTY_COUNTRY_VALUE'];
		$arResult[$ar_t['ID']]["first_name"]=$ar_t['PROPERTY_FIO2_VALUE'];
		$arResult[$ar_t['ID']]["gender"]=$ar_t['PROPERTY_GENDER_VALUE'];
		$arResult[$ar_t['ID']]["last_name"]=$ar_t['PROPERTY_FIO1_VALUE'];
		$arResult[$ar_t['ID']]["is_captain"]="false"; //WTF!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		$arResult[$ar_t['ID']]["nickname"]=$ar_t['NAME'];
	}

	$arResult=array_values($arResult);

	if(count($arResult)>0) //если есть результат
	{
		$arRes=array();
		if (isset($_REQUEST['obj'])) $arRes['player']=$arResult[0]; else $arRes['players']=$arResult;
		return $arRes;
	}

	return array();
}
//==============================================================================
//==============================================================================
//==============================================================================
//==============================================================================
if($REQUEST['metod']=="GET")
{
	$arResult=SelectSQL($_REQUEST['ids'],$_REQUEST['nickname']);

	if(count($arResult)==0) //если нет результата
	{
		rest_header("404 Not Found"); exit();
	}
	//формирование ответа
	send_rest($arResult);
}
elseif($REQUEST['metod']=="POST" && isset($REQUEST['json']['player'])) //добавление элемента
{
	CModule::IncludeModule("iblock");

	$arFields=array("IBLOCK_ID"=>IB_GAMERS,"ACTIVE"=>"Y","IBLOCK_SECTION" => false,"MODIFIED_BY"=>16); //16 пользователь специально чтобы потом проще отсортировать
	$input=$REQUEST['json']['player'];

	if(isset($input["country_id"])) $arFields["PROPERTY_VALUES"]["COUNTRY"]=$input["country_id"];
	if(isset($input["first_name"])) $arFields["PROPERTY_VALUES"]["FIO2"]=$input["first_name"];
	if(isset($input["gender"]))     $arFields["PROPERTY_VALUES"]["GENDER"]=$input["gender"];
	if(isset($input["last_name"]))  $arFields["PROPERTY_VALUES"]["FIO1"]=$input["last_name"];
	if(isset($input["nickname"]))   $arFields["NAME"]=$input["nickname"];
	$arFields["CODE"]= CUtil::translit($input["nickname"]);

	$el = new CIBlockElement;
	if($ID = $el->Add($arFields))
		send_rest(SelectSQL(array($ID)));
	else
	{
		rest_header("404 Not Found");
		echo "Error: ".$el->LAST_ERROR;
	}

}
elseif($REQUEST['metod']=="PUT" && isset($REQUEST['json']['player']) && isset($_REQUEST['ids'][0])) //обновление элемента !!!!!!!!!!!!!!!!!!!!!!
{
	global $DB;
	$input=$REQUEST['json']['player'];

	$arFields=array("ACTIVE"=>"Y","IBLOCK_SECTION" => false,"MODIFIED_BY"=>16);
	if(isset($input["nickname"]))  $arFields["NAME"]=$input["nickname"];

	$PROP=array();
	if(isset($input["country_id"])) $PROP["COUNTRY"]=$input["country_id"];
	if(isset($input["first_name"])) $PROP["FIO2"]=$input["first_name"];
	if(isset($input["gender"]))     $PROP["GENDER"]=$input["gender"];
	if(isset($input["last_name"]))  $PROP["FIO1"]=$input["last_name"];

	if(count($PROP)>0)
		CIBlockElement::SetPropertyValuesEx(intval($_REQUEST['ids'][0]), IB_GAMERS, $PROP); //обновляем свойства элемента

	$el = new CIBlockElement;
	$el->Update(intval($_REQUEST['ids'][0]), $arFields); //обновляем основные параметры

	send_rest(SelectSQL($_REQUEST['ids']));

}
elseif($REQUEST['metod']=="DELETE") //удаление элемента  !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
{
		rest_header("404 Not Found");
}
else
	rest_header("404 Not Found");
?>
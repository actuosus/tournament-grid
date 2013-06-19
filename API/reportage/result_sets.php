<?php
require($_SERVER["DOCUMENT_ROOT"]."/bitrix/modules/main/include/prolog_before.php");
$REQUEST=rest();

function SelectSQL($ids) //основной запрос
{
	$i=0;
	$sql_ids="";
	foreach($ids as $d) //просеиваем массив
	{
		if(intval($d)>0)
		{
			if($i>0) $sql_ids.=',';
			$sql_ids.=intval($d);
			$i++;
		}
	}
	//получаем по id
	$arResult['result_sets']=array();
	if($sql_ids!='')
	{
		global $DB;
		$arResult=array();
		$res_g=$DB->Query("SELECT *, id as _id FROM r_result_sets WHERE id IN (".$sql_ids.")",true);
		while ($ar_g = $res_g->Fetch())
		{
			$arResult[$ar_g['id']]=$ar_g;
		}
		$arResult=array_values($arResult);

		if(count($arResult)>0) //если есть результат
		{
			$arRes=array();
			if (isset($_REQUEST['obj'])) $arRes['result_set']=$arResult[0]; else $arRes['result_sets']=$arResult;
			return $arRes;
		}
	}
	return array();
}
//==============================================================================
//==============================================================================
//==============================================================================
//==============================================================================
if($REQUEST['metod']=="GET")
{
	$arResult=SelectSQL($_REQUEST['ids']);
	if(count($arResult)==0) //если нет результата
	{
		rest_header("404 Not Found"); exit();
	}

	//формирование ответа
	send_rest($arResult);
}
elseif($REQUEST['metod']=="POST" && isset($REQUEST['json']['result_set'])) //добавление элемента
{
	global $DB;
	$arFields=array();
	foreach($REQUEST['json']['result_set'] as $l=>$el)
	{
		$arFields[$l]="'".$DB->ForSql(strip_tags($el))."'";
	}

	$ID=$DB->Insert('r_result_sets', $arFields);
	if($ID>0)
	{
		send_rest(SelectSQL(array($ID)));
	}

}
elseif($REQUEST['metod']=="PUT" && isset($REQUEST['json']['result_set']) && isset($_REQUEST['ids'][0])) //обновление элемента
{
	global $DB;

	$arFields=array();
	foreach($REQUEST['json']['result_set'] as $l=>$el)
	{
		$arFields[$l]="'".$DB->ForSql(strip_tags($el))."'";
	}

	if($DB->Update("r_result_sets", $arFields, "WHERE id='".intval($_REQUEST['ids'][0])."'","","",true)>0)
	{
		send_rest(SelectSQL($_REQUEST['ids']));
	}
	else
		{
			rest_header("404 Not Found"); exit();
		}

}
elseif($REQUEST['metod']=="DELETE" && intval($_REQUEST['ids'][0])>0) //удаление элемента
{
	global $DB;
	if($DB->Query("DELETE FROM r_result_sets WHERE id=".intval($_REQUEST['ids'][0]))!=false)
	{
		rest_header("204 No Content");exit();
	}
	else
		{
			rest_header("404 Not Found"); exit();
		}
}
else
	{
		rest_header("404 Not Found"); exit();
	}
?>
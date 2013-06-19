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
	$arResult['matches']=array();
	if($sql_ids!="")
	{
		global $DB;
		$arResult=array();
		$res_g=$DB->Query("SELECT *, id as _id FROM r_matches WHERE id IN (".$sql_ids.")",true);
		while ($ar_g = $res_g->Fetch())
		{
			$arResult[$ar_g['id']]=$ar_g;

			//получаем games
			if(!isset($arResult[$ar_g['id']]['games']))
			{
				$arResult[$ar_g['id']]['games']=array();
				$res_raund=$DB->Query("SELECT id FROM r_games WHERE match_id=".$ar_g['id']);
				while ($ar_raund = $res_raund->Fetch())
				{
					$arResult[$ar_g['id']]['games'][]=$ar_raund['id'];
				}
			}
		}
		$arResult=array_values($arResult);

		if(count($arResult)>0) //если есть результат
		{
			$arRes=array();
			if (isset($_REQUEST['obj'])) $arRes['match']=$arResult[0]; else $arRes['matches']=$arResult;
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
	//d($arResult);
	if(count($arResult)==0) //если нет результата
	{
		rest_header("404 Not Found"); exit();
	}

	//формирование ответа
	send_rest($arResult);
}
elseif($REQUEST['metod']=="POST" && isset($REQUEST['json']['match'])) //добавление элемента
{
	global $DB;
	$arFields=array();
	foreach($REQUEST['json']['match'] as $l=>$el)
	{
		$arFields[$l]="'".$DB->ForSql(strip_tags($el))."'";
	}

	$ID=$DB->Insert('r_matches', $arFields);
	if($ID>0)
	{
		send_rest(SelectSQL(array($ID)));
	}

}
elseif($REQUEST['metod']=="PUT" && isset($REQUEST['json']['match']) && isset($_REQUEST['ids'][0])) //обновление элемента
{
	global $DB;

	$arFields=array();
	foreach($REQUEST['json']['match'] as $l=>$el)
	{
		$arFields[$l]="'".$DB->ForSql(strip_tags($el))."'";
	}

	if($DB->Update("r_matches", $arFields, "WHERE id='".intval($_REQUEST['ids'][0])."'","","",false)>0)
	{
		send_rest(SelectSQL($_REQUEST['ids']));
	}
	else
		rest_header("404 Not Found");
}
elseif($REQUEST['metod']=="DELETE" && intval($_REQUEST['ids'][0])>0) //удаление элемента
{
	global $DB;
	if($DB->Query("DELETE FROM r_matches WHERE id=".intval($_REQUEST['ids'][0]))!=false)
		rest_header("204 No Content");
	else
		rest_header("404 Not Found");
}
else
	rest_header("404 Not Found");
?>
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
	$arResult['stages']=array();
	if($sql_ids!="")
	{
		global $DB;
		$arResult=array();
		$res_g=$DB->Query("SELECT * FROM r_stages WHERE id IN (".$sql_ids.")",true);
		while ($ar_g = $res_g->Fetch())
		{
			$arResult[$ar_g['id']]['__v']=0;
			$arResult[$ar_g['id']]['_id']=$ar_g['id'];
			$arResult[$ar_g['id']]['title']=$ar_g['title'];
			$arResult[$ar_g['id']]['description']=$ar_g['description'];
			$arResult[$ar_g['id']]['report_id']=$ar_g['report_id'];
			$arResult[$ar_g['id']]['visual_type']=$ar_g['visual_type'];
			$arResult[$ar_g['id']]['sort_index']=$ar_g['sort_index'];
			$arResult[$ar_g['id']]['entrants_number']=$ar_g['entrants_count'];
			$arResult[$ar_g['id']]['rating']=$ar_g['rating'];

			//получаем раунды
			if(!isset($arResult[$ar_g['id']]['rounds']))
			{
				$arResult[$ar_g['id']]['rounds']=array();
				$res_raund=$DB->Query("SELECT id FROM r_rounds WHERE stage_id=".$ar_g['id']);
				while ($ar_raund = $res_raund->Fetch())
				{
					$arResult[$ar_g['id']]['rounds'][]=$ar_raund['id'];
				}
			}
			//получаем brackets
			if(!isset($arResult[$ar_g['id']]['rounds']))
			{
				$arResult[$ar_g['id']]['rounds']=array();
				$res_raund=$DB->Query("SELECT id FROM r_brackets WHERE stage_id=".$ar_g['id']);
				while ($ar_raund = $res_raund->Fetch())
				{
					$arResult[$ar_g['id']]['brackets'][]=$ar_raund['id'];
				}
			}

		}
		$arResult=array_values($arResult);

		if(count($arResult)>0) //если есть результат
		{
			$arRes=array();
			if (isset($_REQUEST['obj'])) $arRes['stage']=$arResult[0]; else $arRes['stages']=$arResult;
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
elseif($REQUEST['metod']=="POST" && isset($REQUEST['json']['stage'])) //добавление элемента
{
	global $DB;
	$arFields=array();
	foreach($REQUEST['json']['stage'] as $l=>$el)
	{
		$arFields[$l]="'".$DB->ForSql(strip_tags($el))."'";
	}

	$ID=$DB->Insert('r_stages', $arFields);
	if($ID>0)
	{
		send_rest(SelectSQL(array($ID)));
	}

}
elseif($REQUEST['metod']=="PUT" && isset($REQUEST['json']['stage']) && isset($_REQUEST['ids'][0])) //обновление элемента
{
	global $DB;

	$arFields=array();
	foreach($REQUEST['json']['stage'] as $l=>$el)
	{
		$arFields[$l]="'".$DB->ForSql(strip_tags($el))."'";
	}

	if($DB->Update("r_stages", $arFields, "WHERE ID='".intval($_REQUEST['ids'][0])."'","","",true)>0)
	{
		send_rest(SelectSQL($_REQUEST['ids']));
	}
	else
		rest_header("404 Not Found");
}
elseif($REQUEST['metod']=="DELETE" && intval($_REQUEST['ids'][0])>0) //удаление элемента
{
	global $DB;
	if($DB->Query("DELETE FROM r_stages WHERE id=".intval($_REQUEST['ids'][0]))!=false)
		rest_header("204 No Content");
	else
		rest_header("404 Not Found");
}
else
	rest_header("404 Not Found");
?>
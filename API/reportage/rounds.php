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
	$arResult['round']=array();
	if($sql_ids!="")
	{
		global $DB;

		$arResult=array();
		$res_rounds=$DB->Query("SELECT * FROM r_rounds WHERE id IN (".$sql_ids.")");
		while ($ar_rounds = $res_rounds->Fetch())
		{
			if(!isset($arResult[$ar_rounds['id']]['__v'])) $arResult[$ar_rounds['id']]['__v']=4; // ??????
			$arResult[$ar_rounds['id']]['_id']=$ar_rounds['id']; //id
			$arResult[$ar_rounds['id']]['_name']=$ar_rounds['name'];//name

			$arResult[$ar_rounds['id']]['team_refs']=array(); //точно ли пустой массив и нужен ли он?????????

			//получаем матчи
			if(!isset($arResult[$ar_rounds['id']]['matches']))
			{
				$arResult[$ar_rounds['id']]['matches']=array();
				$res_match=$DB->Query("SELECT id FROM r_matches WHERE round_id=".$ar_rounds['id']);
				while ($ar_match = $res_match->Fetch())
				{
					$arResult[$ar_rounds['id']]['matches'][]=$ar_match['id'];
				}
			}
			//получаем result_sets
			if(!isset($arResult[$ar_rounds['id']]['result_sets']))
			{
				$arResult[$ar_rounds['id']]['result_sets']=array();
				$res_resset=$DB->Query("SELECT id FROM r_result_sets WHERE round_id=".$ar_rounds['id']);
				while ($ar_resset = $res_resset->Fetch())
				{
					$arResult[$ar_rounds['id']]['result_sets'][]=$ar_resset['id'];
				}
			}

		}
		$arResult=array_values($arResult);

		if(count($arResult)>0) //если есть результат
		{
			$arRes=array();
			if (isset($_REQUEST['obj'])) $arRes['round']=$arResult[0]; else $arRes['rounds']=$arResult;
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
elseif($REQUEST['metod']=="POST" && isset($REQUEST['json']['round'])) //добавление элемента
{
	global $DB;
	$arFields=array();
	foreach($REQUEST['json']['round'] as $l=>$el)
	{
		$arFields[$l]="'".$DB->ForSql(strip_tags($el))."'";
	}

	$ID=$DB->Insert('r_rounds', $arFields);
	if($ID>0)
	{
		send_rest(SelectSQL(array($ID)));
	}

}
elseif($REQUEST['metod']=="PUT" && isset($REQUEST['json']['round']) && isset($_REQUEST['ids'][0])) //обновление элемента
{
	global $DB;

	$arFields=array();
	foreach($REQUEST['json']['round'] as $l=>$el)
	{
		$arFields[$l]="'".$DB->ForSql(strip_tags($el))."'";
	}

	if($DB->Update("r_rounds", $arFields, "WHERE id='".intval($_REQUEST['ids'][0])."'","","",true)>0)
	{
		send_rest(SelectSQL($_REQUEST['ids']));
	}
	else
		rest_header("404 Not Found");
}
elseif($REQUEST['metod']=="DELETE" && intval($_REQUEST['ids'][0])>0) //удаление элемента
{
	global $DB;
	if($DB->Query("DELETE FROM r_rounds WHERE id=".intval($_REQUEST['ids'][0]))!=false)
		rest_header("204 No Content");
	else
		rest_header("404 Not Found");
}
else
	rest_header("404 Not Found");
?>
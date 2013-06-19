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
	$arResult['team_refs']=array();
	if($sql_ids!="")
	{
		global $DB;
		$arResult=array();
		$res_team=$DB->Query("SELECT * FROM r_team_refs WHERE id IN (".$sql_ids.")");
		while ($ar_teams = $res_team->Fetch())
		{
			$arResult[$ar_teams['team_id']]['_id']=$ar_teams['id'];
			$arResult[$ar_teams['team_id']]['title']=$ar_teams['title'];
			$arResult[$ar_teams['team_id']]['country_id']=$ar_teams['country_id'];
			$arResult[$ar_teams['team_id']]['team_id']=$ar_teams['team_id'];
			//if(!isset($arResult[$ar_teams['team_id']]['team_id'])) $arResult[$ar_teams['team_id']]['team_id']=$ar_teams['team_id']; //team_id

			//получаем игроков
			if(!isset($arResult[$ar_teams['team_id']]['players']))
			{
				$arResult[$ar_teams['team_id']]['players']=array();
				$res_p=$DB->Query("SELECT * FROM r_player_refs WHERE team_ref_id=".$ar_teams['id']);
				while ($ar_p = $res_p->Fetch())
				{
					$arResult[$ar_teams['team_id']]['players'][]=$ar_p['player_id']; //players
					if($ar_p['captain']==1) $arResult[$ar_teams['team_id']]['captain_id']=$ar_p['player_id'];  //captain_id
				}
			}
		}
		$arResult=array_values($arResult);

		if(count($arResult)>0) //если есть результат
		{
			$arRes=array();
			if (isset($_REQUEST['obj'])) $arRes['team_ref']=$arResult[0]; else $arRes['team_refs']=$arResult;
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
elseif($REQUEST['metod']=="POST" && isset($REQUEST['json']['team_ref'])) //добавление элемента
{
	global $DB;

	$arFields=array();
	foreach($REQUEST['json']['team_ref']["team_id"] as $l=>$el) //WTF team_id??????????????!!!!!!!!!!!!!!!!!!!!!!!
	{
		$arFields[$l]="'".$DB->ForSql(strip_tags($el))."'";
	}
	unset($arFields['players']);
	unset($arFields['captain_id']);

	$ID=$DB->Insert('r_team_refs', $arFields);
	if($ID>0)
	{

		if(count($REQUEST['json']['team_ref']["team_id"]['players'])>0) //добавляем в таблицу игроков_ref
		{
			foreach($REQUEST['json']['team_ref']["team_id"]['players'] as $el)
			{
				$cap=$el==$REQUEST['json']['team_ref']['captain_id']?1:0;
				$arFields=array("player_id"=>intval($el),"team_ref_id"=>$ID,"captain"=>$cap);

				$DB->Insert('r_player_refs', $arFields);
			}
		}

		send_rest(SelectSQL(array($ID)));
	}

}
elseif($REQUEST['metod']=="PUT" && isset($REQUEST['json']['team_ref']) && isset($_REQUEST['ids'][0])) //обновление элемента
{
	global $DB;

	$arFields=array();
	foreach($REQUEST['json']['team_ref'] as $l=>$el)
	{
		$arFields[$l]="'".$DB->ForSql(strip_tags($el))."'";
	}
	unset($arFields['players']);
	unset($arFields['captain_id']);

	if($DB->Update("r_team_refs", $arFields, "WHERE id='".intval($_REQUEST['ids'][0])."'","","",true)>0)
	{
		if(isset($REQUEST['json']['team_ref']['players']) && is_array($REQUEST['json']['team_ref']['players'])) //если пришел любой масив c игроками
		{
			//сначала удаляем всех игроков команды, т.к. приходит полный набор команды
			$DB->Query("DELETE FROM r_player_refs WHERE team_ref_id=".intval($_REQUEST['ids'][0]));
		}

		if(count($REQUEST['json']['team_ref']['players'])>0) //если есть игроки то добавляем
		{
			foreach($REQUEST['json']['team_ref']['players'] as $el)
			{
				$cap=$el==$REQUEST['json']['team_ref']['captain_id']?1:0; //определяем капитана
				$arFields=array("player_id"=>intval($el),"team_ref_id"=>intval($_REQUEST['ids'][0]),"captain"=>$cap);

				$DB->Insert('r_player_refs', $arFields);
			}
		}

		send_rest(SelectSQL($_REQUEST['ids']));
	}
	else
		rest_header("404 Not Found");
}
elseif($REQUEST['metod']=="DELETE" && intval($_REQUEST['ids'][0])>0) //удаление элемента
{
	global $DB;
	if($DB->Query("DELETE FROM r_team_refs WHERE id=".intval($_REQUEST['ids'][0]))!=false)
	{
		$DB->Query("DELETE FROM r_player_refs WHERE team_ref_id=".intval($_REQUEST['ids'][0])); //удаляем игроков команды

		rest_header("204 No Content");
	}
	else
		rest_header("404 Not Found");
}
else
	rest_header("404 Not Found");
?>
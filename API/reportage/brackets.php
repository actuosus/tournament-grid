<?php
require($_SERVER["DOCUMENT_ROOT"]."/bitrix/modules/main/include/prolog_before.php");
$REQUEST=rest();

function SelectSQL($ids) //�������� ������
{
	$i=0;
	$sql_ids="";
	foreach($ids as $d) //���������� ������
	{
		if(intval($d)>0)
		{
			if($i>0) $sql_ids.=',';
			$sql_ids.=intval($d);
			$i++;
		}
	}
	//�������� �� id
	$arResult['brackets']=array();
	if($sql_ids!="")
	{
		global $DB;
		$arResult=array();
		$res_g=$DB->Query("SELECT *, id as _id FROM r_brackets WHERE id IN (".$sql_ids.")",true);
		while ($ar_g = $res_g->Fetch())
		{
			$ar_g['rounds']=array(); //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!????????????????????????????????
			$arResult[$ar_g['id']]=$ar_g;
		}
		$arResult=array_values($arResult);

		if(count($arResult)>0) //���� ���� ���������
		{
			$arRes=array();
			if (isset($_REQUEST['obj'])) $arRes['bracket']=$arResult[0]; else $arRes['brackets']=$arResult;
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
	if(count($arResult)==0) //���� ��� ����������
	{
		rest_header("404 Not Found"); exit();
	}

	//������������ ������
	send_rest($arResult);
}
elseif($REQUEST['metod']=="POST" && isset($REQUEST['json']['bracket'])) //���������� ��������
{
	global $DB;
	$arFields=array();
	foreach($REQUEST['json']['bracket'] as $l=>$el)
	{
		$arFields[$l]="'".$DB->ForSql(strip_tags($el))."'";
	}

	$ID=$DB->Insert('r_brackets', $arFields);
	if($ID>0)
	{
		send_rest(SelectSQL(array($ID)));
	}

}
elseif($REQUEST['metod']=="PUT" && isset($REQUEST['json']['bracket']) && isset($_REQUEST['ids'][0])) //���������� ��������
{
	global $DB;

	$arFields=array();
	foreach($REQUEST['json']['bracket'] as $l=>$el)
	{
		$arFields[$l]="'".$DB->ForSql(strip_tags($el))."'";
	}

	if($DB->Update("r_brackets", $arFields, "WHERE id='".intval($_REQUEST['ids'][0])."'","","",true)>0)
	{
		send_rest(SelectSQL($_REQUEST['ids']));
	}
	else
		rest_header("404 Not Found");
}
elseif($REQUEST['metod']=="DELETE" && intval($_REQUEST['ids'][0])>0) //�������� ��������
{
	global $DB;
	if($DB->Query("DELETE FROM r_brackets WHERE id=".intval($_REQUEST['ids'][0]))!=false)
		rest_header("204 No Content");
	else
		rest_header("404 Not Found");
}
else
	rest_header("404 Not Found");
?>
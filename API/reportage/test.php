<?
echo "_SERVER<br>";
print_r($_SERVER);

echo "<br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br>_REQUEST<br>";
print_r($_REQUEST);

echo "<br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br>_POST<br>";
print_r($_POST);



$fp = fopen("result.txt", "a" );  
fputs($fp, json_encode($_SERVER)."\n");
fputs($fp, json_encode($_REQUEST)."\n");
fputs($fp, json_encode($_POST)."\n");
fclose($fp);

?>
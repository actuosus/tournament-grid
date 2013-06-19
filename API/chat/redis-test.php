<?php
error_reporting(E_ALL);
ini_set('display_errors', '1');

require "predis-0.8/autoload.php";
$client = new Predis\Client(array(
	'host'     => '127.0.0.1',
    'port'     => 6379,
    'database' => 1
));
$client->publish('log', 'test');
?>
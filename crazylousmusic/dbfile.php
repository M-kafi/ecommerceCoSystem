
<?php
    $host = 'localhost';
	$user ='root';
	$pass = '';
	$db = 'crazylouabdulkafi';	
	$connection = new mysqli($host,$user,$pass,$db);
   
   if ( $connection->connect_errno )
   {
       die("Failed to connect");
   }

?>

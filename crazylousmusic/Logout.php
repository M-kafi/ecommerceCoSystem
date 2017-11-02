<?php
include("dbfile.php");
session_start();
$browsersess = session_id();
$custid = Validate_User_Logged_In();
if(loguserout($custid,$browsersess))
{
	header('Location: ./index.php');
}
function loguserout($custid,$browsersess)
{
	global $connection;
	$sql = "call session_logout($custid,'$browsersess')";
	$connection->next_result();
	if($retrieved = $connection->query($sql))
	{
		return 1;
	}
	else
	{
		return 0;
	}
}
function Validate_User_Logged_In()
{
		global $connection, $browsersess;
		$sql ="call session_verify_logged_in('$browsersess')";
		$connection->next_result();
		$result = $connection->query($sql);
		if($result->num_rows)
		{
			$row = $result->fetch_row();			
			$custID = $row[0];
			return $custID;
		}	
		else
		{
			return 0;
		}
}
?>

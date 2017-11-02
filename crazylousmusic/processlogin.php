<?php
include("dbfile.php");
session_start();
$browsersess = session_id();

$email    ="";
$password ="";
$custID   ="";


if(isset($_POST['email']) && isset($_POST['pswd']))
{
	
	
    $email = $_POST['email'];
	$password =$_POST['pswd'];
	$email = trim($email);
	$password =trim($password);
	$password = md5($password);
	
	if ( Verify_Login($email,$password) > 0 )
	{
		
		
		if(Clear_Previous_Sessions())
		{
		
			if ( Create_User_Session() > 0 )
			{
				
				header('Location: landingpage.php');
				
				
				
			}
			else
			{
				
				header('Location: index.php');
			}
	
		
		
		}
		else
		{
			
			header('Location: index.php');
		}
		
		
		
		
		
	}
		else
	{
		
		header('Location: index.php');
	}
	
	
}
else
{
	header('Location: index.php');
}
	
	
	
function Create_User_Session()
{
//create user session
	global $connection,$custID,$browsersess;
	$sql = "call session_insert($custID,'$browsersess')";
	
	$connection->next_result();
	$result = $connection->query($sql);

	if($connection->affected_rows)
	{		    
		return $connection->affected_rows;
	}
	else
	{		
		return 0;
	}
	
}
	
	
	
	function Clear_Previous_Sessions()
{
	try
	{
		global $connection,$custID;		
		$sql = "call session_logout($custID)";
		$connection->next_result();
		$result = $connection->query($sql);		
		return 1;
	}
	catch(Exception $e)
	{		
		return 0;
	}
	
	
}
	
	
	
	// veryfy the login information
	function Verify_Login($username,$password)
   {
		global $connection,$custID;		
		$sql = "call customer_verify_login('$username','$password')";			
		$connection->next_result();
		$result = $connection->query($sql);		
		if($result->num_rows)
		{
			$row = $result->fetch_row();			
			$custID = $row[0];		
			return 1;
		}
		else
		{			
			return 0;
		}
   }
   
	

	
	
	
	



?>
<form method="POST" action="" autocomplete="off">
processlogin.php
    
    <!-- go to the landing page -->
<a href="landingpage.php"> Keep going</a>

</form>
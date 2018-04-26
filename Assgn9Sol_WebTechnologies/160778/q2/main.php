<html>
<head>
</head>
<body>
<?php
session_start();
$name = $email = $address = $accno = $mobile = $passwd = "";

$db = new SQLite3('registration.db');

if(!$db){
	echo $db->lastErrorMsg();
}

$sql =<<<EOF
      CREATE TABLE records
      (NAME VARCHAR(20)  NOT NULL,
      EMAIL          VARCHAR(50)  NOT NULL,
      ADDRESS        VARCHAR(50),
      MOBILENO       CHAR(10),
      ACCNO			 CHAR(5) NOT NULL,
      PASSWORD       VARCHAR(20) NOT NULL);
EOF;

   $ret = $db->exec($sql);

$acct =<<<EOF
      CREATE TABLE accounts
      (ACCNO CHAR(5)  NOT NULL,
      PASSWORD       VARCHAR(20)  NOT NULL,
      BALANCE        REAL);
EOF;

	$cre = $db->exec($acct);

if ($_SERVER["REQUEST_METHOD"] == "POST") {
  $name = $_POST["name"];
  $email = $_POST["email"];
  $address = $_POST["address"];
  $mobile = $_POST["mobile"];
  $accno = $_POST["ac"];
  $passwd = $_POST["password"];

  $check = "SELECT * FROM records WHERE EMAIL='$email'";
  $results = $db->query($check);

  if($row = $results->fetchArray()){
  	$_SESSION["error"]="Already Registered";
		header("Location: index.php");
    exit;
  }
  else{
  	$val = "SELECT PASSWORD,BALANCE FROM accounts WHERE ACCNO='$accno'";
  	$pass = $db->query($val);
  	if($passes = $pass->fetchArray()) {
  		if($passes[0] != $passwd){
  			$_SESSION["error"]="Invalid Account/Password";
				header("Location: index.php");
        exit;
  		}
  		else{
  			if($passes[1] < 1000){
  				$_SESSION["error"]="Insufficient Balance";
					header("Location: index.php");
          exit;
  			}
  			else{
					$new_b = $passes[1] - 1000;
  				$up = "UPDATE accounts SET BALANCE = '$new_b' WHERE ACCNO='$accno'";
  				$db->exec($up);
  				$qstr = "insert into records values ('$name', '$email', '$address', '$mobile', '$accno','$passwd')";
 					$insres = $db->query($qstr);
          $_SESSION["success"]="Registration Successful";
          header("Location: index.php");
          exit;
  			}
  		}
  	}
		else{
			$_SESSION["error"]="Invalid Account/Password";
			header("Location: index.php");
      exit;
		}
  }
}
else{
  $_SESSION["error"]="Please use Post method";
  header("Location: index.php");
  exit;
}
?>
</body>
</html>

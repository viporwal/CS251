<html>
<head>
</head>
<body>
<CENTER>
<?php
session_start();
$name = $email = $address = $accno = $mobile = $passwd = "";

$db = new SQLite3('registration.db');

if(!$db){
	echo $db->lastErrorMsg();
}

$sql =<<<EOF
      CREATE TABLE admins
      (NAME VARCHAR(20)  NOT NULL,
      ACCNO			 CHAR(5) NOT NULL,
      PASSWORD       VARCHAR(20) NOT NULL);
EOF;

   $ret = $db->exec($sql);

if ($_SERVER["REQUEST_METHOD"] == "POST") {
  $name = $_POST["name"];
  $passwd = $_POST["password"];

  $check = "SELECT * FROM admins WHERE NAME='$name'";
  $results = $db->query($check);

  if($row = $results->fetchArray()){
    if($row[2] == $passwd){
      $resu = $db->query('SELECT * FROM records');
      $_SESSION["table"]="<TABLE BORDER=\"1\" style=\"border-collapse:collapse\">";
      $_SESSION["table"]= $_SESSION["table"]."<h2>All Registrations</h2><br>";
      $_SESSION["table"]= $_SESSION["table"]."<TR align=\"center\"> <TH>NAME</TH> <TH>EMAIL</TH> <TH>ADDRESS</TH> <TH>MOBILENO</TH> <TH>ACCNO</TH> </TR>";
      while ($rowu = $resu->fetchArray()) {
        $_SESSION["table"]= $_SESSION["table"]."<TR align=\"center\"> <TD>$rowu[0]</TD> <TD>$rowu[1]</TD> <TD>$rowu[2]</TD> <TD>$rowu[3]</TD> <TD>$rowu[4]</TD> </TR>";
      }
      $_SESSION["table"]= $_SESSION["table"]."</TABLE><br>";
      header("Location: adminlogin.php");
      exit;
    }
    else{
      $_SESSION["error"]="Invalid Credentials";
      header("Location: adminlogin.php");
      exit;
    }
  }
  else{
    $_SESSION["error"]="Invalid Credentials";
    header("Location: adminlogin.php");
    exit;
  }
}
else{
  $_SESSION["error"]="Please use Post method";
  header("Location: adminlogin.php");
  exit;
}
?>
</CENTER>
</body>
</html>

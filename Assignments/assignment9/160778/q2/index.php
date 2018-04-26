<html>
<head>
<link rel="stylesheet" href="main.css">
</head>
<body>  
<CENTER>
<?php
  session_start();
  if(isset($_SESSION["success"])){
    echo $_SESSION["success"];
    echo "<br>";
  }
  if(isset($_SESSION["error"])){
    echo $_SESSION["error"];
    echo "<br>";
  }
?>
<h2>Registration</h2>
<div class = "container">
<form method="post" action="main.php">  
  Name: <input type="text" name="name" pattern="[A-Za-z]+[A-Za-z ]+[A-Za-z]+" maxlength="20" required>
  <br><br>
  Address: <input type="text" name="address" maxlength="100">
  <br><br>
  E-mail: <input type="email" name="email" pattern="[a-zA-Z]+@[A-Za-z]+\.com" required>
  <br><br>
  Mobile No: <input type="text" name="mobile" pattern="[1-9]{1}[0-9]{9}" required>
  <br><br>
  Account No: <input type="text" name="ac" pattern="[1-9]{1}[0-9]{4}" required>
  <br><br>
  Password: <input type="password" name="password" pattern="[a-zA-Z0-9]+" maxlength="20" required>
  <br><br>
  <input type="submit" name="submit" value="Register">  
</form>
<form action="adminlogin.php">
    <input type="submit" value="See all Registrations"/>
</form>
</div>
<?php
session_unset(); 
session_destroy(); 
?>
</CENTER>
</body>
</html>

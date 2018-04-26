<html>
<head>
<link rel="stylesheet" href="main.css">
</head>
<body>  
<CENTER>
<?php
  session_start();
  if(isset($_SESSION["error"])){
    echo $_SESSION["error"];
    echo "<br>";
  }
  if(isset($_SESSION["table"])){
    echo $_SESSION["table"];
    echo "<br>";
    session_unset();
	session_destroy();
    exit;
  }
?>
<h2>Admin Login</h2>
<div class="container">
<form method="post" action="admin.php">  
  Name: <input type="text" name="name" pattern="[A-Za-z]+[A-Za-z ]+[A-Za-z]+" required>
  <br><br>
  Password: <input type="password" name="password" pattern="[a-zA-Z0-9]+" maxlength="20" required>
  <br><br>
  <input type="submit" name="submit" value="Login">  
</form>
<form action="index.php">
    <input type="submit" value="Another Registration"/>
</form>
</div>
<?php
session_unset(); 
session_destroy(); 
?>
</CENTER>
</body>
</html>

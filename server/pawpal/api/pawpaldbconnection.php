<?php
    $servername = "localhost";
    $username = "root";
    $password = "";
    $dbname = "pawpal_db";
    $conn = new mysqli($servername, $username, $password, $dbname);//check connection
    
    if ($conn->connect_error) {// check error connection
        die("Connection failed: " . $conn->connect_error);
    }
    
?>
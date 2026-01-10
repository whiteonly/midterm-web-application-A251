<?php
    $servername = "localhost";
    // $username = "root";
    // $password = "";
    // $dbname = "pawpal_db";
    $username = "musicbvk_azri";
    $password = "lme?;3KZm9Vv";
    $dbname = "musicbvk_pawpal_db_azri";
    $conn = new mysqli($servername, $username, $password, $dbname);//check connection
    
    if ($conn->connect_error) {// check error connection
        die("Connection failed: " . $conn->connect_error);
    }
    
?>
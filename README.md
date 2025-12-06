# pawpal

-SETUP STEPS
1. file directory named server need to be inside htdocs in xampp for api xampp

<img width="350" height="311" alt="image" src="https://github.com/user-attachments/assets/6b5aa62f-7fab-49a6-a898-aa019e9624d4" />

3. user also need to download packages


<img width="915" height="279" alt="image" src="https://github.com/user-attachments/assets/807da1da-01ae-4c40-9b89-85e1a28eeb14" />


4. user need to copy SQL query from this two sql file after create a database pawpal_db
 <img width="365" height="61" alt="image" src="https://github.com/user-attachments/assets/89b14ae3-f00f-4b95-843e-eb1858409931" />

 
5. turn on the xampp and run the code in main.


-API EXPLAINATION
  1. submit submission

     <img width="719" height="530" alt="image" src="https://github.com/user-attachments/assets/a1428df1-9be5-48bd-9e6f-20a0636185ba" />

     SubmitPet Screen darl file
      these represent an api call from UI to database pawpaldb where it send data from the submission UI page through submit_pet.php

     <img width="894" height="524" alt="image" src="https://github.com/user-attachments/assets/48c105a3-1607-4cef-b08f-287b4f23b7fa" />

      the backend using insert sql statement into the database

     
  3. view submission
     <img width="1033" height="431" alt="image" src="https://github.com/user-attachments/assets/06e79ee2-7a43-4741-b8c1-dcc03a5ab369" />
     <img width="895" height="359" alt="image" src="https://github.com/user-attachments/assets/e81bdec5-bda1-4aed-9db3-fb74bba04e92" />

     
     MAIN SCREEN DART FILE 
     these represent an api call from UI to database pawpaldb where it send data from the submission UI page through get_my_pets.php
     
      <img width="1018" height="580" alt="image" src="https://github.com/user-attachments/assets/f18e3fd3-b966-465a-a66f-574ec9870d4e" />

      
     <img width="1035" height="226" alt="image" src="https://github.com/user-attachments/assets/385c51e9-9d28-43d6-8463-2ba9d5aa418a" />

     <img width="1027" height="495" alt="image" src="https://github.com/user-attachments/assets/8241170f-2bae-4861-b708-e52233ed87eb" />

     
     these used for sql statement to database pawpal_db

-osample JSON
1. <img width="1003" height="422" alt="image" src="https://github.com/user-attachments/assets/fd213906-8a78-42c8-9b29-a8e34a96eba1" />


  this is json response for sql error detection where if iw valid, the process will executed and show message. when it is invalid, the system will stop execution and show the message.

2. <img width="825" height="458" alt="image" src="https://github.com/user-attachments/assets/e61d1fc7-8d0a-4f87-810c-ecf4b51a64c5" />


  this is json response for sql error detection where if iw valid, the process will executed and show message. when it is invalid, the system will stop execution and show the message.

3. <img width="638" height="443" alt="image" src="https://github.com/user-attachments/assets/a8cd7cca-36cf-4c60-b365-6ab38c744d2c" />


  this is json response where api connection connect with backend/ server

4. <img width="1017" height="566" alt="image" src="https://github.com/user-attachments/assets/d8e1657e-cda5-432b-80d8-baaa44c156cb" />


  this is json response where api connection connect with backend/ server






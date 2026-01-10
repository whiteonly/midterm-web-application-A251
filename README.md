https://socstudentmusicforlife.com/azri/ - link for our application


Name: Muhammad Azri Asnawi Bin Kamal Arifin
Matric number: 30102

System Explanation
Pawpal is a web application for users who having difficulty relates to animal’s comfortability, safety ensuring a smooth flow for donation for all relates and pet adoption. Below is a explanation for pawpal system features and interfaces.


<img width="254" height="69" alt="image" src="https://github.com/user-attachments/assets/2d0a19cb-2f30-4579-91c4-663dc3657342" />


1.Registration.
The page is registration page where users need to register before they can access to all features given.

Validation
<img width="434" height="79" alt="image" src="https://github.com/user-attachments/assets/2c00db62-bfc1-48db-a370-141f565dc697" />

// empty field validation
    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty || name.isEmpty || phone.isEmpty) {
      SnackBar snackBar = const SnackBar(
        content: Text('Please fill in all fields'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }


User must fill all the requirement to be able to register


<img width="360" height="67" alt="image" src="https://github.com/user-attachments/assets/be08b69a-8197-4fbf-9a80-68a7bc08a47a" />


    // password length validation > 6
    if (password.length < 6) {
      SnackBar snackBar = const SnackBar(
        content: Text('Password must be at least 6 characters long'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

Password not secure enough need 6 character for password


<img width="280" height="70" alt="image" src="https://github.com/user-attachments/assets/25e2e61b-1735-4c54-bc9f-cbe83da249ad" />

// phone number validation numeric only
    if (!RegExp(r'^[0-9]+$').hasMatch(phone)) {
      SnackBar snackBar = const SnackBar(
        content: Text('Please enter a valid phone number'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

When user not entering numeric value.

<img width="753" height="388" alt="image" src="https://github.com/user-attachments/assets/fd3e4fcd-4323-41de-9f19-01d983ea2ae4" />


// password match validation
    if (password != confirmPassword) {
      SnackBar snackBar = const SnackBar(
        content: Text('Passwords do not match'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

User not match password with confirm password


<img width="525" height="72" alt="image" src="https://github.com/user-attachments/assets/e76ea53f-eb91-4cb6-a9af-42aefe1c58df" />


if (!RegExp(r'^[\w-\.]+@(gmail|yahoo)(\.[A-Za-z]{2,3})+$').hasMatch(email)) {
      SnackBar snackBar = const SnackBar(
        content: Text('Please enter a valid personal email address (gmail or yahoo)'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

User not entering a gmail and yahoo account in the fields.



2.Login
User need to login first before can access the features

<img width="323" height="68" alt="image" src="https://github.com/user-attachments/assets/e87e9d87-6650-4fef-8dcc-6f2851bd874d" />


Validation

<img width="435" height="84" alt="image" src="https://github.com/user-attachments/assets/0eca6410-b725-465c-96bd-a469fd7907d1" />


// Input validation for email and password
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please fill in email and password"),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }

Users need to fill the fields


<img width="753" height="386" alt="image" src="https://github.com/user-attachments/assets/590b25ae-0b12-4983-b32a-ffe9d875cc9a" />


// Password length validation
    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Password must be at least 6 characters long'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }

Password need 6 character for password


<img width="525" height="88" alt="image" src="https://github.com/user-attachments/assets/851b5ea5-e1a9-43b7-8cad-baaaf0c7a425" />


 // Email format validation for personal email addresses only applicable to gmail and yahoo
    if (!RegExp(r'^[\w-\.]+@(gmail|yahoo)(\.[A-Za-z]{2,3})+$').hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter a valid personal email address (gmail or yahoo)'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }

User not entering a gmail and yahoo account in the fields.


<img width="320" height="366" alt="image" src="https://github.com/user-attachments/assets/199b2298-7a3c-41d2-a180-abac9b33bcc3" />


3.List of submission request
This page shows all the list of applications for submission from adoption to donation.

When clicking on the selection frame of an application, it will show


<img width="753" height="346" alt="image" src="https://github.com/user-attachments/assets/7e05ca3a-33fe-4432-8e12-102e60218a4c" />


Figure 3.1 detail page for adoption

<img width="303" height="349" alt="image" src="https://github.com/user-attachments/assets/8587489f-a45a-45a7-a1e3-b9b4a447da3c" />


Figure 3.2 detail page for donation

<img width="273" height="75" alt="image" src="https://github.com/user-attachments/assets/b5e9d5cb-9619-440a-be56-3b838d71cb7d" />


Picture above indicate a feature for use to use. Every one of them has own feature like filter, search, refresh, logout


Validation
if (widget.user?.userId == '0') {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Please login or register first"),
                  backgroundColor: Colors.red,
                ),
              );
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => loginScreen()),
              );

this is use when user enter the application without login first. The feature will restrict guest from accessing feature provide.

When user want to filter, they need to press filter icon on the right side at the top. It will show where user can filter based on pet type.

<img width="511" height="234" alt="image" src="https://github.com/user-attachments/assets/a1c2bf02-d055-40bd-b489-38a5dccc049d" />


Figure 3.3 filter feature

When user want to search, they need to press search icon on the right side of the top of the screen. It will show section where user need to fill the field based on the pet’s name.


<img width="62" height="65" alt="image" src="https://github.com/user-attachments/assets/77ba1f53-413a-4247-8be1-dafc927ccad8" />


Figure 3.4 search feature


When user need to refresh their list of submissions, user can click refresh button on the right corner of the screen (beside search icon)

<img width="59" height="73" alt="image" src="https://github.com/user-attachments/assets/d403762b-6c86-4340-bdbf-e6148a74b55b" />


Figure 3.5 refresh button
Lastly, user can logout from the system by clicking button below.

<img width="528" height="242" alt="image" src="https://github.com/user-attachments/assets/417ba823-bcb6-44d2-8ed2-68ed9347cb97" />


Figure 3.5 logout button



4.Request Issues

<img width="208" height="117" alt="image" src="https://github.com/user-attachments/assets/3b1e399a-84e6-42cb-a8d1-618148f2f527" />


Figure 4.1 submit button
When clicked the button, user can make their submission, and it will redirect to submit form

<img width="753" height="347" alt="image" src="https://github.com/user-attachments/assets/e87c1976-379e-47c6-b2e0-d03bc49ad302" />



5.Drawer

<img width="187" height="372" alt="image" src="https://github.com/user-attachments/assets/3fa690b6-51ab-41e5-bc8e-d2a4d587f352" />


Figure 5.1 Drawer

This is the drawer where it is identified as a user. There 3 sections where it will redirect to another page.

1.Home: List of submissions list

2.Donation: User donation on the application

3.Profile: User can edit their profile.

6.Adopt

<img width="389" height="87" alt="image" src="https://github.com/user-attachments/assets/de908eb6-a700-4680-b2ed-93da34b8c453" />


Figure 6.1 Adopt Pet button

When user press the button, user will need to fill adoption request by giving motivation message

<img width="417" height="59" alt="image" src="https://github.com/user-attachments/assets/408f130d-001d-4d3f-9f97-f79918e7e0ab" />


Figure 6.2 Adoption request
if user does not fill the request, it will show error message.

<img width="335" height="367" alt="image" src="https://github.com/user-attachments/assets/6716f025-3cc6-4e52-b568-f97d5d4d9bac" />


Figure 6.3 error message

<img width="319" height="365" alt="image" src="https://github.com/user-attachments/assets/7a5ac24a-198f-4bd8-80c6-6358dfc1e4bc" />


Figure 6.4 Adoption successful

When user fill, the adoption is successful.


7.Donation

<img width="316" height="360" alt="image" src="https://github.com/user-attachments/assets/920ad627-9865-458a-9bda-7f1f361bbbbe" />


Figure 7.1 donation gift

User press “donate for this pet’ and it will show a message to make choice whether to chose which type of donation.

<img width="301" height="286" alt="image" src="https://github.com/user-attachments/assets/1851a11b-fcdb-44c6-bd88-731a779d02ce" />


Figure 7.2 donation form

If user chose type of donation, user would show field that need to field before:

<img width="300" height="289" alt="image" src="https://github.com/user-attachments/assets/1f83c459-880f-447f-8146-d73e7dcb17ce" />


Figure 7.3 donation form money

<img width="557" height="255" alt="image" src="https://github.com/user-attachments/assets/ea97f840-cb37-469e-87d0-67b94e1da27e" />


Figure 7.4 donation form food

<img width="390" height="379" alt="image" src="https://github.com/user-attachments/assets/51052863-6d89-4482-83b0-9249446e2b01" />


Figure 7.5 donation form medical

Users need to fil the blank field to be able to make submission.

<img width="753" height="345" alt="image" src="https://github.com/user-attachments/assets/1f88d722-0045-49ae-856c-87039b66e6f0" />


Figure 7.6 donation list 

All the submission will show in here when user donate. They will access it on the drawer section of the left top of the screen.

8.Payment gateway

<img width="642" height="293" alt="image" src="https://github.com/user-attachments/assets/4c4e86df-6814-48c0-a3f4-78295770e4de" />


Figure 8.1 money donation

Users need to fill the value here using numerical value and it will redirect to payment gateway.

<img width="753" height="343" alt="image" src="https://github.com/user-attachments/assets/5c504e5a-014b-4f03-84b0-208d39e50f7e" />


Figure 8.2 payment gateway

User need to choice payment method and it will ask user to make payment or not.

<img width="753" height="345" alt="image" src="https://github.com/user-attachments/assets/df22cf69-2fa3-4380-b7d4-c80c01d250ae" />


Figure 8.3 payment gateway acceptation

If user press successfully payment, user will make payment and it will store in the database.

If user press failed payment, user will decline the payment and the payment will be cancelled

![Uploading image.png…]()


Figure 8.3 proceed to make payment

If the user presses the button, it will redirect to the link once they falsefully wrong press each button or close the application.


9.Edit profile

![Uploading image.png…]()


Figure 9.1 profile page
User can edit their profile here by using shared preferences and save it.


ERD table

![Uploading image.png…]()






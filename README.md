https://socstudentmusicforlife.com/azri/ - link for our application


Name: Muhammad Azri Asnawi Bin Kamal Arifin
Matric number: 30102

System Explanation
Pawpal is a web application for users who having difficulty relates to animal’s comfortability, safety ensuring a smooth flow for donation for all relates and pet adoption. Below is a explanation for pawpal system features and interfaces.
1.Registration.
The page is registration page where users need to register before they can access to all features given.

Validation

// empty field validation
    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty || name.isEmpty || phone.isEmpty) {
      SnackBar snackBar = const SnackBar(
        content: Text('Please fill in all fields'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

User must fill all the requirement to be able to register

    // password length validation > 6
    if (password.length < 6) {
      SnackBar snackBar = const SnackBar(
        content: Text('Password must be at least 6 characters long'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

Password not secure enough need 6 character for password

// phone number validation numeric only
    if (!RegExp(r'^[0-9]+$').hasMatch(phone)) {
      SnackBar snackBar = const SnackBar(
        content: Text('Please enter a valid phone number'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

When user not entering numeric value.

// password match validation
    if (password != confirmPassword) {
      SnackBar snackBar = const SnackBar(
        content: Text('Passwords do not match'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

User not match password with confirm password

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

Validation

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

3.List of submission request
This page shows all the list of applications for submission from adoption to donation.

When clicking on the selection frame of an application, it will show

Figure 3.1 detail page for adoption

Figure 3.2 detail page for donation


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

Figure 3.3 filter feature
When user want to search, they need to press search icon on the right side of the top of the screen. It will show section where user need to fill the field based on the pet’s name.

Figure 3.4 search feature


When user need to refresh their list of submissions, user can click refresh button on the right corner of the screen (beside search icon)

Figure 3.5 refresh button
Lastly, user can logout from the system by clicking button below.

Figure 3.5 logout button



4.Request Issues

Figure 4.1 submit button
When clicked the button, user can make their submission, and it will redirect to submit form

Figure 4.2. submission form


Users need to fill all the field to be able to make a submission.
Validation

if (petNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter name of the pet"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

This is used to check the name of pet must be fill.

if (kIsWeb && webImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select an image"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

This is error for image not entered by user

if (addressController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please press location button to get address"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

This is error for not click the location button and field the address section.

if (descriptionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter description"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

This is error for empty field for description

if (descriptionController.text.trim().length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter description at least 10 charaters") ,
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

This is error where user need to type 10 character on description.

5.Drawer

Figure 5.1 Drawer
This is the drawer where it is identified as a user. There 3 sections where it will redirect to another page.
1.Home: List of submissions list
2.Donation: User donation on the application
3.Profile: User can edit their profile.

6.Adopt

Figure 6.1 Adopt Pet button
When user press the button, user will need to fill adoption request by giving motivation message

Figure 6.2 Adoption request
if user does not fill the request, it will show error message.

Figure 6.3 error message

Figure 6.4 Adoption successful
When user fill, the adoption is successful.
7.Donation

Figure 7.1 donation gift
User press “donate for this pet’ and it will show a message to make choice whether to chose which type of donation.

Figure 7.2 donation form
If user chose type of donation, user would show field that need to field before:

Figure 7.3 donation form money

Figure 7.4 donation form food

Figure 7.5 donation form medical
Users need to fil the blank field to be able to make submission.

Figure 7.6 donation list 
All the submission will show in here when user donate. They will access it on the drawer section of the left top of the screen.
8.Payment gateway

Figure 8.1 money donation
Users need to fill the value here using numerical value and it will redirect to payment gateway.

Figure 8.2 payment gateway
User need to choice payment method and it will ask user to make payment or not.

Figure 8.3 payment gateway acceptation
If user press successfully payment, user will make payment and it will store in the database.
If user press failed payment, user will decline the payment and the payment will be cancelled

Figure 8.3 proceed to make payment
If the user presses the button, it will redirect to the link once they falsefully wrong press each button or close the application.
9.Edit profile

Figure 9.1 profile page
User can edit their profile here by using shared preferences and save it.


ERD table



API table
Method	Endpoint	Parameters	Description	Returns
POST	login_user.php	email, password	User login with email and password	User data on success
POST	register_user.php	email, password, name, phone	Register new user account	Registration status
GET	get_my_details.php	userid	Get details of user's submitted pets	Array of user's pets
GET	get_my_pets.php	curpage, search (optional)	Get paginated list of all pets with search	Paginated pet data with user details
POST	submit_pet.php	user_id, pet_name, pet_type, category, lat, lng, description, age, gender, health, image1, image2, image3	Submit a new pet for donation/adoption	Submission status
POST	insert_adoption.php	user_id, pet_id, submission_id, motivation	Submit adoption request for a pet	Adoption request status
POST	update_user_profile.php	user_id, name, phone, image (optional)	Update user profile information	Updated user data
GET	get_user_donations.php	user_id	Get all donations made by a specific user	Array of donations
GET	payment.php	email, phone, name, credits, userid, petid	Initiate payment via Billplz	Redirects to payment gateway
GET	payment_update.php	(Called by Billplz callback)	Handle payment callback from Billplz	Payment status page
POST	record_donation_non_payment.php	pet_id, user_id, donation_type, description, donor_name, donor_email, donor_phone	Record non-monetary donations (food/medical)	Donation status

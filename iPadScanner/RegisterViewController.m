//
//  RegisterViewController.m
//  iPadScanner
//
//  Created by Adeel Rehman on 10/18/11.
//  Copyright 2011 VeriQual. All rights reserved.
//

#import "RegisterViewController.h"
#import "DeviceManager.h"
#import "Constants.h"


@interface RegisterViewController (Private)
- (BOOL)checkFields;
- (BOOL)validateEmail:(NSString *)candidate;
- (void)enableFields:(BOOL)yesOrNo;
- (void)registerClicked;
@end


@implementation RegisterViewController

@synthesize lblCardNo, txtFirstName, txtLastName, txtEmail, txtFloor, txtCubicle;
@synthesize cardNo, employeeEmail, isManualScan;
@synthesize btnSearch, btnUnlock;
@synthesize delegate;
@synthesize innerView, lockImage;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil cardNo:(NSString *)_cardNo employeeEmail:(NSString *)_employeeEmail isManualScan:(BOOL)_isManualScan
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.cardNo = _cardNo;
        self.employeeEmail = _employeeEmail;
        self.isManualScan = _isManualScan;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	return [textField resignFirstResponder];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
	NSUInteger newLength = [textField.text length] + [string length] - range.length;
	
	NSCharacterSet *invalidCharSet = [[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLMOPQRSTUVWXYZ"] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:invalidCharSet] componentsJoinedByString:@""];
    	
	if ([textField isEqual:self.txtLastName] || [textField isEqual:self.txtFirstName]) {
		BOOL compare = [string isEqualToString:filtered];
		BOOL exceed = (newLength >= 40);
		
		return (compare && !exceed);
	}
	
    return (newLength >= 40) ? NO : YES;
}


#pragma mark - View lifecycle

- (void)dealloc {
    [super dealloc];
}

- (void)loadView {
    [super loadView];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Register";
    
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Register" style:UIBarButtonItemStyleDone target:self action:@selector(registerClicked)] autorelease];
	
    if (isManualScan) {
		self.txtEmail.enabled = NO;
        self.txtEmail.text = self.employeeEmail;
        self.lblCardNo.text = @"--";
		self.btnSearch.hidden = YES;
		[self enableFields:YES];
    }
    else {
        self.lblCardNo.text = self.cardNo;
		//self.navigationItem.rightBarButtonItem.enabled = NO;
		self.btnSearch.hidden = NO;
    }
	

	self.btnUnlock.hidden = YES;
	self.lockImage.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated   {
    [super viewWillAppear:animated];
	[[DeviceManager currentDevice] disable];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}


#pragma mark - IBActions

- (void)registerClicked {
    [self.view endEditing:YES];
    
    if ([Shared isNetworkAvailable]) {
        if ([self checkFields]) {
            self.navigationItem.rightBarButtonItem.enabled = NO;
            
			if (objEmployee) {
				if (objEmployee.isManual) {
					NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
					[dictionary setObject:self.txtEmail.text forKey:@"email"];
					[dictionary setObject:self.lblCardNo.text forKey:@"rf_id"];
					
					[self.serviceManager requestApi:@"employees/update_rf_id_by_email" forClass:@"employee" usingObj:dictionary requestMethod:@"PUT"];
				}
			}
			else {
				NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
				[dictionary setObject:self.lblCardNo.text forKey:@"rf_id"];
				[dictionary setObject:self.txtFirstName.text forKey:@"first_name"];
				[dictionary setObject:self.txtLastName.text forKey:@"last_name"];
				[dictionary setObject:self.txtEmail.text forKey:@"email_address"];        
				[dictionary setObject:self.txtFloor.text forKey:@"floor_number"];
				[dictionary setObject:self.txtCubicle.text forKey:@"cubical_number"];
				[dictionary setObject:Shared.email forKey:@"created_by_email"];
				[dictionary setObject:[NSNumber numberWithBool:self.isManualScan] forKey:@"is_manual"];
				
				[self.serviceManager requestApi:@"employees/register" forClass:@"employee" usingObj:dictionary requestMethod:@"POST"];
			}
        }
    }
    else {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Information" message:kNetworkError delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [av show];
        [av release];
    }
}


- (IBAction)unlockClicked {
	self.txtEmail.enabled = YES;
	
	self.btnSearch.hidden = NO;
	self.btnUnlock.hidden = YES;
	
	self.txtFirstName.text = @"";
	self.txtLastName.text = @"";
	self.txtFloor.text = @"";
	self.txtCubicle.text = @"";
	
	self.lockImage.hidden = YES;
	
	[self enableFields:NO];
	self.navigationItem.rightBarButtonItem.enabled = NO;
	
	[self.txtEmail becomeFirstResponder];
}

- (IBAction)searchClicked {
	objEmployee = nil;
	
	if ([Shared isNetworkAvailable]) {
		UIAlertView *av;
		if ([[self.txtEmail.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]<=0) {
			av = [[UIAlertView alloc] initWithTitle:@"Information" message:@"Please enter an email." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[av show];
			[av release];
			return;
		}
		else if (![self validateEmail:self.self.txtEmail.text]) {
			av = [[UIAlertView alloc] initWithTitle:@"Information" message:@"Please enter a valid email." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[av show];
			[av release];
			return;
		}
		
		//self.btnRegister.enabled = NO;
		self.navigationItem.rightBarButtonItem.enabled = NO;
		
		NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
		[dictionary setObject:self.txtEmail.text forKey:@"email_address"];
		
		[self.serviceManager requestApi:@"employees/get_by_email" forClass:@"employee" usingObj:dictionary];
	}
	else {
		UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Information" message:kNetworkError delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [av show];
        [av release];
	}
}


#pragma mark - Private Methods

- (BOOL)checkFields {
    UIAlertView *av = nil;
	BOOL status = YES;
	NSString *message = nil;
	
	if (txtFirstName.text.length > 0 && 
		txtLastName.text.length > 0 && 
		txtEmail.text.length > 0 && 
		txtCubicle.text.length > 0 && 
		txtFloor.text.length > 0)	{
		
		// check first name
		NSString *nameRegex = @"[a-zA-Z]{2,25}"; 
		NSPredicate *nameTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", nameRegex]; 	
		
		NSString *numRegex = @"[0-9]{1,4}"; 
		NSPredicate *numTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numRegex]; 	
		
		if (![nameTest evaluateWithObject:self.txtFirstName.text])	{
			if (self.txtFirstName.text.length < 2)
				message = @"Too short. Please enter a valid first name.";
			else if (self.txtFirstName.text.length > 25)
				message = @"Too long. Please enter a valid first name.";
			else
				message = @"First name should be alphabetic only.";
			
			status = NO;			
		}	
		// check last name
//		else if (![nameTest evaluateWithObject:self.txtLastName.text])	{
//			if (self.txtLastName.text.length < 2)
//				message = @"Too short. Please enter a valid last name.";
//			else if (self.txtLastName.text.length > 25)
//				message = @"Too long. Please enter a valid last name.";
//			else
//				message = @"Last name should be alphabetic only.";
//			
//			status = NO;			
//		}
		// check email
		else if (![self validateEmail:self.txtEmail.text]) {
			message = @"Please enter a valid email.";
			status = NO;
		}
		// check cubical
		if (![numTest evaluateWithObject:self.txtCubicle.text])	{
			if (self.txtFirstName.text.length > 6)
				message = @"Too long. Please enter a valid cubical.";
			else
				message = @"Cubical should be numeric only.";
			
			status = NO;			
		}
		// check floor
		if (![numTest evaluateWithObject:self.txtFloor.text])	{
			if (self.txtFirstName.text.length > 4)
				message = @"Too long. Please enter a valid Floor.";
			else
				message = @"Floor should be numeric only.";
			
			status = NO;			
		}
	}	else	{
		NSArray *txtFields = [NSArray arrayWithObjects:txtFirstName, txtLastName, txtEmail, txtFloor, txtCubicle, nil];
		for (UITextField *txtField in txtFields) {
			if (txtField.text.length == 0)	{
				message = [NSString stringWithFormat:@"Please enter %@.", [txtField.placeholder lowercaseString]];
				status = NO;
				break;
			}
		}
	}
	
	if (!status)
		av = [[UIAlertView alloc] initWithTitle:@"Information!" 
										message:message 
									   delegate:nil
							  cancelButtonTitle:@"OK"
							  otherButtonTitles:nil];
	[av show];
	[av release];
	return status;
}


- (BOOL)validateEmail:(NSString *)candidate {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"; 
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex]; 	
    return [emailTest evaluateWithObject:candidate];
}


- (void)enableFields:(BOOL)yesOrNo {
	self.txtFirstName.enabled = yesOrNo;
	self.txtLastName.enabled = yesOrNo;
	self.txtFloor.enabled = yesOrNo;
	self.txtCubicle.enabled = yesOrNo;
}


#pragma mark - Service Manager Delegates

- (void)serviceManagerDidSuccessfullyRecievedResponse:(NSDictionary *)response forApi:(NSString *)api {
	self.navigationItem.rightBarButtonItem.enabled = YES;
	
	if ([api isEqualToString:@"employees/get_by_email"]) {
		objEmployee = [[Employee alloc] initWithDictionary:[response objectForKey:@"employee"]];
		if (objEmployee.isManual) {
			self.txtFirstName.text = objEmployee.firstName;
			self.txtLastName.text = objEmployee.lastName;
			self.txtFloor.text = objEmployee.floorNumber;
			self.txtCubicle.text = objEmployee.cubicalNumber;
			
			self.txtEmail.enabled = NO;			
			self.lockImage.hidden = NO;
			self.btnUnlock.hidden = NO;
			self.btnSearch.hidden = YES;
		}
		else {
			UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Information" message:@"Email you provided is already registered with a valid RFID. Please select another email." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[av show];
			[av release];
		
			self.navigationItem.rightBarButtonItem.enabled = NO;
		}
	}
    else if ([api isEqualToString:@"employees/register"]) {    
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Information" message:@"Employee registered successfully." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [av show];
        [av release];
    }
	else if ([api isEqualToString:@"employees/update_rf_id_by_email"]) {    
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Information" message:@"Employee updated successfully." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [av show];
        [av release];
    }
}

- (void)serviceManagerDidRecievedCode:(int)code withResponse:(NSDictionary *)response forApi:(NSString *)api {
    
	self.navigationItem.rightBarButtonItem.enabled = YES;
    
    UIAlertView *av;
    
	if (code == 404) {
		av = [[UIAlertView alloc] initWithTitle:@"Information" message:@"Email ID is available!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [av show];
        [av release];
		
		self.txtEmail.enabled = NO;			
		self.lockImage.hidden = NO;
		self.btnUnlock.hidden = NO;
		self.btnSearch.hidden = YES;
		
		[self enableFields:YES];
	}
    else if (code == 500) {
        av = [[UIAlertView alloc] initWithTitle:[response valueForKey:@"status"] message:[response valueForKey:@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [av show];
        [av release];
    }
    else if (code == 501) {
        NSArray *errors = [response objectForKey:@"errors"];
        av = [[UIAlertView alloc] initWithTitle:@"Error!" message:[errors objectAtIndex:0] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [av show];
        [av release];
    }
    else if (code == 999) {
        av = [[UIAlertView alloc] initWithTitle:@"Unknown Error" message:@"Invalid response from server" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [av show];
        [av release];
    }
}

- (void)serviceManagerDidFailedWithError:(NSError *)error forApi:(NSString *)api {
    if (error) {
		self.navigationItem.rightBarButtonItem.enabled = YES;
        
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error!" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [av show];
        [av release];
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex  {
    if (buttonIndex == 0)   {
		if (self.isManualScan) {
			[delegate emailViewDidSearchEmail:self.employeeEmail];
		}
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end

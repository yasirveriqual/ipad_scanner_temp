//
//  NewEmergencyViewController.m
//  iPadScanner
//
//  Created by Adeel Rehman on 11/29/11.
//  Copyright (c) 2011 VeriQual. All rights reserved.
//

#import "NewEmergencyViewController.h"
#import "Constants.h"
//#import "Bluetooth.h"
#import "DeviceManager.h"


@interface NewEmergencyViewController (Private)
- (BOOL)checkFields;
@end


@implementation NewEmergencyViewController

@synthesize navItem;
@synthesize emergencyTextField, startDateTextField;
@synthesize imgStartDate;
@synthesize datePopover, dateDropdownController;
@synthesize delegate;
@synthesize emergencyModel;
@synthesize editDataFlag;
@synthesize btnSave;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil emergencyModel:(Emergency *)_emergency {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.emergencyModel = _emergency;
    }
    return self;
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)dismissModalViewControllerAnimated:(BOOL)animated   {
    self.delegate = nil;
    [super dismissModalViewControllerAnimated:animated];
}

- (void)dealloc	{
	self.delegate = nil;
	[btnSave release];
	[navItem release];
	[emergencyTextField release];
	[startDateTextField release];
	[imgStartDate release];
	[datePopover release];
	[dateDropdownController release];
	[emergencyModel release];
    [super dealloc];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	return [textField resignFirstResponder];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
	NSUInteger newLength = [textField.text length] + [string length] - range.length;
	
    return (newLength >= 40) ? NO : YES;
}


#pragma mark - Private Methods

- (BOOL)checkFields {
    UIAlertView *av;
    if ([[self.emergencyTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]<=0) {
        av = [[UIAlertView alloc] initWithTitle:@"Information" message:@"Please enter an emergency." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[av show];
		[av release];
		return  NO;
    }
    else if ([[self.startDateTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]<=0) {
        av = [[UIAlertView alloc] initWithTitle:@"Information" message:@"Please select start date." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[av show];
		[av release];
		return  NO;
    }
    else { 
		return YES;
    }
}


#pragma mark - IBActions

- (IBAction)selectStartDate:(id)sender {
    [self.view endEditing:YES];
    
    dateDropdownController = nil;
    
    if (dateDropdownController == nil) {
        self.dateDropdownController = [[[DatePickerDropdownViewController alloc] initWithNibName:@"DatePickerDropdownViewController" bundle:nil textField:self.startDateTextField] autorelease];
        
        self.datePopover = [[[UIPopoverController alloc] initWithContentViewController:dateDropdownController] autorelease];
    }
    
    [self.datePopover presentPopoverFromRect:CGRectMake(self.imgStartDate.frame.origin.x+8, (self.imgStartDate.frame.origin.y+self.imgStartDate.frame.size.height-5), 290, 250) inView:self.view permittedArrowDirections:0 animated:YES];
}

- (IBAction)cancelClicked:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}


- (IBAction)saveBtnClicked:(id)sender {
    [self.view endEditing:YES];
    
    if ([self checkFields]) {
        if ([Shared isNetworkAvailable]) {
            self.btnSave.enabled = NO;
            
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setObject:self.emergencyTextField.text forKey:@"name"];
            [dict setObject:[[NSDate dateFromString:self.startDateTextField.text] rfc3339String] forKey:@"start_date"];
            
            NSString *strReqApi;
            NSString *strKey;
            
            if (self.editDataFlag) {
                strKey = @"updated_by_email";
                strReqApi = [NSString stringWithFormat:@"emergencies/%i", self.emergencyModel.ID];
                [dict setObject:Shared.email forKey:strKey];
                [self.serviceManager requestApi:strReqApi forClass:@"emergency" usingObj:dict requestMethod:@"PUT"];
            }
            else {
                strKey = @"created_by_email";
                strReqApi = @"emergencies";
                [dict setObject:Shared.email forKey:strKey];
                [self.serviceManager requestApi:strReqApi forClass:@"emergency" usingObj:dict requestMethod:@"POST"];
            }
            
        }
        else {
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Information" message:kNetworkError delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [av show];
            [av release];
        }
    }
}


#pragma mark Service Manager Delegate

- (void)serviceManagerDidSuccessfullyRecievedResponse:(NSDictionary *)response forApi:(NSString *)api {
    if ([api hasPrefix:@"emergencies"]) {
        self.btnSave.enabled = YES;
        [delegate loadEmergencies];
        [self dismissModalViewControllerAnimated:YES];
    }
}

- (void)serviceManagerDidRecievedCode:(int)code withResponse:(NSDictionary *)response forApi:(NSString *)api {
    self.btnSave.enabled = YES;
    
    UIAlertView *av;
    
    if (code == 500) {
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
        self.btnSave.enabled = YES;
        
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error!" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [av show];
        [av release];
    }
}

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	[[DeviceManager currentDevice] disable];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.emergencyModel) {
		self.navItem.title = @"Edit Emergency";
        self.editDataFlag = YES;
        
        self.emergencyTextField.text = self.emergencyModel.name;
        self.startDateTextField.text = [self.emergencyModel.startDate stringValue];
    }
    else {
        self.editDataFlag = NO;
		self.startDateTextField.text = [[NSDate date] stringValue];
    }
	
	
	[self performSelector:@selector(showKeyboard) withObject:nil afterDelay:0.5];
}


- (void)showKeyboard {
	[self.emergencyTextField becomeFirstResponder];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

@end

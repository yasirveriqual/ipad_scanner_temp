//
//  NewScanViewController.m
//  iPadScanner
//
//  Created by Adeel Rehman on 10/21/11.
//  Copyright 2011 VeriQual. All rights reserved.
//

#import "NewScanViewController.h"
#import "NSDate-Utilities.h"
#import "DeviceManager.h"
#import "Constants.h"

@interface NewScanViewController (Private)
- (BOOL)checkFields;
//- (void)loadEmergencies;
- (void)saveClicked;
@end


@implementation NewScanViewController

@synthesize innerView;
@synthesize btnSave;
@synthesize scanSessionNameTextField;
@synthesize startDateTextField, endDateTextField, emergencyTextField;
@synthesize imgStartDate, imgEndDate, imgEmergency;
@synthesize datePopover, dateDropdownController;
@synthesize emergencyPopover, emergencyDropdownController;
@synthesize delegate;
@synthesize emergencyList;
@synthesize selectedEmergency;
@synthesize scanModel;
@synthesize lblTitleText;
@synthesize editDataFlag;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil scanModel:(Scan *)_scan {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.scanModel = _scan;
    }
    return self;
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)dealloc
{
    self.delegate = nil;
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

#pragma mark - IBActions

- (IBAction)selectEmergency:(id)sender {
    [self.view endEditing:YES];
    
    emergencyDropdownController = nil;
    
    if (emergencyDropdownController == nil) {
        self.emergencyDropdownController = [[[EmergencyDropdownViewController alloc] initWithStyle:UITableViewStylePlain] autorelease];
        self.emergencyPopover = [[[UIPopoverController alloc] initWithContentViewController:self.emergencyDropdownController] autorelease];
        self.emergencyDropdownController.emergencies = self.emergencyList;
        self.emergencyDropdownController.canEditEmergency = YES;
        self.emergencyDropdownController.delegate = self;
        [self.emergencyPopover presentPopoverFromRect:CGRectMake(self.imgEmergency.frame.origin.x+8, (self.imgEmergency.frame.origin.y+self.imgEmergency.frame.size.height+10), 290, 220) inView:self.innerView permittedArrowDirections:0 animated:YES];
		[self.emergencyDropdownController pullAllEmergencies];
    }
}


- (IBAction)selectStartDate:(id)sender {
    [self.view endEditing:YES];
    
    dateDropdownController = nil;
    
    if (dateDropdownController == nil) {
        self.dateDropdownController = [[[DatePickerDropdownViewController alloc] initWithNibName:@"DatePickerDropdownViewController" bundle:nil textField:self.startDateTextField] autorelease];
        
        self.datePopover = [[[UIPopoverController alloc] initWithContentViewController:dateDropdownController] autorelease];
    }
    
    [self.datePopover presentPopoverFromRect:CGRectMake(self.imgStartDate.frame.origin.x+8, (self.imgStartDate.frame.origin.y+self.imgStartDate.frame.size.height-5), 290, 250) inView:self.innerView permittedArrowDirections:0 animated:YES];
}

- (IBAction)selectEndDate:(id)sender {
    [self.view endEditing:YES];
    
    dateDropdownController = nil;
    
    if (dateDropdownController == nil) {
        self.dateDropdownController = [[[DatePickerDropdownViewController alloc] initWithNibName:@"DatePickerDropdownViewController" bundle:nil textField:self.endDateTextField] autorelease];
        
        self.datePopover = [[[UIPopoverController alloc] initWithContentViewController:dateDropdownController] autorelease];
    }
    
    [self.datePopover presentPopoverFromRect:CGRectMake(self.imgEndDate.frame.origin.x+8, (self.imgEndDate.frame.origin.y+self.imgEndDate.frame.size.height-5), 290, 250) inView:self.innerView permittedArrowDirections:0 animated:YES];
}

- (IBAction)cancelClicked:(id)sender {
    [self.view endEditing:YES];
    [self dismissModalViewControllerAnimated:NO];
}


- (void)saveClicked {
    [self.view endEditing:YES];
    
    if ([self checkFields]) {
        if ([Shared isNetworkAvailable]) {
            self.btnSave.enabled = NO;
            
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            
            [dict setObject:self.scanSessionNameTextField.text forKey:@"name"];
            [dict setObject:[[NSDate dateFromString:self.startDateTextField.text] rfc3339String] forKey:@"start_date"];
            [dict setObject:[[NSDate dateFromString:self.endDateTextField.text] rfc3339String] forKey:@"end_date"];
			if ([[self.emergencyTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]<=0) {
				[dict setObject:[NSString stringWithFormat:@"%d", 0] forKey:@"emergency_id"];
				[dict setObject:[NSString stringWithFormat:@"%d", 1] forKey:@"is_default_emergency"];
			}				
			else {
				[dict setObject:[NSString stringWithFormat:@"%d", self.selectedEmergency.ID] forKey:@"emergency_id"];
				[dict setObject:[NSString stringWithFormat:@"%d", 0] forKey:@"is_default_emergency"];
			}				
			
            NSString *strReqApi;
            NSString *strKey;
            
            if (self.editDataFlag) {
                strKey = @"updated_by_email";
                strReqApi = [NSString stringWithFormat:@"scan_sessions/%i", self.scanModel.ID];
                [dict setObject:[NSString stringWithFormat:@"%d", self.selectedEmergency.ID] forKey:@"emergency_id"];
                [dict setObject:Shared.email forKey:strKey];
                [self.serviceManager requestApi:strReqApi forClass:@"scan" usingObj:dict requestMethod:@"PUT"]; 
            }
            else {
                strKey = @"created_by_email";
                strReqApi = @"scan_sessions";
                [dict setObject:Shared.email forKey:strKey];
                [self.serviceManager requestApi:strReqApi forClass:@"scan" usingObj:dict requestMethod:@"POST"]; 
            }
            
            [dict release];
        }
        else {
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Information" message:kNetworkError delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [av show];
            [av release];
        }
    }
}


- (IBAction)addClicked:(id)sender {
	[self.view endEditing:YES];
	
    NewEmergencyViewController *viewController = [[NewEmergencyViewController alloc] initWithNibName:@"NewEmergencyViewController" bundle:nil];
    viewController.delegate = self;
    viewController.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentModalViewController:viewController animated:YES];
    viewController.view.superview.frame = CGRectMake(0, 0, 511, 223);
    viewController.view.superview.center = self.view.superview.center;
}



#pragma mark - EmergencyDropdownViewControllerDelegate

- (void)itemSelected:(Emergency *)item {
    if (selectedEmergency) {
        [selectedEmergency release];
    }
    
    self.selectedEmergency = item;
    self.emergencyTextField.text = self.selectedEmergency.name;
    [self.emergencyPopover dismissPopoverAnimated:YES];
}


- (void)editEmergency:(Emergency *)emergency {
    [self.emergencyPopover dismissPopoverAnimated:YES];
    
    NewEmergencyViewController *viewController = [[NewEmergencyViewController alloc] initWithNibName:@"NewEmergencyViewController" bundle:nil emergencyModel:emergency];
    viewController.delegate = self;
    viewController.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentModalViewController:viewController animated:YES];
    viewController.view.superview.frame = CGRectMake(0, 0, 511, 223);
    viewController.view.superview.center = self.view.superview.center;
}


#pragma mark - ServiceManagerDelegate

- (void)serviceManagerDidSuccessfullyRecievedResponse:(NSDictionary *)response forApi:(NSString *)api {
	if ([api hasPrefix:@"scan_sessions"]) {
        self.btnSave.enabled = YES;
        [delegate reloadScans];
        [self.navigationController popViewControllerAnimated:YES];
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
    if ([api hasPrefix:@"scan_sessions"]) {
        self.btnSave.enabled = YES;
    }
    if (error) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error!" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [av show];
        [av release];
    }
}


#pragma mark - Private Methods

- (BOOL)checkFields {
    UIAlertView *av;
    if ([[self.scanSessionNameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]<=0) {
        av = [[UIAlertView alloc] initWithTitle:@"Information" message:@"Please enter session name." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
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
    else if ([[self.endDateTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]<=0) {
        av = [[UIAlertView alloc] initWithTitle:@"Information" message:@"Please select end date." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[av show];
		[av release];
		return  NO;
    }
    else {
        NSDate *endDate = [NSDate dateFromString:self.endDateTextField.text];      
        NSDate *startDate = [NSDate dateFromString:self.startDateTextField.text];
        
        NSComparisonResult result = [endDate compare:startDate];
        if (!(result == NSOrderedSame || result == NSOrderedDescending))   {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Start Date must be less than End Date." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alertView show];
            [alertView release];
            return NO;
        }
        
        return YES;
    }
}


- (void)loadEmergencies {
    if (![Shared isNetworkAvailable]) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Information" message:kNetworkError delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [av show];
        [av release];
    }
}


#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated   {
    [super viewWillAppear:animated];
	[[DeviceManager currentDevice] disable];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	self.title = @"New Scan";
    self.emergencyList = [NSMutableArray array];
	
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleDone target:self action:@selector(saveClicked)] autorelease];
    
    if (scanModel) {
        self.lblTitleText.text = @"Edit Scan Session";
        self.editDataFlag = YES;
        
		self.scanSessionNameTextField.text = self.scanModel.scanSessionName;
        
        self.startDateTextField.text = [[NSDate dateFromInternetDateTimeString:self.scanModel.scanSessionStartDate] stringValue];
        self.endDateTextField.text = [[NSDate dateFromInternetDateTimeString:self.scanModel.scanSessionEndDate] stringValue];
		self.emergencyTextField.text = [[self.scanModel.emergency.name lowercaseString] isEqualToString:@"default"]? @"" : self.scanModel.emergency.name;
        self.selectedEmergency = self.scanModel.emergency;
    }
    else {
        self.editDataFlag = NO;
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewDidAppear:(BOOL)animated {
    [self.scanSessionNameTextField becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated    {
    [super viewWillDisappear:animated];
	[[DeviceManager currentDevice] enable];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    [self.datePopover dismissPopoverAnimated:NO];
	[self.emergencyPopover dismissPopoverAnimated:NO];
	return YES;
}


- (BOOL)disablesAutomaticKeyboardDismissal {
    return NO;
}

@end

//
//  CardScannerViewController.m
//  iPadScanner
//
//  Created by Adeel Rehman on 10/20/11.
//  Copyright 2011 VeriQual. All rights reserved.
//

#import "CardScannerViewController.h"
#import "RegisterViewController.h"
#import "Employee.h"
//#import "Bluetooth.h"
#import "DeviceManager.h"


@interface CardScannerViewController (Private)
- (BOOL)checkFields;
- (void)checkRfid;
@end


@implementation CardScannerViewController

@synthesize txtCardNo;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    [txtCardNo release];
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Acquire Card No.";
	[[DeviceManager currentDevice] enable];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //[Bluetooth turnOn];
	
	[[DeviceManager currentDevice] enable];
    [self.txtCardNo becomeFirstResponder];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

#pragma mark - Private Methods


- (void)checkRfid {
    [self.view endEditing:YES];
    if ([self checkFields]) {
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        [dictionary setObject:self.txtCardNo.text forKey:@"rf_id"];
        [self.serviceManager requestApi:@"employees/get_by_rf_id" forClass:@"employee" usingObj:dictionary];
    }
}


#pragma mark - UITextField Delegates

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self checkRfid];
    return YES;
}


#pragma mark - Service Manager Delegates

- (void)serviceManagerDidSuccessfullyRecievedResponse:(NSDictionary *)response forApi:(NSString *)api {
    if ([api isEqualToString:@"employees/get_by_rf_id"]) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Information" message:@"Already Exist" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [av show];
        [av release];
        
        self.txtCardNo.text = @"";
        [self.txtCardNo becomeFirstResponder];
    }
}

- (void)serviceManagerDidRecievedCode:(int)code withResponse:(NSDictionary *)response forApi:(NSString *)api	{
    if ([api isEqualToString:@"employees/get_by_rf_id"]) {
        if (code == 404) {
            RegisterViewController *registerVC = [[RegisterViewController alloc] initWithNibName:@"RegisterViewController" bundle:nil cardNo:self.txtCardNo.text employeeEmail:@"" isManualScan:NO];
            [self.navigationController pushViewController:registerVC animated:YES];
            [registerVC release];
            
            self.txtCardNo.text = @"";
        }
        else if (code == 500) {
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:[response valueForKey:@"status"] message:[response valueForKey:@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [av show];
            [av release];
        }
        else if (code == 999) {
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Unknown Error" message:@"Invalid response from server" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [av show];
            [av release];
        }
    }
}

- (void)serviceManagerDidFailedWithError:(NSError *)error forApi:(NSString *)api {
    if (error) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error!" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [av show];
        [av release];
    }
}


#pragma mark - Private Methods

- (BOOL)checkFields {
    UIAlertView *av;
    if ([[self.txtCardNo.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]<=0) {
        av = [[UIAlertView alloc] initWithTitle:@"Information" message:@"Please enter card no." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[av show];
		[av release];
		return  NO;
    }
    else {
		NSString *numberRegex = @"[0-9]{2,15}"; 
		NSPredicate *numberTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numberRegex]; 	
		BOOL status = [numberTest evaluateWithObject:self.txtCardNo.text];
		
		if (!status)	{
			NSString *message = nil;
			if (self.txtCardNo.text.length < 2)
				message = @"Too short. Please enter a valid card no.";
			else if (self.txtCardNo.text.length > 15)
				message = @"Too long. Please enter a valid card no.";
			else
				message = @"Please enter numeric value only.";
			
			av = [[UIAlertView alloc] initWithTitle:@"Information" 
											message:message
										   delegate:nil 
								  cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[av show];
			[av release];
			return  NO;			
		}
		
        return status;
    }
}

@end

//
//  PersonTableViewCell.m
//  iPadScanner
//
//  Created by Yasir Ali on 10/18/11.
//  Copyright 2011 VeriQual. All rights reserved.
//

#import "EmployeeTableViewCell.h"
#import <QuartzCore/QuartzCore.h>
#import "LocationManager.h"
#import "Constants.h"
#import "JSONKit.h"
#import "Environment.h"
#import <dispatch/dispatch.h>

@implementation EmployeeTableViewCell


@synthesize idTextField;
@synthesize firstNameLabel;
@synthesize lastNameLabel;
@synthesize emailLabel;
@synthesize employee;
@synthesize delegate;

@synthesize locationLabel;


- (void)awakeFromNib    {
    [super awakeFromNib];
    activityView.layer.cornerRadius = 5;
	activityView.layer.borderWidth = 0;
    idTextField.delegate = self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)startActivity   {
//    [self.idTextField setEnabled:NO];
    [activityIndicatorView startAnimating];
	activityView.hidden = NO;
}

- (void)stopActivity    {
    [activityIndicatorView stopAnimating];
	activityView.hidden = YES;
}

- (void)setEmployee:(Employee *)emp   {
    if (emp == nil) {
        idTextField.enabled = YES;
        idTextField.text = @"";
        firstNameLabel.text = @"";
        lastNameLabel.text = @"";
        emailLabel.text = @"";
        locationLabel.text = @"";
        employee = emp;
    }   
    else {
        if (employee)   {
            [employee release];
            employee = nil;
        }
        employee = [emp retain];
        idTextField.text = employee.rfid;
        idTextField.enabled = NO;
        firstNameLabel.text = employee.firstName;
        lastNameLabel.text = employee.lastName;
        emailLabel.text = employee.emailAddress;
		locationLabel.text = employee.locationName;
    }
    [self stopActivity];
}

- (void)fetchEmployeeData	{
	NSDictionary *dictionary;
	if ([delegate employeeTableViewCell:self didSearchRfid:idTextField.text withDictionary:&dictionary])	{
		
		
		[self performSelectorOnMainThread:@selector(startActivity) withObject:nil waitUntilDone:YES];
		[delegate addEmployee:self.employee];
		
		//[NSThread detachNewThreadSelector:@selector(checkinEmployeeWithDictionary:) toTarget:self withObject:dictionary];
		[self checkinEmployeeWithDictionary:dictionary];
	}
}



#pragma mark - Thread Handler

- (void)checkinEmployeeWithDictionary:(NSDictionary *)dictionary	{
	//NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
	dispatch_async(queue, ^(void) {
		NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:dictionary];
		[dict setObject:self.employee.rfid forKey:@"employee_rf_id"];
		[dict setObject:[NSString stringWithFormat:@"%f", [LocationManager getInstance].userLocation.coordinate.latitude] forKey:@"latitude"];
		[dict setObject:[NSString stringWithFormat:@"%f", [LocationManager getInstance].userLocation.coordinate.longitude] forKey:@"longitude"];
		[dict setObject:Shared.email forKey:@"created_by_email"];
		
		if (Session.authenticationToken != nil)	
		{
			NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@employees/check_in.json", Environment.serverURL]]];
			
			[request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
			request.timeoutInterval = 20;
			
			NSDictionary *dic = [NSDictionary dictionaryWithObject:
								 [NSDictionary dictionaryWithObjectsAndKeys:dict, 
								  @"employee", 
								  Session.authenticationToken,
								  @"auth_token", nil] 
															forKey:@"request"];
			NSLog(@"URL: %@\nRequest JSON: %@", [request.URL absoluteString], [dic JSONString]);
			NSMutableData *requestData = [[[NSMutableData alloc] initWithData:[dic JSONData]] autorelease];
			[request setValue:[NSString stringWithFormat:@"%d",requestData.length] forHTTPHeaderField:@"Content-Length"];
			
			request.HTTPBody = requestData;
			request.HTTPMethod = @"POST";
			
			NSError* error = nil;
			
			//Capturing server response
			NSData* result = [NSURLConnection sendSynchronousRequest:request  returningResponse:nil error:&error];
			
			if (error == nil)	{
				NSString *responseString = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
				
				
				NSLog(@"Response: %@", responseString);
				NSDictionary *response = [[responseString objectFromJSONString] valueForKey:@"response"];
				NSUInteger code = [[response valueForKey:@"code"] integerValue];
				
				if (code == 200)
				{
					NSDictionary *employeeDictionary = [response objectForKey:@"employee"];
					
					self.employee.ID = [[employeeDictionary valueForKey:@"id"] intValue]; 
					self.employee.createdByEmail = [employeeDictionary valueForKey:@"created_by_email"];
					self.employee.cubicalNumber = [employeeDictionary valueForKey: @"cubical_number"];
					self.employee.emailAddress = [employeeDictionary valueForKey: @"email_address"];
					self.employee.firstName = [employeeDictionary valueForKey: @"first_name"];
					self.employee.floorNumber = [employeeDictionary valueForKey: @"floor_number"];
					self.employee.lastName = [employeeDictionary valueForKey: @"last_name"];
					self.employee.middleName = [employeeDictionary valueForKey: @"middle_name"];
					self.employee.phoneNumber = [employeeDictionary valueForKey: @"phone_number"];
					self.employee.locationID = [[employeeDictionary valueForKey:@"location_id"] integerValue];
					self.employee.locationName = [employeeDictionary valueForKey: @"location_name"];
					self.employee.latitude = [employeeDictionary valueForKey: @"latitude"];
					self.employee.longitude = [employeeDictionary valueForKey: @"longitude"];
					self.employee.isManual = [[employeeDictionary valueForKey:@"is_manual"] boolValue];
					
					idTextField.text = employee.rfid;
					idTextField.enabled = NO;
					
					[self stopActivity];
					[self performSelectorOnMainThread:@selector(didSuccessfullyCheckedIn) withObject:nil waitUntilDone:NO];
				}
				[responseString release];
			}		
			else {
				[self performSelectorOnMainThread:@selector(didFailedWithError:) withObject:error waitUntilDone:NO];
			}
		}
		else	{
			[Session logout];
			UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error" message:@"You have been logged out from system." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[av show];
			[av release];
		}
	});
	//[pool release];
}

- (void)didFailedWithError:(NSError *)error {
	self.employee.firstName = [error localizedDescription];
	[self setNeedsLayout];
}


- (void)didSuccessfullyCheckedIn {
	[delegate reloadScansData];
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField  {
	
	NSString *numberRegex = @"[0-9]{2,15}"; 
	NSPredicate *numberTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numberRegex]; 	
	BOOL status = [numberTest evaluateWithObject:textField.text];
	
	if (status)	{
		if ([delegate respondsToSelector:@selector(employeeTableViewCell:didSearchRfid:withDictionary:)]) {
			[activityIndicatorView startAnimating];
			activityView.hidden = NO;
			[self performSelector:@selector(fetchEmployeeData)];
			return YES;
        }
	}
	else	{
		
		NSString *message = nil;
		if (textField.text.length < 2)
			message = @"Too short value.";
		else if (textField.text.length > 15)
			message = @"Too long value.";
		else
			message = @"Please use numeric value only.";
		
		
		
		UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Information" 
													 message:message
													delegate:nil 
										   cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[av show];
		[av release];
		return  NO;			
	}
	
	return status;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField	{
	self.employee = [[[Employee alloc] init] autorelease];
	
	self.employee.createdByEmail = @"";
	self.employee.cubicalNumber = @"";
	self.employee.emailAddress = @"";
	self.employee.firstName = @"Downloading...";
	self.employee.floorNumber = @"";
	self.employee.lastName = @"";
	self.employee.middleName = @"";
	self.employee.phoneNumber = @"";
	self.employee.rfid = idTextField.text;
	self.employee.locationID = 0;
	self.employee.locationName = @"";
	self.employee.latitude = @"";
	self.employee.longitude = @"";
	self.employee.isManual = NO;
	NSLog(@"Employee RFID: %@", self.employee.rfid);
	NSLog(@"Employee RFID: %@", idTextField.text);
	return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string	{
//	NSLog(@"R: %@", textField.text);
	self.employee.rfid = [NSString stringWithFormat:@"%@%@", textField.text, string];
	return YES;
}

@end

//
//  ScansView.m
//  iPadScanner
//
//  Created by Yasir Ali on 10/19/11.
//  Copyright 2011 VeriQual. All rights reserved.
//

#import "ScanDetailView.h"
#import <QuartzCore/QuartzCore.h>
#import "LocationManager.h"


@implementation ScanDetailView

@synthesize scanName;
@synthesize employeesTableView;
@synthesize backgroundImageView;
@synthesize delegate;
@synthesize currentEmployeeTableViewCell;
@synthesize scan;


- (void)awakeFromNib	{
	[super awakeFromNib];
    
    self.currentEmployeeTableViewCell = nil;
}

- (void)setScan:(Scan *)scn {
    if (scan) {
        [scan release];
        scan = nil;
    }
    scan = [scn retain];
    
	self.scanName.text = scan.scanSessionName;
	
	NSArray *visibleRows = [self.employeesTableView indexPathsForVisibleRows];
	for (NSIndexPath *indexPath in visibleRows) {
		EmployeeTableViewCell *cell = (EmployeeTableViewCell *)[self.employeesTableView cellForRowAtIndexPath:indexPath];
		cell.idTextField.delegate = nil;
		cell.delegate = nil;
	}
	
    [self.employeesTableView reloadData];
    
    if (scan) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:scan.employees.count inSection:0];
        [employeesTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:YES];
    }
}

- (void)addEmployee:(Employee *)emp    {
    [scan.employees addObject:emp];
    [employeesTableView reloadData];
	NSIndexPath *indexPath = [NSIndexPath indexPathForRow:scan.employees.count inSection:0];
	//[employeesTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [employeesTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:YES];
}

- (void)changeOrientationToLandscape:(BOOL)yesOrNo  {
    backgroundImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"mainPanel-%@-bg.png", yesOrNo ? @"L" : @"P"]];
}

- (void)setRfid:(NSString *)rfid {
    if (Shared.distance > 0)    {
        self.currentEmployeeTableViewCell.idTextField.text = rfid;
        [delegate scansViewDidSearchRfid:rfid];
    }   
	else    {
        self.currentEmployeeTableViewCell.idTextField.text = @"";
        [self.currentEmployeeTableViewCell stopActivity];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Information!" 
                                                            message:@"Please set distance to base location in settings first." 
                                                           delegate:nil 
                                                  cancelButtonTitle:@"OK" 
                                                  otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    }
}


- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:scan.employees.count inSection:0];
    EmployeeTableViewCell *c = (EmployeeTableViewCell *)[employeesTableView cellForRowAtIndexPath:indexPath];
    [c.idTextField becomeFirstResponder];
}

#pragma mark - UITableViewDelegate & Data Source

- (void)tableViewDidFinishLoading {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:scan.employees.count inSection:0];
    EmployeeTableViewCell *c = (EmployeeTableViewCell *)[employeesTableView cellForRowAtIndexPath:indexPath];
    [c.idTextField becomeFirstResponder];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section    {
    if (scan == nil) {
        return 0;
    }
    return scan.employees.count+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath  {
    static NSString *CellIdentifier = @"EmployeeTableViewCellIdentifier";
    
    EmployeeTableViewCell *cell;
	if (indexPath.row < scan.employees.count)
        cell = (EmployeeTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	else
		cell = (EmployeeTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"NewScanCellIdentifier"];
    if (cell == nil)	{
        cell = [[[[NSBundle mainBundle] loadNibNamed:@"EmployeeTableViewCell" owner:self options:nil] objectAtIndex:0] retain];
        cell.delegate = self;
    }
    if (indexPath.row < scan.employees.count)
        cell.employee = [scan.employees objectAtIndex:indexPath.row];
    return cell;        
}

#pragma mark - EmployeeTableViewCellDelegate

- (BOOL)scansViewDidSearchRfid:(NSString *)rfid dictionary:(NSDictionary **)dictionary	{
	
	NSMutableDictionary *dict = [NSMutableDictionary dictionary];
	[dict setValue:[NSNumber numberWithInt:self.scan.ID] forKey:@"scan_session_id"];
    
	Location *bLocation = [Shared instance].baseLocation;
    NSLog(@"baseLocation id: %i", bLocation.ID);
	
    if (bLocation.ID) {
        
        CLLocation *baseLocation = [[[CLLocation alloc] initWithLatitude:[bLocation.latitude floatValue]
															   longitude:[bLocation.longitude floatValue]] autorelease];
        float distance = [[LocationManager getInstance] distanceFromLocation:baseLocation] / 1000;
		int locID = 0;
		
        
        NSLog(@"Distance: %f, Shared Distance: %f", distance, Shared.distance);
        
        if (distance <= Shared.distance)	{
            locID = bLocation.ID;            
        }
        [dict setValue:[NSNumber numberWithInt:locID] forKey:@"location_id"];
        if (locID)	{
            NSArray *employees = self.scan.employees;
            if (employees.count)    {
                Employee *employee = [employees objectAtIndex:0];
				
                if (locID == employee.locationID)  
                {
					*dictionary	= dict;
					return YES;
                    //[self createCheckInRecordWithRFID:rfid usingLocationID:locID];
                }   
                else    
                {
					*dictionary	= dict;
                    [self.employeesTableView reloadData];
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Information!" 
                                                                        message:@"The scan session has been locked because base location is changed." 
                                                                       delegate:nil 
                                                              cancelButtonTitle:@"OK" 
                                                              otherButtonTitles:nil];
                    [alertView show];
                    [alertView release];
					return NO;
                }
            }   
            else    
            {
                *dictionary	= dict;
				return YES;
            }
        }	
        else	
        {
			*dictionary	= dict;
            [self.employeesTableView reloadData];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Information!" 
                                                                message:@"You are out of range relative to base location." 
                                                               delegate:nil 
                                                      cancelButtonTitle:@"OK" 
                                                      otherButtonTitles:nil];
            [alertView show];
            [alertView release];
			return NO;
            
        }
    }   
    else    
    {
		*dictionary	= dict;
        [self.employeesTableView reloadData];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Information!" 
                                                            message:@"Please add or select base location from settings." 
                                                           delegate:nil 
                                                  cancelButtonTitle:@"OK" 
                                                  otherButtonTitles:nil];
        [alertView show];
        [alertView release];
		return NO;
    }
    
    
}

- (BOOL)employeeTableViewCell:(EmployeeTableViewCell *)employeeTableViewCell didSearchRfid:(NSString *)rfid withDictionary:(NSDictionary **)dictionary {
    self.currentEmployeeTableViewCell = employeeTableViewCell;
	NSDictionary *dict;
    BOOL status = [self scansViewDidSearchRfid:rfid dictionary:&dict];
	*dictionary = dict;
	return status;
}


- (void)reloadScansData {
	[self.employeesTableView reloadData];
}



@end

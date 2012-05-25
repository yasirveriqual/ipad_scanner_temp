//
//  PDFView.m
//  iPadScanner
//
//  Created by Adeel Rehman on 11/11/11.
//  Copyright (c) 2011 VeriQual. All rights reserved.
//

#import "PDFView.h"
#import "EmployeeTableViewCell.h"


@implementation PDFView

@synthesize lblSessionName;
@synthesize tblScans;
@synthesize scan;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void) setScan:(Scan *)scanModel {
    if (scan) {
        [scan release];
        scan = nil;
    }
    scan = [scanModel retain];
    
    self.lblSessionName.text = [self.scan.scanSessionName uppercaseString];
    
    
    if (self.scan.employees.count > 19) {
        int extraRecords;
        int extraRecordsHeight;
        
        extraRecords = self.scan.employees.count - 19;
        extraRecordsHeight = extraRecords * 44;
        
        self.frame = CGRectMake(0, 0, 754, (self.frame.size.height+extraRecordsHeight));
        self.tblScans.frame = CGRectMake(self.tblScans.frame.origin.x, self.tblScans.frame.origin.y, self.tblScans.frame.size.width, (self.tblScans.frame.size.height+extraRecordsHeight));
    }
}

#pragma mark - UITableView Delegate & Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section    {
    return [self.scan.employees count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath  {
    static NSString *CellIdentifier = @"ScanTableViewCellIdentifier";
    
    EmployeeTableViewCell *cell = (EmployeeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)	{
        cell = [[[NSBundle mainBundle] loadNibNamed:@"EmployeeTableViewCell" owner:self options:nil] objectAtIndex:0];
    }
    
    cell.employee = [scan.employees objectAtIndex:indexPath.row];
    
    return cell;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

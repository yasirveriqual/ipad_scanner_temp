//
//  ScanTableViewCell.h
//  iPadScanner
//
//  Created by Yasir Ali on 10/24/11.
//  Copyright 2011 VeriQual. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ScanTableViewCellDelegate <NSObject>

- (void)editScanAtIndex:(int)_index;
- (void)scanLocationAtIndex:(int)_index;

@end

@interface ScanTableViewCell : UITableViewCell

@property (nonatomic, retain) NSTimer *showTimer;

@property (nonatomic, retain) IBOutlet UIView *cView;
@property (nonatomic, retain) IBOutlet UISegmentedControl *segmentedControl;
@property (nonatomic, retain) IBOutlet UILabel *textLabel;
@property (nonatomic, assign) id <ScanTableViewCellDelegate> delegate;
@property (readwrite) int cellIndex;


//- (IBAction)editBtnClicked:(id)sender;
//- (IBAction)locationBtnClicked:(id)sender;

- (IBAction)segmentedControlValueChanged;

- (void)showControls;


@end

//
//  MenuItemViewController.h
//  iPadScanner
//
//  Created by Adeel on 3/13/12.
//  Copyright (c) 2012 VeriQual. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MenuItemViewControllerDelegate <NSObject>
- (void)editScanAtIndex:(int)_index;
- (void)scanLocationAtIndex:(int)_index;
@end


@interface MenuItemViewController : UIViewController

@property (nonatomic, retain) IBOutlet UISegmentedControl *segmentedControl;
@property(nonatomic, retain) id<MenuItemViewControllerDelegate> delegate;
@property (readwrite) int index;

@end

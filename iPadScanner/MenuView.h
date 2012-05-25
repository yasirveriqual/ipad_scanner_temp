//
//  MenuView.h
//  iPadScanner
//
//  Created by Yasir Ali on 12/12/11.
//  Copyright (c) 2011 VeriQual. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuView : UIView

@property (nonatomic, retain) IBOutlet UIImageView *backgroundImageView;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIView *containerView;

- (IBAction)newScanClicked;
- (IBAction)registerClicked;
- (IBAction)locationClicked;
- (IBAction)reportsClicked;
- (IBAction)emailClicked;


@end

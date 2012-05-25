//
//  SettingSections.h
//  iPadScanner
//
//  Created by Yasir Ali on 11/28/11.
//  Copyright (c) 2011 VeriQual. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SettingSection : NSObject

@property (nonatomic, retain) NSString *ID;
@property (nonatomic, retain) NSString *name;

@property (nonatomic, retain) NSArray *items;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end

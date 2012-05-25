//
//  User.h
//  iPadScanner
//
//  Created by Adeel Rehman on 11/30/11.
//  Copyright (c) 2011 VeriQual. All rights reserved.
//

#import "Model.h"

typedef enum {
    UserGroupFiremarshal = 0,
    UserGroupAdministrator = 1,
    UserGroupUndefined = NSNotFound
}   UserGroup;

@interface User : Model

@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString *password;
@property (nonatomic, assign) UserGroup group;

@property (nonatomic, assign) BOOL isSelected;

- (void)setUserGroupWithName:(NSString *)groupName;

- (id)initWithEmail:(NSString *)email;

@end

//
//  DeviceManagement.h
//  iPadScanner
//
//  Created by Adeel on 2/21/12.
//  Copyright (c) 2012 VeriQual. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    DeviceTypeBluetooth = 0,
    DeviceTypeUSB = 1,
	DeviceTypeUnknown = NSUIntegerMax
} DeviceType;

@interface DeviceManager : NSObject 

//+ (DeviceManager *)getInstance;
+ (DeviceType)deviceType;
+ (void)setDeviceType:(DeviceType)type;
+ (DeviceManager *)currentDevice;
+ (void)loadDeviceType;

- (void)enable;
- (void)disable;

@end

//
//  DeviceManagement.m
//  iPadScanner
//
//  Created by Adeel on 2/21/12.
//  Copyright (c) 2012 VeriQual. All rights reserved.
//

#import "DeviceManager.h"
#import "BluetoothDeviceManager.h"
#import "USBDeviceManager.h"
#import "NullDeviceManager.h"

static DeviceManager *object;
static int devType;

@implementation DeviceManager

/*+ (DeviceManager *)getInstance {
    @synchronized(self) {
        if (object == nil)  {
            object = [[BluetoothDeviceManager alloc] init];
        }
    }
    return object;
}*/


+ (void)loadDeviceType {
	devType = DeviceTypeUnknown;
	NSString *selectedDeviceTypeString = [[NSUserDefaults standardUserDefaults] valueForKey:@"selectedDeviceType"];
	NSLog(@"P: %@", selectedDeviceTypeString);
    if (selectedDeviceTypeString != nil) {
		devType = [selectedDeviceTypeString integerValue];
	}
}


- (DeviceType)deviceType	{
	DeviceType type = DeviceTypeUnknown;
	NSString *selectedDeviceTypeString = [[NSUserDefaults standardUserDefaults] valueForKey:@"selectedDeviceType"];
    if (selectedDeviceTypeString != nil) return [selectedDeviceTypeString integerValue];
    return type;
}

+ (DeviceType)deviceType	{
	return object.deviceType;
}

+ (void)setDeviceType:(DeviceType)type {
	devType = type;
	
	[[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%i", type] forKey:@"selectedDeviceType"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (DeviceManager *)currentDevice {
	@synchronized(self) {
        if (object == nil)  {
			if (devType == DeviceTypeBluetooth) {
				object = [[BluetoothDeviceManager alloc] init];
			}
			else if (devType == DeviceTypeUSB) {
				object = [[USBDeviceManager alloc] init];
			}
			else if (devType == DeviceTypeUnknown) {
				//object = [[NullDeviceManager alloc] init];
				object = [[BluetoothDeviceManager alloc] init];
			}
        }
		else {
			[object release];
			object = nil;
			
			if (devType == DeviceTypeBluetooth) {
				if (object == nil) {
					object = [[BluetoothDeviceManager alloc] init];
				}
			}
			else  if (devType == DeviceTypeUSB) {
				if (object == nil) {
					object = [[USBDeviceManager alloc] init];
				}
			}
			else if (devType == DeviceTypeUnknown) {
				if (object == nil) {
					//object = [[NullDeviceManager alloc] init];
					object = [[BluetoothDeviceManager alloc] init];
				}
			}
		}
    }
    return object;
}


- (void)enable {
	
}


- (void)disable {
	
}

@end

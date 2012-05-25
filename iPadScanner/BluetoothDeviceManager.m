//
//  BluetoothDeviceManager.m
//  iPadScanner
//
//  Created by Adeel on 2/21/12.
//  Copyright (c) 2012 VeriQual. All rights reserved.
//

#import "BluetoothDeviceManager.h"
#import "Bluetooth.h"

@implementation BluetoothDeviceManager

- (void)enable {
	NSLog(@"***** Bluetooth Device Enable *****");
	[Bluetooth turnOn];
}

- (void)disable {
	NSLog(@"***** Bluetooth Device Disable *****");
	[Bluetooth turnOff];
}


@end

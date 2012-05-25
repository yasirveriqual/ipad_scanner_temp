//
//  Bluetooth.m
//  iPadScanner
//
//  Created by Yasir Ali on 10/25/11.
//  Copyright 2011 VeriQual. All rights reserved.
//

#import "Bluetooth.h"
#import "BluetoothManager.h"
//#import "<objc/runtime.h>"

static Bluetooth *object;
@implementation Bluetooth
@synthesize delegate;

+ (Bluetooth *)getInstance	{
	@synchronized (self)	{
		if (object == nil)	{
			object = [[Bluetooth alloc] init];
		}
	}
	return object;
}

+ (void)releaseInstance	{
//	[[Bluetooth getInstance] release];
}

- (id)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(bluetoothPowerChangedNotification:) 
                                                     name:@"BluetoothAvailabilityChangedNotification"
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(bluetoothPowerChangedNotification:) 
                                                     name:@"BluetoothPowerChangedNotification"
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(bluetoothPowerChangedNotification:) 
                                                     name:@"BluetoothConnectabilityChangedNotification"
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(bluetoothPowerChangedNotification:) 
                                                     name:@"BluetoothDeviceConnectSuccessNotification"
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(bluetoothPowerChangedNotification:) 
                                                     name:@"BluetoothConnectionStatusChangedNotification"
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(bluetoothPowerChangedNotification:) 
                                                     name:@"BluetoothDeviceDisconnectSuccessNotification"
                                                   object:nil];
        
//        [[NSNotificationCenter defaultCenter] addObserver:self
//                                                 selector:@selector(bluetoothPowerChangedNotification:) 
//                                                     name:@"BluetoothPowerChangedNotification"
//                                                   object:nil];
    }
    return self;
}

- (void) dealloc    {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

- (void)bluetoothPowerChangedNotification:(NSNotification *)notitifation    {
    NSLog(@"Notified Object: %@ of Class: %@ for notification: %@", notitifation.object, NSStringFromClass([notitifation.object class]), notitifation.name);
    if ([notitifation.object isKindOfClass:[BluetoothManager class]])   {
        BluetoothManager *manager = (BluetoothManager *)notitifation.object;
        if (manager.connected) {
            if ([delegate respondsToSelector:@selector(bluetoothDidTurnOn)]) {
                [delegate bluetoothDidTurnOn];
            }
        }
        else {
            if ([delegate respondsToSelector:@selector(bluetoothDidTurnOff)]) {
                [delegate bluetoothDidTurnOff];
            }
        }
    }
}

+ (BOOL)isTurnedOn {
    BluetoothManager *manager = [BluetoothManager sharedInstance];
    return manager.powered;
}


+ (void)turnOn  {
#if TARGET_IPHONE_SIMULATOR
    //This is where simulator code goes that use private frameworks
#else
    /* this works in iOS 4.2.1 */
    Class BluetoothManager = objc_getClass("BluetoothManager");
    id manager = [BluetoothManager sharedInstance];
    [manager setPowered:YES];
    [[Bluetooth getInstance].delegate bluetoothDidStartChanging];
#endif
}

+ (void)turnOff {
#if TARGET_IPHONE_SIMULATOR
    //This is where simulator code goes that use private frameworks
#else
    /* this works in iOS 4.2.1 */
    Class BluetoothManager = objc_getClass("BluetoothManager");
    id manager = [BluetoothManager sharedInstance];
	[manager setPowered:NO];
	[[Bluetooth getInstance].delegate bluetoothDidStartChanging];
#endif
}



@end

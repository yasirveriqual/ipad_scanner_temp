//
//  LoginViewController.m
//  iPadScanner
//
//  Created by Adeel Rehman on 10/27/11.
//  Copyright (c) 2011 VeriQual. All rights reserved.
//

#import "LoginViewController.h"
#import "iPadScannerAppDelegate.h"
#import "LocationViewController.h"
#import "ReportGenerationViewController.h"
#import "Connection.h"
#import "User.h"
#import "Constants.h"
#import "DeviceManager.h"
#import "Environment.h"


#import "NavigationController.h"

@interface LoginViewController (Private)
- (BOOL)checkFields;
- (BOOL)validateEmail:(NSString *)candidate;
- (void)showKeyboard:(BOOL)flag;
@end


@implementation LoginViewController
@synthesize menuTimer;
@synthesize loginView;
@synthesize contentView;
@synthesize innerView;
@synthesize txtUsername;
@synthesize txtPassword;
@synthesize btnLogin;
@synthesize menuButton;

@synthesize navController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - Private Methods

- (BOOL)checkFields {
    UIAlertView *av;
    if ([[self.txtUsername.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]<=0) {
        av = [[UIAlertView alloc] initWithTitle:@"Information" message:@"Enter Email" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[av show];
		[av release];
		return  NO;
    }
    else if (![self validateEmail:self.self.txtUsername.text]) {
        av = [[UIAlertView alloc] initWithTitle:@"Information" message:@"Email Address is not valid" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [av show];
        [av release];
        return NO;
    }
    else if ([[self.txtPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]<=0) {
        av = [[UIAlertView alloc] initWithTitle:@"Information" message:@"Enter Password" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[av show];
		[av release];
		return  NO;
    }
    else {
        return YES;
    }
}


- (BOOL)validateEmail:(NSString *)candidate {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"; 
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex]; 	
    return [emailTest evaluateWithObject:candidate];
}


- (void)showKeyboard:(BOOL)flag {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.25];
	CGRect f = self.innerView.frame;
    if (flag) {
        f.origin.y = -50;
    }
    else {
        f.origin.y = 29;
    }
	
	self.innerView.frame = f;
    [UIView commitAnimations];
}



- (void)showMenuView:(BOOL)yesOrNo  {
    [UIView  beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.25];
	CGRect loginViewFrame = self.loginView.frame;
	loginViewFrame.origin.x = yesOrNo ? 193 : 0;
	self.loginView.frame = loginViewFrame;
	[UIView commitAnimations];
    if (!yesOrNo)   {
        [self.menuTimer invalidate];
    }
}

- (void)hideMenu    {
    BOOL canHide = (self.loginView.frame.origin.x != 0);
    if (canHide)    {
        [self showMenuView:NO];
        [menuButton setImage:[UIImage imageNamed:@"btn_menu.png"] forState:UIControlStateNormal];
        [menuButton setImage:[UIImage imageNamed:@"btn_menu-hover.png"] forState:UIControlStateSelected];
        [menuButton setImage:[UIImage imageNamed:@"btn_menu-hover.png"] forState:UIControlStateHighlighted];
    }
    [self.menuTimer invalidate];
}

- (void)pushToViewController:(UIViewController *)viewController	{
	[self.navController pushViewController:viewController animated:YES];
}

- (void)navigateToViewController:(UIViewController *)viewController	{
	if (navController.viewControllers.count == 2)	{
		if ([navController.visibleViewController isKindOfClass:viewController.class]) 
			return;
		[self.navController popToRootViewControllerAnimated:NO];
		[self.navController pushViewController:viewController animated:YES];

	}	else	{
		[self.navController pushViewController:viewController animated:YES];
	}
}

#pragma mark - IBAction -

- (IBAction)menuClicked {
    [self.view endEditing:YES];
	BOOL show = (self.loginView.frame.origin.x == 0);
    NSString *imgSubName = @"";
    [self showMenuView:show];
	if (show)   {
        imgSubName = @"2";
        self.menuTimer = [NSTimer scheduledTimerWithTimeInterval:7 target:self selector:@selector(hideMenu) userInfo:nil repeats:NO];
    }
	[menuButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"btn_menu%@.png", imgSubName]] forState:UIControlStateNormal];
	[menuButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"btn_menu%@-hover.png", imgSubName]] forState:UIControlStateSelected];
	[menuButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"btn_menu%@-hover.png", imgSubName]] forState:UIControlStateHighlighted];
}

- (IBAction)locationClicked {
    [self.view endEditing:YES];
    LocationViewController *locationViewController = [[LocationViewController alloc] initWithNibName:@"LocationViewController" bundle:nil];
    [self navigateToViewController:locationViewController];
    [locationViewController release];
	[self menuClicked];
}

- (IBAction)newScanClicked	{
	NewScanViewController *viewController = [[NewScanViewController alloc] initWithNibName:@"NewScanViewController" bundle:nil];
	[viewController setValue:navController.mainViewController forKey:@"delegate"];
	[self navigateToViewController:viewController];
	[viewController release];
	[self menuClicked];
}


- (IBAction)registerClicked	{
    CardScannerViewController * viewController = [[[CardScannerViewController alloc] initWithNibName:@"CardScannerViewController" bundle:nil] autorelease];
	[self navigateToViewController:viewController];
	[self menuClicked];
}


- (IBAction)reportsClicked  {
    [self menuClicked];
    ReportGenerationViewController *viewController = [[[ReportGenerationViewController alloc] initWithNibName:@"ReportGenerationViewController" bundle:nil] autorelease];
    [self navigateToViewController:viewController];
}


- (IBAction)logoutClicked   {
    [self menuClicked];
    [self performSelector:@selector(logoutPressed)];
}


- (void)logoutPressed {
	
	[[self.navController.topViewController valueForKey:@"serviceManager"] cancel];
	menuButton.hidden = YES;
	[self.navController.view removeFromSuperview];
	self.navController = nil;
	self.navController.delegate = nil;
	
    [Session logout];
	
}



- (IBAction)loginPressed:(id)sender {
	[self.view endEditing:YES];
	
    if ([Shared isNetworkAvailable]) {
        if ([self checkFields]) {
            User *user = [[User alloc] init];
            user.email = self.txtUsername.text;
            user.password = self.txtPassword.text;
            [self.serviceManager requestApi:@"auth" usingObject:user requestMethod:@"POST"];
            [user release];
            
            self.btnLogin.enabled = NO;
        }
    }
    else {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Information" message:kNetworkError delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [av show];
        [av release];
    }
}

#pragma mark - UITextField Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    isKeyboardShown = YES;
    
    if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
        [self showKeyboard:YES];
    }
}


- (void)textFieldDidEndEditing:(UITextField *)textField {
    isKeyboardShown = NO;
    
    if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
        [self showKeyboard:NO];
    }
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return YES;
}


#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.txtUsername.text = @"kshah@ics-nett.com";
    self.txtPassword.text = @"Kshah123";

#if TARGET_IPHONE_SIMULATOR
	self.txtUsername.text = @"kshah@ics-nett.com";
    self.txtPassword.text = @"Kshah123";
#endif
	
	[self willRotateToInterfaceOrientation:self.interfaceOrientation duration:0.01];
	[[DeviceManager currentDevice] disable];
    [self performSelector:@selector(turnOff) withObject:nil afterDelay:1];
}

- (void)turnOff {
    [self.txtUsername becomeFirstResponder];
	[[DeviceManager currentDevice] disable];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutPressed) name:@"SessionLoggedOut" object:nil];
    isKeyboardShown = NO;
    self.title = @"Login";
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{

	return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration	{
	BOOL isLandscape;
	UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
	if (deviceOrientation == UIDeviceOrientationPortrait ||
		deviceOrientation == UIDeviceOrientationPortraitUpsideDown ||
		deviceOrientation == UIDeviceOrientationLandscapeLeft ||
		deviceOrientation == UIDeviceOrientationLandscapeRight)	{
		isLandscape = UIDeviceOrientationIsLandscape(deviceOrientation);
	}	else	{
		isLandscape = UIInterfaceOrientationIsLandscape(toInterfaceOrientation);		
	}
	
	if (isLandscape) {
        if (isKeyboardShown) {
            self.innerView.frame = CGRectMake(self.innerView.frame.origin.x, -50, self.innerView.frame.size.width, self.innerView.frame.size.height);
        }
        else {
            self.innerView.frame = CGRectMake(self.innerView.frame.origin.x, 29, self.innerView.frame.size.width, self.innerView.frame.size.height);
        }
    }
    else {
        self.innerView.frame = CGRectMake(self.innerView.frame.origin.x, 54, self.innerView.frame.size.width, self.innerView.frame.size.height);
    }
    
	[self.navController willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation	{
	[self.navController didRotateFromInterfaceOrientation:fromInterfaceOrientation];
}

- (void)logout	{
	[self.navController didLogout];
}

#pragma mark - UINavigationControllerDelegate 

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated	{
	if ([viewController isKindOfClass:MainViewController.class])	{
		[self willRotateToInterfaceOrientation:self.interfaceOrientation duration:0.01];
	}
}



#pragma mark - Service Manager Delegates

- (void)serviceManagerDidSuccessfullyRecievedResponse:(id)response forApi:(NSString *)api {
    self.btnLogin.enabled = YES;
    User *user = (User *) self.serviceManager.request.object;
    [user setUserGroupWithName:[[response valueForKey:@"user"] valueForKey:@"group"]];
    NSString *authenticationToken = [[response valueForKey:@"user"] valueForKey:@"auth_token"];
    
    if (authenticationToken != nil)	{
		[Session loginWithUser:user withAuthenticationToken:authenticationToken];
		
		NavigationController *navC = [[NavigationController alloc] initWithNibName:@"NavigationController" bundle:nil];
		self.navController = navC;
		self.navController.delegate = self;
		self.navController.view.frame = contentView.frame;
		
		
		[UIView transitionWithView:self.view
						  duration:0.5
						   options:UIViewAnimationOptionTransitionFlipFromTop
						animations:^    {
							[self.contentView addSubview:navC.view];
						}
						completion:NULL];
		
		
		
		
		[navC release];
		menuButton.hidden = NO;
		
		self.txtUsername.text = @"kshah@ics-nett.com";
		self.txtPassword.text = @"Kshah123";
	}	
	else {
		UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Invalid authentication token" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [av show];
        [av release];
	}
}

- (void)serviceManagerDidRecievedCode:(int)code withResponse:(NSDictionary *)response forApi:(NSString *)api {
    self.btnLogin.enabled = YES;
	[Session logout];
    
    UIAlertView *av;
    
    if (code == 403) {
        av = [[UIAlertView alloc] initWithTitle:@"Login Error" message:@"The email address or password you entered is incorrect." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [av show];
        [av release];
    }
	else if (code == 500) {
        av = [[UIAlertView alloc] initWithTitle:@"Unknown Error" message:@"Invalid response from server" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [av show];
        [av release];
    }
    else if (code == 999) {
        av = [[UIAlertView alloc] initWithTitle:@"Unknown Error" message:@"Invalid response from server" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [av show];
        [av release];
    }
}

- (void)serviceManagerDidFailedWithError:(NSError *)error forApi:(NSString *)api {
    self.btnLogin.enabled = YES;
           
    [Session logout];
    if (error) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error!" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [av show];
        [av release];
    }
}
@end

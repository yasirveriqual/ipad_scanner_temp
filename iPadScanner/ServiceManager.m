//
//  ServiceManager.m
//  iPadScanner
//
//  Created by Yasir Ali on 10/20/11.
//  Copyright 2011 VeriQual. All rights reserved.
//


#import "ServiceManager.h"
#import "Constants.h"
#import "Model.h"
#import "JSONKit.h"
#import "Environment.h"

@interface ServiceManager (Private)
- (NSString *)parametersFromDictionary:(NSDictionary *)dictionary forClassName:(NSString *)requestClass;
@end


@implementation ServiceManager
@synthesize delegate, request;

- (id)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)requestApi:(NSString *)apiName forClass:(NSString *)className usingObj:(id)object requestMethod:(NSString *)requestMethod   {
	if (Session.authenticationToken != nil)	{
		data = [[NSMutableData alloc] init];
		self.request = [HTTPRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@.json", Environment.serverURL, apiName]]];
		
		self.request.apiName = apiName;
		self.request.object = object;
		
		[request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
		request.timeoutInterval = 120;
		if (requestMethod == nil) {
			requestMethod = @"GET";
			NSString *parameters = [self parametersFromDictionary:object forClassName:className.lowercaseString];
			self.request.URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@.json%@", Environment.serverURL, apiName, parameters]];
			NSLog(@"URL: %@", self.request.URL.absoluteString);
		}   else    {
			NSDictionary *dictionary = [NSDictionary dictionaryWithObject:
										[NSDictionary dictionaryWithObjectsAndKeys:object, 
										 className.lowercaseString, 
										 Session.authenticationToken,
										 @"auth_token", nil] 
																   forKey:@"request"];
			NSLog(@"URL: %@\nRequest JSON: %@", [request.URL absoluteString], [dictionary JSONString]);
			NSMutableData *requestData = [[NSMutableData alloc] initWithData:[dictionary JSONData]];
			[request setValue:[NSString stringWithFormat:@"%d",requestData.length] forHTTPHeaderField:@"Content-Length"];
			
			request.HTTPBody = requestData;
		}
		request.HTTPMethod = requestMethod;
		connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	}	else	{
		[Session logout];
		UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error" message:@"You have been logged out from system." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [av show];
        [av release];
	}
}

- (void)requestApi:(NSString *)apiName usingObject:(Model *)object requestMethod:(NSString *)requestMethod  {
	if ([apiName isEqualToString:@"auth"] || Session.authenticationToken != nil)	{
		data = [[NSMutableData alloc] init];
		self.request = [HTTPRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@.json", Environment.serverURL, apiName]]];
		
		self.request.apiName = apiName;
		self.request.object = object;
		
		[request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
		request.timeoutInterval = 120;
		if (requestMethod == nil) {
			requestMethod = @"GET";
			NSString *parameters = [self parametersFromDictionary:[object dictionaryValue] forClassName:NSStringFromClass(object.class).lowercaseString];
			self.request.URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@.json%@", Environment.serverURL, apiName, parameters]];
			NSLog(@"URL: %@", self.request.URL.absoluteString);
		}   else    {
			NSDictionary *dictionary;
			if (![apiName isEqualToString:@"auth"])	{
				dictionary = [NSDictionary dictionaryWithObject:[NSDictionary dictionaryWithObjectsAndKeys:[object dictionaryValue], NSStringFromClass(object.class).lowercaseString, Session.authenticationToken, @"auth_token", nil] 
														 forKey:@"request"];
			}	else	{
				dictionary = [NSDictionary dictionaryWithObject:[NSDictionary dictionaryWithObject:[object dictionaryValue]
																							forKey:NSStringFromClass(object.class).lowercaseString] 
														 forKey:@"request"];
			}
			
			NSLog(@"URL: %@\nRequest JSON: %@", [request.URL absoluteString], [dictionary JSONString]);
			NSMutableData *requestData = [[NSMutableData alloc] initWithData:[dictionary JSONData]];
			[request setValue:[NSString stringWithFormat:@"%d",requestData.length] forHTTPHeaderField:@"Content-Length"];
			
			request.HTTPBody = requestData;
		}
		request.HTTPMethod = requestMethod;
		connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	}	
	else {
		[Session logout];
		
		UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error" message:@"You have been logged out from system." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [av show];
        [av release];
	}
}

- (void)cancel	{
	[connection cancel];
	[data release];
	data = nil;
	data = [[NSMutableData alloc] init];
}

- (void)finish	{
    if ([delegate respondsToSelector:@selector(serviceManagerDidSuccessfullyRecievedResponse:forApi:)])	{
		
        NSString *responseString = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
		
		NSLog(@"Request: %@", self.request.URL.absoluteString);
		NSLog(@"Request: %@", [[[NSString alloc] initWithData:self.request.HTTPBody encoding:NSASCIIStringEncoding] autorelease]);
		NSLog(@"Response: %@", responseString);
        NSDictionary *response = [[responseString objectFromJSONString] valueForKey:@"response"];
        NSUInteger code = [[response valueForKey:@"code"] integerValue];
        
        NSString *title = nil;
        
        switch (code) {
            case 200: 
                [delegate serviceManagerDidSuccessfullyRecievedResponse:response forApi:self.request.apiName];
                break;
            case 201:
                title = @"Created";
                [delegate serviceManagerDidRecievedCode:code withResponse:response forApi:self.request.apiName];
                break;
            case 401:
                title = @"Unauthorized";
                [delegate serviceManagerDidRecievedCode:code withResponse:response forApi:self.request.apiName];
                break;
            case 403:
			{
                title = @"Forbidden";
                [delegate serviceManagerDidRecievedCode:code withResponse:response forApi:self.request.apiName];
				[Session logout];
			}
                break;
            case 404:
                title = @"Not Found";
                [delegate serviceManagerDidRecievedCode:code withResponse:response forApi:self.request.apiName];
                break;
            case 500:
                title = @"Internal Server Error";
                [delegate serviceManagerDidRecievedCode:code withResponse:response forApi:self.request.apiName];
                break;
            case 501:
                title = @"Conflict";
                [delegate serviceManagerDidRecievedCode:code withResponse:response forApi:self.request.apiName];
                break;
            default:
                title = @"Unknown Error";
                code = 999;
                [delegate serviceManagerDidRecievedCode:code withResponse:response forApi:self.request.apiName];
                break;
        }
        [responseString release];
    }
	//[self cancel];
	[data release];
	data = nil;
	data = [[NSMutableData alloc] init];
}

- (void) dealloc	{
	[connection release];
	[data release];
	[super dealloc];
}

#pragma mark -
#pragma mark NSURLConnection delegate

- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response	{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	return self.request;
}

- (void)connection:(NSURLConnection *)c didReceiveResponse:(NSURLResponse *)response	{
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    statusCode = [httpResponse statusCode];
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	//	NSLog(@"connection didReceiveResponse with statusCode: %i", statusCode);
}

- (void)connection:(NSURLConnection *)c didReceiveData:(NSData *)d	{
    [data appendData:d];
	//	NSLog(@"connection didReceiveData");
}

- (void)connectionDidFinishLoading:(NSURLConnection *)c	{
    NSLog(@"connection didFinish");
	[self finish];
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)connection:(NSURLConnection *)c didFailWithError:(NSError *)e	{
	NSLog(@"connection didFailWithError");
	NSLog(@"Error: %@, \nURL: %@", e, self.request.URL.absoluteString);
	[delegate serviceManagerDidFailedWithError:e forApi:self.request.apiName];
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}


#pragma mark - ASI HTTP


- (NSString *)parametersFromDictionary:(NSDictionary *)dictionary forClassName:(NSString *)requestClass    {
    NSArray *keysForAllValues = [dictionary allKeys];
    NSString *parameters = @"?";
    for (NSString *key in keysForAllValues) {
        id obj = [dictionary objectForKey:key];
        if ([obj isKindOfClass:NSString.class])   {
            parameters = [NSString stringWithFormat:@"%@request[%@][%@]=%@&", parameters, requestClass, key, [obj stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        }   else if (![obj isKindOfClass:NSArray.class])  {
            parameters = [NSString stringWithFormat:@"%@request[%@][%@]=%@&", parameters, requestClass, key, [[obj stringValue] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        }   else   {
			for (id item in obj) {
                NSString *value = (NSString *)item;
                if (![item isKindOfClass:NSString.class])
                    value = [item stringValue];
                parameters = [NSString stringWithFormat:@"%@request[%@][%@][]=%@&", parameters, requestClass, key, [value stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            }
        }
    }
	parameters = [NSString stringWithFormat:@"%@request[auth_token]=%@", parameters, Session.authenticationToken];
	
	return [[parameters stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
}

- (void)requestApi:(NSString *)apiName usingObject:(Model *)object  {
    [self requestApi:apiName usingObject:object requestMethod:nil];
}

- (void)requestApi:(NSString *)apiName forClass:(NSString *)className usingObj:(id)object	{
	[self requestApi:apiName forClass:className usingObj:object requestMethod:nil];
}

+ (ServiceManager *)managerWithDelegate:(id)delegate   {
    ServiceManager *sm = [[[self alloc] init] autorelease];
    sm.delegate = delegate;
    return sm;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 0) {
		[[NSNotificationCenter defaultCenter] postNotificationName:@"SessionLoggedOut" object:nil];
	}
}

@end

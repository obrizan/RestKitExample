//
//  AppDelegate.m
//  RestKitExample
//
//  Created by Volodymyr Obrizan on 04.07.12.
//  Copyright (c) 2012 Design and Test Lab. All rights reserved.
//

#import "AppDelegate.h"

#import "MasterViewController.h"

#import <RestKit/RestKit.h>

@implementation AppDelegate

@synthesize window = _window;
@synthesize navigationController = _navigationController;

- (void)dealloc
{
	[_window release];
	[_navigationController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	// Настройка логирования действий Ресткита
    RKLogConfigureByName("RestKit/Network*", RKLogLevelTrace);
    RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelTrace);

	// Инициализация Ресткита
	RKObjectManager* objectManager = [RKObjectManager managerWithBaseURLString:@"http://search.twitter.com"];

	// Показывать индикатор активности сети на статус-баре
    objectManager.client.requestQueue.showsNetworkActivityIndicatorWhenBusy = YES;
	
	// Настраиваем структуру объектов
	RKObjectMapping *tweetMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
	[tweetMapping mapAttributes:@"from_user", @"profile_image_url", @"text", nil];
	
	RKObjectMapping* searchResultMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
	[searchResultMapping hasMany:@"results" withMapping:tweetMapping];
	
	// Register our mappings with the provider using a resource path pattern
    [objectManager.mappingProvider setObjectMapping:searchResultMapping forResourcePathPattern:@"/search.json"];

    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.

	MasterViewController *masterViewController = [[[MasterViewController alloc] initWithNibName:@"MasterViewController" bundle:nil] autorelease];
	self.navigationController = [[[UINavigationController alloc] initWithRootViewController:masterViewController] autorelease];
	self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
	/*
	 Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	 Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
	 */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	/*
	 Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
	 If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	 */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	/*
	 Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
	 */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	/*
	 Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	 */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	/*
	 Called when the application is about to terminate.
	 Save data if appropriate.
	 See also applicationDidEnterBackground:.
	 */
}

@end

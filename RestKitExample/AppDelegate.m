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

@synthesize window					= _window;
@synthesize navigationController	= _navigationController;


////////////////////////////////////////////////////////////////////////////////


- (void)dealloc
{
	[_window release];
	[_navigationController release];
    [super dealloc];
}


////////////////////////////////////////////////////////////////////////////////


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	// Настройка логирования действий Ресткита
    // RKLogConfigureByName("RestKit/Network*", RKLogLevelTrace);
    // RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelTrace);

	// Инициализация Ресткита, указываем базовый адрес веб-сервиса
	RKObjectManager* objectManager = [RKObjectManager managerWithBaseURLString:@"http://search.twitter.com"];

	// Показывать индикатор активности сети на статус-баре
    objectManager.client.requestQueue.showsNetworkActivityIndicatorWhenBusy = YES;
	
	// Настраиваем структуру объектов
	// Первый объект: твит. Нам интересны только свойства: имя пользователя, аватарка, текст
	RKObjectMapping *tweetMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
	[tweetMapping mapAttributes:@"from_user", @"profile_image_url", @"text", nil];
	
	// Второй объект: результат поискового запроса (включает в себя список твитов и служебную информацию)
	// Нас интересует только поле "results"
	// См.: https://dev.twitter.com/docs/api/1/get/search
	RKObjectMapping* searchResultMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
	[searchResultMapping hasMany:@"results" withMapping:tweetMapping];
	
	// Register our mappings with the provider using a resource path pattern
	// Связываем шаблон URL-запроса со структурой ответа. Теперь Ресткит будет знать, 
	// как парсить ответ от запроса с таким шаблоном URL
    [objectManager.mappingProvider setObjectMapping:searchResultMapping forResourcePathPattern:@"/search.json"];

	// Дальше идет стандартный код создания окна
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];

	MasterViewController *masterViewController = [[[MasterViewController alloc] initWithNibName:@"MasterViewController" bundle:nil] autorelease];
	self.navigationController = [[[UINavigationController alloc] initWithRootViewController:masterViewController] autorelease];
	self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    return YES;
}


////////////////////////////////////////////////////////////////////////////////

@end

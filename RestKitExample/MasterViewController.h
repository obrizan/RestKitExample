//
//  MasterViewController.h
//  RestKitExample
//
//  Created by Volodymyr Obrizan on 04.07.12.
//  Copyright (c) 2012 Design and Test Lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>

@class DetailViewController;

@interface MasterViewController : UITableViewController<RKObjectLoaderDelegate>

@property (strong, nonatomic) DetailViewController *detailViewController;

@end

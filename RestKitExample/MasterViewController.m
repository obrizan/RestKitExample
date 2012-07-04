//
//  MasterViewController.m
//  RestKitExample
//
//  Created by Volodymyr Obrizan on 04.07.12.
//  Copyright (c) 2012 Design and Test Lab. All rights reserved.
//

#import "MasterViewController.h"

#import "DetailViewController.h"

#import <RestKit/RestKit.h>

@implementation MasterViewController

@synthesize detailViewController	= _detailViewController;
@synthesize tweets					= _tweets;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		self.title = NSLocalizedString(@"Master", @"Master");

		// При создания контроллера список твитов пуст
		self.tweets = NSArray.array;
    }
    return self;
}
							
- (void)dealloc
{
	[_detailViewController release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}


////////////////////////////////////////////////////////////////////////////////


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	
	// Создаем словарь с параметрами: ?q=#habr
	NSDictionary *queryParams = [NSDictionary dictionaryWithObject:@"#habr" forKey:@"q"];
	
	// Формируем адрес к вебсервису и выполняем асинхронный GET-запрос. 
	// RestKit вызовет методы делегата у текущего класса в случае успешного или неуспешного результата
    NSString *resourcePath = [@"/search.json" stringByAppendingQueryParameters:queryParams];
	[RKObjectManager.sharedManager loadObjectsAtResourcePath:resourcePath delegate:self];
}


////////////////////////////////////////////////////////////////////////////////


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}


////////////////////////////////////////////////////////////////////////////////


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.tweets.count;
}


////////////////////////////////////////////////////////////////////////////////


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

	// Configure the cell.
	cell.textLabel.text = [[self.tweets objectAtIndex:indexPath.row] objectForKey:@"text"];
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.detailViewController) {
        self.detailViewController = [[[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil] autorelease];
    }
    [self.navigationController pushViewController:self.detailViewController animated:YES];
}


////////////////////////////////////////////////////////////////////////////////


#pragma mark - Object Loader Delegate

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{
    NSArray *errorMessages = [[error userInfo] objectForKey:RKObjectMapperErrorObjectsKey];
}


////////////////////////////////////////////////////////////////////////////////


- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects
{
	NSDictionary *searchResults = [objects objectAtIndex:0];
	self.tweets = [searchResults objectForKey:@"results"];
	[self.tableView reloadData];
}


////////////////////////////////////////////////////////////////////////////////

@end

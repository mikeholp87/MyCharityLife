//
//  ViewController.m
//  MyCharityLife
//
//  Created by Michael Holp on 6/26/13.
//  Copyright (c) 2013 MyCharityLife. All rights reserved.
//

#import "CharityList.h"

#define kSelectedTabColor [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.000]
#define kNormalTabColor [UIColor colorWithRed:213/255.0 green:213/255.0 blue:213/255.0 alpha:1.000]

#define kNavTintColor [UIColor colorWithRed:183/255.0 green:183/255.0 blue:183/255.0 alpha:1.000]

@implementation CharityList
@synthesize charities, charityTable, settings, charity_favorites, charity_indexes, charity_ids;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIView *logoView = [[UIView alloc] initWithFrame:CGRectMake(75, 0, 180, 22)];
    UIButton *logo = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 180, 22)];
    [logo setImage:[UIImage imageNamed:@"mcl_logo.png"] forState:UIControlStateNormal];
    [logo addTarget:self action:@selector(backToStart) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:logoView];
    [logoView addSubview:logo];
    self.navigationItem.titleView = logoView;
    
    self.navigationController.navigationBar.tintColor = kNavTintColor;
}

- (void)viewWillAppear:(BOOL)animated
{
    [charityTable deselectRowAtIndexPath:[charityTable indexPathForSelectedRow] animated:animated];
    
    settings = [[NSUserDefaults alloc] init];
    charity_indexes = [[settings objectForKey:@"charity_indexes"] mutableCopy];
    charity_ids = [[settings objectForKey:@"charity_ids"] mutableCopy];
    charity_favorites = [[settings objectForKey:@"charity_favorites"] mutableCopy];
    
    [charityTable reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return NSLocalizedString(@"Charities", @"Charities");
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[charity_favorites allKeys] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.font = [UIFont boldSystemFontOfSize:14.0];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    cell.textLabel.text = [[[charity_favorites allValues] objectAtIndex:indexPath.row] objectAtIndex:1];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row % 2 == 0)
        cell.backgroundColor = kSelectedTabColor;
    else
        cell.backgroundColor = kNormalTabColor;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 48.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CharityDesc *charityDesc = [self.storyboard instantiateViewControllerWithIdentifier:@"Description"];
    charityDesc.title = [charityTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]].textLabel.text;
    charityDesc.charity_id = [[[charity_favorites allValues] objectAtIndex:indexPath.row] objectAtIndex:0];
    [self.navigationController pushViewController:charityDesc animated:YES];
}

- (void)backToStart
{
    UINavigationController *main = [self.storyboard instantiateViewControllerWithIdentifier:@"MainNavigation"];
    [self presentViewController:main animated:YES completion:nil];
}

- (IBAction)addCharities:(id)sender
{
    UIViewController *watchlist = [self.storyboard instantiateViewControllerWithIdentifier:@"Watchlist"];
    watchlist.navigationItem.rightBarButtonItem = nil;
    [self.navigationController pushViewController:watchlist animated:YES];
}

@end

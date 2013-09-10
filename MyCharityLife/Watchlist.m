//
//  Watchlist.m
//  MyCharityLife
//
//  Created by Michael Holp on 7/18/13.
//  Copyright (c) 2013 MyCharityLife. All rights reserved.
//

#import "Watchlist.h"

#define kSelectedTabColor [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.000]
#define kNormalTabColor [UIColor colorWithRed:213/255.0 green:213/255.0 blue:213/255.0 alpha:1.000]

#define kNavTintColor [UIColor colorWithRed:183/255.0 green:183/255.0 blue:183/255.0 alpha:1.000]

@implementation Watchlist
@synthesize charities, watchlistTable, searchBar, searchResults, searchDisplayController, charity_indexes, charity_favorites, charity_ids, settings, locationManager, userCoordinate, geocoder;

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
    
    searchBar.delegate = self;
    searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    searchDisplayController.delegate = self;
    searchDisplayController.searchResultsDataSource = self;
    searchDisplayController.searchResultsDelegate = self;
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    [locationManager startUpdatingLocation];
    
    userCoordinate = locationManager.location.coordinate;
	
    settings = [[NSUserDefaults alloc] init];
    charities = [[NSMutableDictionary alloc] init];
    
    charity_favorites = [[settings objectForKey:@"charity_favorites"] mutableCopy];
    
    NSString *plist = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"charities.plist"];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:plist];
    
    /*
    if(fileExists){
        charities = [[NSMutableDictionary alloc] initWithContentsOfFile:[self saveFilePath:@"charities"]];
        [watchlistTable reloadData];
    }else{
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://www.demo.mycharitylife.com/MCL_App/mcl_api.php"]];
        [request setPostValue:[NSString stringWithFormat:@"%f, %f", userCoordinate.latitude, userCoordinate.longitude] forKey:@"location"];
        [request setPostValue:@"fetch_charities" forKey:@"cmd"];
        [request setDelegate:self];
        [request startAsynchronous];
    }
    */
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://www.demo.mycharitylife.com/MCL_App/mcl_api.php"]];
    [request setPostValue:@"fetch_charities" forKey:@"cmd"];
    [request setDelegate:self];
    [request startAsynchronous];
}

/*
- (void)fetchReverseGeocodeAddress:(float)pdblLatitude withLongitude:(float)pdblLongitude withCompletionHanlder:(ReverseGeoCompletionBlock)completion {
    
    geocoder = [[CLGeocoder alloc] init];
    CLGeocodeCompletionHandler completionHandler = ^(NSArray *placemarks, NSError *error) {
        if (error) {
            NSLog(@"Geocode failed with error: %@", error);
            return;
        }
        if (placemarks) {
            [placemarks enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                CLPlacemark *placemark = placemarks[0];
                NSDictionary *info = placemark.addressDictionary;
                NSString *zipcode = [info objectForKey:@"ZIP"];
                if (completion) {
                    completion(zipcode);
                }
                *stop = YES;
            }];
        }
    };
    
    CLLocation *newLocation = [[CLLocation alloc]initWithLatitude:pdblLatitude longitude:pdblLongitude];
    [geocoder reverseGeocodeLocation:newLocation completionHandler:completionHandler];
}
*/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == self.searchDisplayController.searchResultsTableView)
        return [searchResults count];
    else
        return [[charities objectForKey:@"post_title"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CharityCell";
    CharityCell *cell = (CharityCell *)[watchlistTable dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil){
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"CharityCell" owner:self options:nil];
        for (id currentObject in topLevelObjects) {
            if ([currentObject isKindOfClass:[UITableViewCell class]]) {
                cell = (CharityCell *)currentObject;
                break;
            }
        }
    }
    
    cell.charityLbl.font = [UIFont boldSystemFontOfSize:12.0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell.followBtn addTarget:self action:@selector(followCharity:) forControlEvents:UIControlEventTouchUpInside];
    [cell.followBtn setTag:indexPath.row];
    /*
    CLLocation *locA = [[CLLocation alloc] initWithLatitude:[[[charities objectForKey:@"charity_lat"] objectAtIndex:indexPath.row] floatValue] longitude:[[[charities objectForKey:@"charity_lat"] objectAtIndex:indexPath.row] floatValue]];
    CLLocation *locB = [[CLLocation alloc] initWithLatitude:userCoordinate.latitude longitude:userCoordinate.longitude];
    CLLocationDistance distance = [locA distanceFromLocation:locB];
    
    if(distance <= 50){
        if(tableView == self.searchDisplayController.searchResultsTableView) {
            cell.charityLbl.text = [searchResults objectAtIndex:indexPath.row];
        }else{
            if([charity_favorites objectForKey:[NSString stringWithFormat:@"%d", indexPath.row]])
                [cell.followBtn setImage:[UIImage imageNamed:@"follow_check.png"] forState:UIControlStateNormal];
            
            cell.charityLbl.text = [[[charities objectForKey:@"post_title"] objectAtIndex:indexPath.row] objectAtIndex:1];
        }
    }
    */
    
    if([charity_favorites objectForKey:[NSString stringWithFormat:@"%d", indexPath.row]])
        [cell.followBtn setImage:[UIImage imageNamed:@"follow_check.png"] forState:UIControlStateNormal];
    
    cell.charityLbl.text = [[[charities objectForKey:@"post_title"] objectAtIndex:indexPath.row] objectAtIndex:1];
    
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
    
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    [searchResults removeAllObjects];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.name contains[c] %@",searchText];
    searchResults = [NSMutableArray arrayWithArray:[[[charities objectForKey:@"post_title"] objectAtIndex:1] filteredArrayUsingPredicate:predicate]];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString scope:[[searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    self.searchBar.hidden = YES;
}

- (void)followCharity:(UIButton *)sender
{
    if(charity_favorites == nil) charity_favorites = [[NSMutableDictionary alloc] init];
    
    CharityCell *cell = (CharityCell *)[watchlistTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:0]];
    
    if([[cell.followBtn imageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"follow_plus.png"]]){
        [cell.followBtn setImage:[UIImage imageNamed:@"follow_check.png"] forState:UIControlStateNormal];
        
        NSString *charity_id = [[[charities objectForKey:@"post_title"] objectAtIndex:sender.tag] objectAtIndex:0];
        NSString *charity_title = [[[charities objectForKey:@"post_title"] objectAtIndex:sender.tag] objectAtIndex:1];
        
        [charity_favorites setObject:[NSArray arrayWithObjects:charity_id, charity_title, nil] forKey:[NSString stringWithFormat:@"%d",sender.tag]];
    }else{
        [cell.followBtn setImage:[UIImage imageNamed:@"follow_plus.png"] forState:UIControlStateNormal];
        [charity_favorites removeObjectForKey:[NSString stringWithFormat:@"%d",sender.tag]];
    }
    
    NSLog(@"%@", charity_favorites);
    
    [settings setObject:charity_indexes forKey:@"charity_indexes"];
    [settings setObject:charity_ids forKey:@"charity_ids"];
    [settings setObject:charity_favorites forKey:@"charity_favorites"];
    [settings synchronize];
}

- (void)backToStart
{
    UINavigationController *main = [self.storyboard instantiateViewControllerWithIdentifier:@"MainNavigation"];
    [self presentViewController:main animated:YES completion:nil];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSString *jsonString = [request responseString];
    NSLog(@"Refresh Response String is: %@", jsonString);
    
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    [charities setDictionary:[parser objectWithString:jsonString error:NULL]];
    [charities writeToFile:[self saveFilePath:@"charities"] atomically:YES];
    
    NSLog(@"%@", charities);
    
    [watchlistTable performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Fetch Error" message:[error localizedDescription] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

-(NSString *)saveFilePath:(NSString *)pathName{
    NSArray *path =
    NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSLog(@"%@", path);
    return [[path objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",pathName]];
}

@end

//
//  Settings.m
//  MyCharityLife
//
//  Created by Michael Holp on 6/29/13.
//  Copyright (c) 2013 MyCharityLife. All rights reserved.
//

#import "Settings.h"

@implementation Settings
@synthesize twitterInfo, facebookInfo, emailInfo, settings, picture, nameField, passwdField, emailField, segControl;

//Constants for view manipulation during keyboard usage
static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3f;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2f;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8f;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIView *logoView = [[UIView alloc] initWithFrame:CGRectMake(75, 0, 160, 20)];
    UIButton *logo = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 160, 20)];
    [logo setImage:[UIImage imageNamed:@"mcl_logo.png"] forState:UIControlStateNormal];
    [logo addTarget:self action:@selector(backToStart) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:logoView];
    [logoView addSubview:logo];
    self.navigationItem.titleView = logoView;
    
    self.clearsSelectionOnViewWillAppear = YES;
    
    settings = [[NSUserDefaults alloc] init];
    
    if([settings boolForKey:@"login_twitter"])
        twitterInfo = [settings objectForKey:@"twitter_info"];
    else if([settings boolForKey:@"login_facebook"])
        facebookInfo = [settings objectForKey:@"facebook_info"];
    else
        emailInfo = [settings objectForKey:@"email_info"];
    
    NSLog(@"%@", facebookInfo);
    NSLog(@"%@", twitterInfo);
    
    UIBarButtonItem *logout = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStyleDone target:self action:@selector(logout)];
    [self.navigationItem setRightBarButtonItem:logout];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
        return 5;
    else if(section == 1)
        return 1;
    else if(section == 2)
        return 2;
    else
        return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:
                CellIdentifier];
    }
    
    [cell.textLabel setFont:[UIFont boldSystemFontOfSize:12]];
    
    if(indexPath.section == 0) {
        if(indexPath.row == 0){
            cell.textLabel.text = @"Name";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
            
            nameField = [[UITextField alloc] initWithFrame:CGRectMake(110, 10, 185, 30)];
            nameField.adjustsFontSizeToFitWidth = YES;
            nameField.textColor = [UIColor blackColor];
            
            if([settings boolForKey:@"login_twitter"])
                nameField.text = [twitterInfo objectForKey:@"name"];
            else if([settings boolForKey:@"login_facebook"])
                nameField.text = [[settings objectForKey:@"fb_user"] objectForKey:@"name"];
            else
                nameField.text = [emailInfo objectForKey:@"name"];
            nameField.keyboardType = UIKeyboardTypeDefault;
            nameField.font = [UIFont systemFontOfSize:16];
            nameField.returnKeyType = UIReturnKeyDone;
            nameField.backgroundColor = [UIColor whiteColor];
            nameField.textAlignment = UITextAlignmentLeft;
            nameField.tag = 0;
            nameField.delegate = self;
            nameField.clearButtonMode = UITextFieldViewModeNever;
            [nameField setEnabled:YES];
            [cell.contentView addSubview:nameField];
        }
        else if(indexPath.row == 1){
            cell.textLabel.text = @"Email";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
            
            emailField = [[UITextField alloc] initWithFrame:CGRectMake(110, 10, 185, 30)];
            emailField.adjustsFontSizeToFitWidth = YES;
            emailField.textColor = [UIColor blackColor];
            
            if([settings boolForKey:@"login_twitter"])
                emailField.text = [twitterInfo objectForKey:@"email"];
            else if([settings boolForKey:@"login_facebook"])
                emailField.text = [[settings objectForKey:@"fb_user"] objectForKey:@"email"];
            else
                emailField.text = [emailInfo objectForKey:@"email"];
            emailField.keyboardType = UIKeyboardTypeEmailAddress;
            emailField.font = [UIFont systemFontOfSize:16];
            emailField.returnKeyType = UIReturnKeyDone;
            emailField.backgroundColor = [UIColor whiteColor];
            emailField.textAlignment = UITextAlignmentLeft;
            emailField.tag = 1;
            emailField.delegate = self;
            emailField.clearButtonMode = UITextFieldViewModeNever;
            [emailField setEnabled:YES];
            [cell.contentView addSubview:emailField];
        }
        else if(indexPath.row == 2){
            cell.textLabel.text = @"Password";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
            
            passwdField = [[UITextField alloc] initWithFrame:CGRectMake(110, 10, 185, 30)];
            passwdField.adjustsFontSizeToFitWidth = YES;
            passwdField.textColor = [UIColor blackColor];
            
            if([settings boolForKey:@"login_twitter"])
                passwdField.text = @"dfsfdsfsdfd";
            else if([settings boolForKey:@"login_facebook"])
                passwdField.text = @"dfsfdsfsdfd";
            else
                passwdField.text = @"dfsfdsfsdfd";
            passwdField.keyboardType = UIKeyboardTypeDefault;
            passwdField.font = [UIFont systemFontOfSize:16];
            passwdField.secureTextEntry = TRUE;
            passwdField.returnKeyType = UIReturnKeyDone;
            passwdField.backgroundColor = [UIColor whiteColor];
            passwdField.textAlignment = UITextAlignmentLeft;
            passwdField.tag = 2;
            passwdField.delegate = self;
            passwdField.clearButtonMode = UITextFieldViewModeNever;
            [passwdField setEnabled:YES];
            [cell.contentView addSubview:passwdField];
        }
        else if(indexPath.row == 3){
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = @"Profile Photo";
        }else{
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = @"Bio";
        }
    }
    
    else if(indexPath.section == 1){
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = @"Push & Email";
    }
    
    else if(indexPath.section == 2){
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if(indexPath.row == 0)
            cell.textLabel.text = @"Send us feedback";
        else
            cell.textLabel.text = @"Terms and Service";
    }
    
    else if(indexPath.section == 3)
        cell.textLabel.text = @"Logout";
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        if(indexPath.row == 3){
            [self useCamera];
        }
        else if(indexPath.row == 4){
            
        }
    }
    else if(indexPath.section == 1){
        
    }
    else if(indexPath.section == 2){
        if(indexPath.row == 0){
            NSString *message = [NSString stringWithFormat:@""];
            
            if ([MFMailComposeViewController canSendMail]) {
                MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
                controller.mailComposeDelegate = self;
                
                [controller setToRecipients:[NSArray arrayWithObject:@"ryan@mycharitylife.com"]];
                [controller setSubject:@"MyCharityLife Feedback"];
                [controller setMessageBody:message isHTML:YES];
                [self presentViewController:controller animated:YES completion:nil];
            }else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unable to Send" message:@"Device was unable to deliver your email at this time." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
        }else{
            UIViewController *terms = [self.storyboard instantiateViewControllerWithIdentifier:@"Agreement"];
            [self.navigationController pushViewController:terms animated:YES];
        }
    }
    else if(indexPath.section == 3)
        [self logout];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error;
{
    if(result != MessageComposeResultSent){
        NSLog(@"Result: failed");
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        NSLog(@"Result: sent");
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (UIToolbar *)keyboardToolBar {
    
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    [toolbar setBarStyle:UIBarStyleDefault];
    [toolbar sizeToFit];
    
    segControl = [[UISegmentedControl alloc] initWithItems:@[@"Previous", @"Next"]];
    [segControl setSegmentedControlStyle:UISegmentedControlStyleBar];
    segControl.momentary = YES;
    
    UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissKeyboard)];
    
    [segControl addTarget:self action:@selector(nextPrevious) forControlEvents:(UIControlEventValueChanged)];
    [segControl setEnabled:NO forSegmentAtIndex:0];
    
    UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithCustomView:segControl];
    
    NSArray *itemsArray = @[nextButton, flexibleItem, done];
    
    [toolbar setItems:itemsArray];
    
    return toolbar;
}

- (void)nextPrevious
{
    switch([segControl selectedSegmentIndex]) {
        case 0:{
            if(emailField.isEditing) [nameField becomeFirstResponder];
            else if(passwdField.isEditing) [emailField becomeFirstResponder];
        }
            break;
        case 1:{
            if(nameField.isEditing) [emailField becomeFirstResponder];
            else if(emailField.isEditing) [passwdField becomeFirstResponder];
        }
            break;
    }
}

#pragma mark UItextField Handling
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect textFieldRect  = [self.view.window convertRect:textField.bounds fromView:textField];
    CGRect viewRect = [self.view.window convertRect:self.view.bounds fromView:self.view];
    CGFloat midline = textFieldRect.origin.y + 0.5f * textFieldRect.size.height;
    CGFloat numerator = midline - viewRect.origin.y - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator = (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION) * viewRect.size.height;
    CGFloat heightFraction = numerator / denominator;
    if (heightFraction < 0.0)
    {
        heightFraction = 0.0f;
    }
    else if (heightFraction > 1.0)
    {
        heightFraction = 1.0f;
    }
    UIInterfaceOrientation orientation =[[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        animatedDistance = floorf(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
    }
    else
    {
        animatedDistance = floorf(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
    }
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= animatedDistance;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    [self.view setFrame:viewFrame];
    [UIView commitAnimations];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    textField.inputAccessoryView = [self keyboardToolBar];
    if (textField == nameField){
        [segControl setEnabled:NO forSegmentAtIndex:0];
        [segControl setEnabled:YES forSegmentAtIndex:1];
    }else if (textField == emailField){
        [segControl setEnabled:YES forSegmentAtIndex:0];
        [segControl setEnabled:YES forSegmentAtIndex:1];
    }else{
        [segControl setEnabled:YES forSegmentAtIndex:0];
        [segControl setEnabled:NO forSegmentAtIndex:1];
    }
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    [self.view setFrame:viewFrame];
    [UIView commitAnimations];
}

-(void)useCamera
{
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.mediaTypes = [NSArray arrayWithObjects:(NSString *)kUTTypeImage, nil];
        if([UIImagePickerController isCameraDeviceAvailable: UIImagePickerControllerCameraDeviceFront])
            imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        
        imagePicker.allowsEditing = NO;
        [self presentViewController:imagePicker animated:YES completion:nil];
        newMedia = YES;
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        picture = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        if(newMedia){
            UIImageWriteToSavedPhotosAlbum(picture, self, @selector(image:finishedSavingWithError:contextInfo:), nil);
            
            UIImage *image = [self normalizedImage:picture];
            [self saveImage:image withImageName:[NSString stringWithFormat:@"userPhoto_%f.png",[[NSDate date] timeIntervalSince1970]]];
        }
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)image:(UIImage *)image finishedSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Save failed" message:@"Failed to save image" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissModalViewControllerAnimated:YES];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)saveImage:(UIImage*)image withImageName:(NSString*)imageName
{
    NSData *imageData = UIImagePNGRepresentation(image);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", imageName]];
    
    [settings setObject:fullPath forKey:@"user_photo"];
    [settings synchronize];
    
    [fileManager createFileAtPath:fullPath contents:imageData attributes:nil];
    NSLog(@"image saved");
}

- (UIImage *)normalizedImage:(UIImage *)image {
    if (image.imageOrientation == UIImageOrientationUp) return image;
    
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    [image drawInRect:(CGRect){0, 0, image.size}];
    UIImage *normalizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return normalizedImage;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
}

- (void)dismissKeyboard
{
    [nameField resignFirstResponder];
    [passwdField resignFirstResponder];
    [emailField resignFirstResponder];
    /*
    if([settings boolForKey:@"login_twitter"]){
        [[settings objectForKey:@"twitter_info"] setObject:nameField.text forKey:@"name"];
        [[settings objectForKey:@"twitter_info"] setObject:emailField.text forKey:@"email"];
        [settings synchronize];
    }else if([settings boolForKey:@"login_facebook"]){
        [settings setObject:nameField.text forKey:[[settings objectForKey:@"fb_user"] objectForKey:@"name"]];
        [settings setObject:emailField.text forKey:[[settings objectForKey:@"fb_user"] objectForKey:@"email"]];
        [settings synchronize];
    }else{
        [emailInfo setObject:nameField.text forKey:@"name"];
        [emailInfo setObject:emailField.text forKey:@"email"];
    }
    */
}

- (void)logout
{
    if([settings objectForKey:@"login_facebook"])
        [[FBSession activeSession] closeAndClearTokenInformation];
    
    UINavigationController *login = [self.storyboard instantiateViewControllerWithIdentifier:@"MainNavigation"];
    [self presentViewController:login animated:YES completion:nil];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self dismissKeyboard];
    
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

@end

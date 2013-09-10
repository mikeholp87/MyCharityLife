//
//  Email.m
//  MyCharityLife
//
//  Created by Michael Holp on 7/22/13.
//  Copyright (c) 2013 MyCharityLife. All rights reserved.
//

#import "Email.h"

@implementation Email
@synthesize firstNameField, lastNameField, emailField_twitter, emailField, passwdField, settings, picture, twitterView, emailView, segControl, emailInfo, twitterInfo;

//Constants for view manipulation during keyboard usage
static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3f;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2f;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8f;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    settings = [[NSUserDefaults alloc] init];
    
    UIBarButtonItem *next = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStyleBordered target:self action:@selector(goToMain)];
    [self.navigationItem setRightBarButtonItem:next];
}

- (void)viewWillAppear:(BOOL)animated
{
    if([self.title isEqualToString:@"Twitter Signup"])
        [twitterView setHidden:YES];
    else
        [emailView setHidden:YES];
}

- (IBAction)useCamera:(id)sender
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
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Save failed" message: @"Failed to save image" delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
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

- (void)goToMain
{
    /*
    bool failed = FALSE;
    for (UIView *view in [self.view subviews]) {
        if ([view isKindOfClass:[UITextField class]]) {
            UITextField *textField = (UITextField *)view;
            if(textField.text.length > 0 && ![textField isHidden])
                continue;
            else{
                [[[UIAlertView alloc] initWithTitle:@"Missing Fields" message:@"Please fill in all fields before proceeding." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                failed = TRUE;
                break;
            }
        }
    }
    
    if(!failed){
        UITabBarController *mainTab = [self.storyboard instantiateViewControllerWithIdentifier:@"MainTabController"];
        [self presentViewController:mainTab animated:YES completion:nil];
    }
    */
    
    if([self.title isEqualToString:@"Email Signup"]){
        if([firstNameField.text length] > 0 && [lastNameField.text length] > 0 && [emailField.text length] > 0 && [passwdField.text length] > 0){
            [emailInfo setObject:[NSString stringWithFormat:@"%@ %@", firstNameField.text, lastNameField.text] forKey:@"name"];
            [emailInfo setObject:emailField.text forKey:@"email"];
            [emailInfo setObject:passwdField.text forKey:@"password"];
            [settings setObject:emailInfo forKey:@"email_info"];
            
            [settings setBool:FALSE forKey:@"login_facebook"];
            [settings setBool:FALSE forKey:@"login_twitter"];
            [settings setBool:TRUE forKey:@"login_email"];
            [settings synchronize];
            
            UITabBarController *mainTab = [self.storyboard instantiateViewControllerWithIdentifier:@"MainTabController"];
            [self presentViewController:mainTab animated:YES completion:nil];
        }else{
            [[[UIAlertView alloc] initWithTitle:@"Missing Fields" message:@"Please fill in all fields before proceeding." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
    }else{
        if([emailField_twitter.text length] > 0){
            [twitterInfo setObject:emailField_twitter.text forKey:@"twitter_email"];
            [settings setObject:twitterInfo forKey:@"twitter_info"];
            
            [settings setBool:FALSE forKey:@"login_facebook"];
            [settings setBool:FALSE forKey:@"login_email"];
            [settings setBool:TRUE forKey:@"login_twitter"];
            [settings synchronize];
            
            UITabBarController *mainTab = [self.storyboard instantiateViewControllerWithIdentifier:@"MainTabController"];
            [self presentViewController:mainTab animated:YES completion:nil];
        }else{
            [[[UIAlertView alloc] initWithTitle:@"Missing Fields" message:@"Please fill in all fields before proceeding." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
    }
}

- (UIToolbar *)keyboardToolBar {
    
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    [toolbar setBarStyle:UIBarStyleBlackTranslucent];
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
            if(lastNameField.isEditing) [firstNameField becomeFirstResponder];
            else if(emailField_twitter.isEditing) [lastNameField becomeFirstResponder];
            else if(passwdField.isEditing) [emailField_twitter becomeFirstResponder];
        }
            break;
        case 1:{
            if(firstNameField.isEditing) [lastNameField becomeFirstResponder];
            else if(lastNameField.isEditing) [emailField_twitter becomeFirstResponder];
            else if(emailField_twitter.isEditing) [passwdField becomeFirstResponder];
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
    if([self.title isEqualToString:@"Email Signup"]){
        textField.inputAccessoryView = [self keyboardToolBar];
        if (textField == firstNameField){
            [segControl setEnabled:NO forSegmentAtIndex:0];
            [segControl setEnabled:YES forSegmentAtIndex:1];
        }else if (textField == lastNameField){
            [segControl setEnabled:YES forSegmentAtIndex:0];
            [segControl setEnabled:YES forSegmentAtIndex:1];
        }else if (textField == emailField_twitter){
            [segControl setEnabled:YES forSegmentAtIndex:0];
            [segControl setEnabled:YES forSegmentAtIndex:1];
        }else{
            [segControl setEnabled:YES forSegmentAtIndex:0];
            [segControl setEnabled:NO forSegmentAtIndex:1];
        }
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

- (void)dismissKeyboard
{
    [firstNameField resignFirstResponder];
    [lastNameField resignFirstResponder];
    [emailField resignFirstResponder];
    [passwdField resignFirstResponder];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self dismissKeyboard];
    
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

@end

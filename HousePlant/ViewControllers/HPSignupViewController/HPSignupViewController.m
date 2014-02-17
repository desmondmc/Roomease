//
//  HPSignupViewController.m
//  HousePlant
//
//  Created by Desmond McNamee on 12/22/2013.
//  Copyright (c) 2013 HousePlant. All rights reserved.
//

#import "HPSignupViewController.h"
#import "HPLoginRouter.h"

@interface HPSignupViewController ()

@end

@implementation HPSignupViewController
{
    NSData *imageData;
    AMPAvatarView *avatar2;
}

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
    avatar2 = [[AMPAvatarView alloc] initWithFrame:CGRectMake(8, 79, 58, 58)];
    [self.view addSubview:avatar2];
    [avatar2 setHidden:YES];
    [self.view bringSubviewToFront:_editProfileButton];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewDidAppear:(BOOL)animated
{
    [_usernameTextField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == _usernameTextField)
    {
        [_usernameClearButton setHidden:false];
        [_passwordClearButton setHidden:true];
    }
    else if (textField == _passwordTextField)
    {
        [_usernameClearButton setHidden:true];
        [_passwordClearButton setHidden:false];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _usernameTextField) {
        [_passwordTextField becomeFirstResponder];
    }
    else
    {
        [self onSignupPress:nil];
    }
    
    return YES;
}

- (IBAction)onSignupPress:(id)sender {
    [_activityIndicator setHidden:false];
    
    PFUser *user = [PFUser user];
    user.username = _usernameTextField.text;
    user.password = _passwordTextField.text;
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            // Hooray! Let them use the app now.
            NSLog(@"User signed up successfully!");
            
            [self handleSuccessfulSignup];
        } else {
            NSString *errorString = @"There was an error signing up.";
            
            if ([error code] == kPFErrorUsernameTaken)
            {
                errorString = @"Username already taken.";
            }
            
            
            [CSNotificationView showInViewController:self
                                               style:CSNotificationViewStyleError
                                             message:errorString];
            NSLog(@"Error signing up user: %@", errorString);
        }
        [_activityIndicator setHidden:true];
    }];
}
- (IBAction)onUsernameClearButtonPress:(id)sender {
    _usernameTextField.text = @"";
}

- (IBAction)onBackPress:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)onPasswordClearButtonPress:(id)sender {
    _passwordTextField.text = @"";
}

- (IBAction)onEditProfilePicturePress:(id)sender {

    
    //Todo save profile picture to Parse.
	
    //[self.setProfilePicImage setImage:[UIImage imageNamed:@"testProfilePic"]];
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"Device has no camera"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        
        [myAlertView show];
        return;
    }
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    
    avatar2.image = chosenImage;
    
    [avatar2 setBorderWith:1.0];
    [avatar2 setShadowRadius:0.0];
    [avatar2 setBorderColor:kLightBlueColour];
    _setProfilePicImage.image = chosenImage;
    
    imageData = UIImageJPEGRepresentation(chosenImage, 1.0f);
    
    [avatar2 setHidden:NO];
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)handleSuccessfulSignup
{
    [self uploadProfilePic];
    // initialize the navigation controller and present it
    [self presentViewController:[HPLoginRouter getFirstViewToLoadForUser] animated:YES completion:nil];
}

- (void)uploadProfilePic
{
    if (imageData)
    {
        PFFile *imageFile = [PFFile fileWithName:@"profile_pic.jpg" data:imageData];
        
        // Save PFFile
        if (![imageFile save]) {
            NSLog(@"Error saving profile picture.");
        };
        
        [PFUser currentUser][@"profilePic"] = imageFile;
    }
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
@end

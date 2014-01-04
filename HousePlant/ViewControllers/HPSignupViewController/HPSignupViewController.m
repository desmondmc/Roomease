//
//  HPSignupViewController.m
//  HousePlant
//
//  Created by Desmond McNamee on 12/22/2013.
//  Copyright (c) 2013 HousePlant. All rights reserved.
//

#import "HPSignupViewController.h"

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
    avatar2 = [[AMPAvatarView alloc] initWithFrame:CGRectMake(8, 108, 58, 58)];
    [self.view addSubview:avatar2];
    [avatar2 setHidden:YES];
    [self.view bringSubviewToFront:_editProfileButton];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated
{
    //[_usernameTextField select:nil];
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

- (IBAction)onSignupPress:(id)sender {
    PFUser *user = [PFUser user];
    user.username = _usernameTextField.text;
    user.password = _passwordTextField.text;

    if (imageData)
    {
        PFFile *imageFile = [PFFile fileWithName:@"profile_pic.jpg" data:imageData];
        
        // Save PFFile
        if (![imageFile save]) {
            NSLog(@"Error saving profile picture.");
        };
        
        user[@"profilePic"] = imageFile;
    }
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            // Hooray! Let them use the app now.
            NSLog(@"User signed up successfully!");
            [CSNotificationView showInViewController:self
                                               style:CSNotificationViewStyleSuccess
                                             message:@"You've successfully signed up."];
            [self uploadProfilePic];
        } else {
            NSString *errorString = [error userInfo][@"error"];
            [CSNotificationView showInViewController:self
                                               style:CSNotificationViewStyleError
                                             message:@"There was an error signing up."];
            NSLog(@"Error signing up user: %@", errorString);
        }
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
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    
    avatar2.image = chosenImage;
    
    [avatar2 setBorderWith:0.0];
    [avatar2 setShadowRadius:0.0];
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

- (void)uploadProfilePic
{

}
@end

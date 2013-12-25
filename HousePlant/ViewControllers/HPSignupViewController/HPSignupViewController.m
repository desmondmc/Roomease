//
//  HPSignupViewController.m
//  HousePlant
//
//  Created by Desmond McNamee on 12/22/2013.
//  Copyright (c) 2013 HousePlant. All rights reserved.
//

#import "HPSignupViewController.h"
#import <Parse/Parse.h>

@interface HPSignupViewController ()

@end

@implementation HPSignupViewController
{
    NSData *imageData;
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

    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            // Hooray! Let them use the app now.
            NSLog(@"User signed up successfully!");
            [self uploadProfilePic];
        } else {
            NSString *errorString = [error userInfo][@"error"];
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
    
    AMPAvatarView *avatar2 = [[AMPAvatarView alloc] initWithFrame:CGRectMake(8, 108, 58, 58)];
    avatar2.image = chosenImage;
    
    [avatar2 setBorderWith:0.0];
    [avatar2 setShadowRadius:0.0];
    [self.view addSubview:avatar2];
    [self.view bringSubviewToFront:_editProfileButton];
    
    imageData = UIImageJPEGRepresentation(chosenImage, 1.0f);
    
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

- (void)uploadProfilePic
{
    if (imageData)
    {
        PFFile *imageFile = [PFFile fileWithName:@"profile_pic.jpg" data:imageData];
        
        // Save PFFile
        [imageFile save];
    }
}
@end

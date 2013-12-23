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
    [_usernameTextField select:nil];
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
    /* Note: This image processing is all test code. It needs to be tweeked to work with a phones camera.*/
    //Crop the image into a square.
    CGRect cropRect = CGRectMake(100, 0, 700, 700);
    CGImageRef imageRef = CGImageCreateWithImageInRect([UIImage imageNamed:@"testProfilePic"].CGImage, cropRect);
    
    AMPAvatarView *avatar2 = [[AMPAvatarView alloc] initWithFrame:CGRectMake(8, 108, 58, 58)];
    avatar2.image = [UIImage imageWithCGImage:imageRef];
    
    [avatar2 setBorderWith:0.0];
    [avatar2 setShadowRadius:0.0];
    [self.view addSubview:avatar2];
    
    //Todo save profile picture to Parse.
	
    //[self.setProfilePicImage setImage:[UIImage imageNamed:@"testProfilePic"]];
    
//    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
//    picker.delegate = self;
//    picker.allowsEditing = YES;
//    picker.sourceType = UIImagePickerControllerCameraCaptureModePhoto;
//    
//    [self presentViewController:picker animated:YES completion:NULL];
}
@end

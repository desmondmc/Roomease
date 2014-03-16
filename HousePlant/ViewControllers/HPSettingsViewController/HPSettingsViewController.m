//
//  HPSettingsViewController.m
//  RoomEase
//
//  Created by Desmond McNamee on 2/11/2014.
//  Copyright (c) 2014 HousePlant. All rights reserved.
//

#import "HPSettingsViewController.h"
#import "HPCameraManager.h"

@interface HPSettingsViewController ()

@end

@implementation HPSettingsViewController

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
    
    [HPCentralData getHouseInBackgroundWithBlock:^(HPHouse *house, NSError *error) {
        _homeLocationLabel.text = [house addressText];
    }];
    
    [_uploadingPhotoIndicator setHidden:true];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onSetLocationPress:(id)sender {
    NSString *addressText = [NSString stringWithFormat:@"%@ %@ %@",_houseNumberField.text,_streetField.text,_cityField.text];
    
    [[HPLocationManager sharedLocationManager] saveNewHouseLocationInBackgroundWithAddressString:addressText andBlock:^(NSString *errorString) {
        if (errorString) {
            [CSNotificationView showInViewController:self
                                               style:CSNotificationViewStyleError
                                             message:errorString];
        }
        else
        {
            [CSNotificationView showInViewController:self
                                               style:CSNotificationViewStyleSuccess
                                             message:@"Saved Address!"];
        }
    }];
}

- (IBAction)onBackPress:(id)sender {
        [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onSetProfilePicPress:(id)sender {
    UIImagePickerController *picker = [HPCameraManager setupCameraWithDelegate:self];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    
    [HPCentralData getCurrentUserInBackgroundWithBlock:^(HPRoommate *roommate, NSError *error) {
        //
        HPRoommate *roommateWithNewProfilePicture = [[HPRoommate alloc] init];
        [roommateWithNewProfilePicture setProfilePic:chosenImage];
        [roommateWithNewProfilePicture setAtHomeString:[roommate atHomeString]];
        [_uploadingPhotoIndicator setHidden:false];
        [HPCentralData saveCurrentUserInBackgroundWithRoommate:roommateWithNewProfilePicture andBlock:^(NSError *error) {
            [_uploadingPhotoIndicator setHidden:true];
            [HPSyncWorker handleSyncRequestWithType:roommatesSyncRequest];
        }];
        
    }];
    
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

@end

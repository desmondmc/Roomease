//
//  HPCameraManager.m
//  RoomEase
//
//  Created by Desmond McNamee on 2/19/2014.
//  Copyright (c) 2014 HousePlant. All rights reserved.
//

#import "HPCameraManager.h"

@implementation HPCameraManager

+ (UIImagePickerController *) setupCameraWithDelegate:(id)delegate
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"Device has no camera"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        
        [myAlertView show];
        return nil;
    }
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = delegate;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
    
    return picker;
}

@end

//
//  HPSettingsViewController.h
//  RoomEase
//
//  Created by Desmond McNamee on 2/11/2014.
//  Copyright (c) 2014 HousePlant. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HPSettingsViewController : UIViewController <CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *houseNumberField;
@property (weak, nonatomic) IBOutlet UITextField *streetField;
@property (weak, nonatomic) IBOutlet UITextField *cityField;
@property (weak, nonatomic) IBOutlet UILabel *homeLocationLabel;

- (IBAction)onSetLocationPress:(id)sender;
- (IBAction)onTestLocationPress:(id)sender;
- (IBAction)onBackPress:(id)sender;



@end

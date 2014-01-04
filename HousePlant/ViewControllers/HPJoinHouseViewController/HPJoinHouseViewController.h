//
//  HPJoinHouseViewController.h
//  HousePlant
//
//  Created by Desmond McNamee on 1/3/2014.
//  Copyright (c) 2014 HousePlant. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HPJoinHouseViewController : UIViewController <UITextFieldDelegate>
- (IBAction)onBackPress:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *houseNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *houseNameClearButton;
- (IBAction)houseNameClearButtonPress:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *passwordClearButton;
- (IBAction)passwordClearButtonPress:(id)sender;


@end
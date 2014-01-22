//
//  HPStartingViewController.h
//  HousePlant
//
//  Created by Desmond McNamee on 12/6/2013.
//  Copyright (c) 2013 HousePlant. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HPStartingViewController : UIViewController
- (IBAction)onLoginPress:(id)sender;
- (IBAction)onSignupPress:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *buttonView;
@property (weak, nonatomic) IBOutlet UIImageView *mainLogo;

@end

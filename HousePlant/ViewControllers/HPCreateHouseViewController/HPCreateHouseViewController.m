//
//  HPCreateHouseViewController.m
//  HousePlant
//
//  Created by Desmond McNamee on 1/3/2014.
//  Copyright (c) 2014 HousePlant. All rights reserved.
//

#import "HPCreateHouseViewController.h"
#import "HPMainViewController.h"
#import "HPNewHouseSetup.h"

typedef void (^BackgroundTaskResultBlock)(NSString *errorString);

@interface HPCreateHouseViewController ()

@end

@implementation HPCreateHouseViewController

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

- (void) viewDidAppear:(BOOL)animated
{
    [_houseNameField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidDisappear:(BOOL)animated
{
    //Cleanup view
    [_houseNameClearButton setHidden:true];
    [_passwordClearButton setHidden:true];
    [_confirmPassClearButton setHidden:true];
}


/*** User interface sheeet ***/

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == _houseNameField)
    {
        [_houseNameClearButton setHidden:false];
        [_passwordClearButton setHidden:true];
        [_confirmPassClearButton setHidden:true];
        
        [_houseNameHighlight setHidden:false];
        [_passwordHighlight setHidden:true];
        [_confirmPasswordHighlight setHidden:true];
    }
    else if (textField == _passwordField)
    {
        [_houseNameClearButton setHidden:true];
        [_passwordClearButton setHidden:false];
        [_confirmPassClearButton setHidden:true];
        
        [_houseNameHighlight setHidden:true];
        [_passwordHighlight setHidden:false];
        [_confirmPasswordHighlight setHidden:true];
    }
    else if (textField == _confirmPasswordField)
    {
        [_houseNameClearButton setHidden:true];
        [_passwordClearButton setHidden:true];
        [_confirmPassClearButton setHidden:false];
        
        [_houseNameHighlight setHidden:true];
        [_passwordHighlight setHidden:true];
        [_confirmPasswordHighlight setHidden:false];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _houseNameField) {
        [_passwordField becomeFirstResponder];
    }
    else if (textField == _passwordField)
    {
        [_confirmPasswordField becomeFirstResponder];
    }
    else
    {
        [self onMoveInPress:nil];
    }
    return YES;
}

- (IBAction)onConfirmPasswordClearPress:(id)sender {
    _confirmPasswordField.text = @"";
}
- (IBAction)onHouseNameClearPress:(id)sender {
    _houseNameField.text = @"";
}

- (IBAction)onPasswordClearPress:(id)sender {
    _passwordField.text = @"";
}
- (IBAction)onBackPress:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onMoveInPress:(id)sender {
    [_activityIndicator setHidden:false];
    [self createHouseAndMoveInUserInBackgroundWithBlock:^(NSString *errorString) {
        //
        [_activityIndicator setHidden:true];
        if (errorString)
        {
            [CSNotificationView showInViewController:self
                                               style:CSNotificationViewStyleError
                                             message:errorString];
            return;
        }
        
        //load the main view.
        HPMainViewController *mainViewController = [[HPMainViewController alloc] init];
        mainViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        
        // initialize the navigation controller and present it
        [self presentViewController:mainViewController animated:YES completion:nil];
    }];

}

- (void) createHouseAndMoveInUserInBackgroundWithBlock:(BackgroundTaskResultBlock)block
{
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        //Check if House and password are valid
        NSString *errorString = [self validateUsernameAndPasswordSubmission];
        
        if (!errorString)
        {
            //Create house parse object
            PFObject *newHouse = [PFObject objectWithClassName:@"House"];
            
            //Add password and houseName to house.
            newHouse[@"name"] = _houseNameField.text;
            newHouse[@"password"] = _passwordField.text;
            
            //Add current user to the house.
            [newHouse addUniqueObjectsFromArray:@[[PFUser currentUser]] forKey:@"users"];
            
            //[PFCloud callFunction:@"saveNewHouse" withParameters:@{@"user": [PFUser currentUser], @"house": newHouse}];
            if(![newHouse save])
            {
                errorString = @"There was an error building you house. Please try again.";
            }
            else
            {
                PFQuery *query = [PFQuery queryWithClassName:@"House"];
                [query whereKey:@"name" equalTo:_houseNameField.text];
                NSArray *houses = [query findObjects];
                PFObject *house = [houses objectAtIndex:0];
                PFUser *currentUser = [PFUser currentUser];
                currentUser[@"home"] = house;
                [currentUser save];
            }
            
            if(!errorString)
            {
                [HPCentralData getCurrentUser];
                
                //[HPCentralData getHouse] will return null because the users house hasn't been set yet in parse.
                [HPCentralData getHouse];
                
                [HPNewHouseSetup setup];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block)
                block(errorString);
            
        });
    });

}

- (NSString *) validateUsernameAndPasswordSubmission
{
    NSString *nameRegex = @"[A-Za-z]+";
    NSPredicate *nameTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", nameRegex];
    
    if(![nameTest evaluateWithObject:_houseNameField.text]){
        return @"House names can only contain letters A-Z and a-z";
    }
    
    if (_houseNameField.text.length < 1) {
        return @"Please enter a house name :)";
    }
    
    if (![_passwordField.text isEqualToString:_confirmPasswordField.text]) {
        return @"Passwords don't match.";
    }
    
    PFQuery *query = [PFQuery queryWithClassName:@"House"];
    [query whereKey:@"name" equalTo:_houseNameField.text];
    
    //Possibly put activity indicator here. That gets hidden after the query is done.
    if ([query findObjects].count > 0)
    {
        return @"House Name already taken.";
    }
    
    return nil;
}

@end

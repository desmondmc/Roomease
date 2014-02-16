//
//  SingleRoommateSubview.h
//  RoomEase
//
//  Created by Desmond McNamee on 2/16/2014.
//  Copyright (c) 2014 HousePlant. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SingleRoommateSubview : UIView

+ (id)initSingleRoommateSubviewWithRoommate:(HPRoommate *)roommate;

@property (weak, nonatomic) IBOutlet UIImageView *profilePic;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIView *atHomeTint;

@end

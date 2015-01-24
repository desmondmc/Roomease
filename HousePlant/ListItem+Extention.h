//
//  ListItem+Extention.h
//  RoomEase
//
//  Created by Desmond McNamee on 2015-01-21.
//  Copyright (c) 2015 HousePlant. All rights reserved.
//

#import "ListItem.h"

@interface ListItem (Extention)

- (void) copyAttributesFromListItem:(ListItem *) listItem;

@property (strong, nonatomic) UIImage *completedByImage;

@end

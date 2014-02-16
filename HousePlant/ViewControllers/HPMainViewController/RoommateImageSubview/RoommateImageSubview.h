//
//  FileTypeCell.h
//  bcc interface
//
//  Created by Mohan Krishna Vemulapali on 2013-09-05.
//  Copyright (c) 2013 LiveQoS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RoommateImageSubview : UIView

+ (id)roommateImageSubview;
@property (weak, nonatomic) IBOutlet UIImageView *rm1Image;
@property (weak, nonatomic) IBOutlet UILabel *rm1Label;

@property (weak, nonatomic) IBOutlet UIImageView *rm2Image;
@property (weak, nonatomic) IBOutlet UILabel *rm2Label;

@property (weak, nonatomic) IBOutlet UIImageView *rm3Image;
@property (weak, nonatomic) IBOutlet UILabel *rm3Label;

@property (weak, nonatomic) IBOutlet UIImageView *rm4Image;
@property (weak, nonatomic) IBOutlet UILabel *rm4Label;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingRoommatesSpinner;

@end

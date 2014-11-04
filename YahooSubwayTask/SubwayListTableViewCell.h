//
//  SubwayListTableViewCell.h
//  YahooSubwayTask
//
//  Created by Robert Blafford on 11/4/14.
//  Copyright (c) 2014 Robert Blafford. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubwayListTableViewCell : UITableViewCell

@property (nonatomic, strong, readonly) UILabel *title;
@property (nonatomic, strong, readonly) UILabel *desc;
@property (nonatomic, strong, readonly) UILabel *letter;

@end

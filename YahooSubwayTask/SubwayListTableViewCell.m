//
//  SubwayListTableViewCell.m
//  YahooSubwayTask
//
//  Created by Robert Blafford on 11/4/14.
//  Copyright (c) 2014 Robert Blafford. All rights reserved.
//

#import "SubwayListTableViewCell.h"

@interface SubwayListTableViewCell ()

@property (nonatomic) BOOL didUpdateConstraints;

@property (nonatomic, strong) UIView *letterContainer;

@end

@implementation SubwayListTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _title = [[UILabel alloc] init];
        _desc = [[UILabel alloc] init];
        _letter = [[UILabel alloc] init];
        _letterContainer = [[UIView alloc] init];
        
        self.title.translatesAutoresizingMaskIntoConstraints = NO;
        self.desc.translatesAutoresizingMaskIntoConstraints = NO;
        self.letter.translatesAutoresizingMaskIntoConstraints = NO;
        self.letterContainer.translatesAutoresizingMaskIntoConstraints = NO;
        
        self.title.numberOfLines = 0;
        self.desc.numberOfLines = 0;
        self.letter.numberOfLines = 0;
        self.letter.textAlignment = NSTextAlignmentCenter;
        
        CGFloat preferredTextWidth = CGRectGetWidth(self.bounds) / 2;
        self.title.preferredMaxLayoutWidth = preferredTextWidth;
        self.desc.preferredMaxLayoutWidth = preferredTextWidth;
        
        self.title.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
        self.desc.font = [UIFont fontWithName:@"Helvetica" size:15];
        self.letter.font = [UIFont fontWithName:@"Helvetica-Bold" size:75];
        
        [self.letterContainer addSubview:self.letter];
        
        [self.contentView addSubview:self.title];
        [self.contentView addSubview:self.desc];
        [self.contentView addSubview:self.letterContainer];
    }
    return self;
}

- (void)updateConstraints {
    self.letter.layer.cornerRadius = 40;
    self.letter.layer.masksToBounds = YES;

    if (self.didUpdateConstraints) {
        [super updateConstraints];
        return;
    }
    
    UILabel *title = self.title;
    UILabel *desc = self.desc;
    UILabel *letter = self.letter;
    UIView *letterContainer = self.letterContainer;
    
    NSDictionary *viewsDict = NSDictionaryOfVariableBindings(title, desc, letter, letterContainer);
    
    // In order for dynamic cell resizing to work we need to make sure that every view is pinned to the edge of the contentview
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[letterContainer(==title)]-[title(==letterContainer)]|" options:0 metrics:nil views:viewsDict]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[desc(==title)]|" options:0 metrics:nil views:viewsDict]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[title]-10-[desc]|" options:0 metrics:nil views:viewsDict]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[letterContainer(>=letter)]|" options:0 metrics:nil views:viewsDict]];
    
    [letterContainer addConstraint:[NSLayoutConstraint constraintWithItem:letter attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:letterContainer attribute:NSLayoutAttributeCenterX multiplier:1.f constant:0.f]];

    [letterContainer addConstraint:[NSLayoutConstraint constraintWithItem:letter attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:letterContainer attribute:NSLayoutAttributeCenterY multiplier:1.f constant:0.f]];
    
    [letter addConstraint:[NSLayoutConstraint constraintWithItem:letter attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:letter attribute:NSLayoutAttributeHeight multiplier:1.f constant:0.f]];
    
    self.didUpdateConstraints = YES;
    [super updateConstraints];
}

@end

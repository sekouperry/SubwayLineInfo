//
//  SubwayListTableViewController.m
//  YahooSubwayTask
//
//  Created by Robert Blafford on 11/4/14.
//  Copyright (c) 2014 Robert Blafford. All rights reserved.
//

#import "SubwayListTableViewController.h"
#import "SubwayListTableViewCell.h"

static NSString *CellReuseIdentifier = @"SubwayListCell";

@interface UIColor (hexSupport)

+ (UIColor*)colorForHexString:(NSString*)hexString;

@end

@implementation UIColor (hexSupport)

+ (UIColor*)colorForHexString:(NSString*)hexString
{
    NSString *cString = [[hexString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    NSRange range = NSMakeRange(0, 2);
    NSString *redValueString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *greenValueString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *blueValueString = [cString substringWithRange:range];
    
    // Use nsscanner to convert string to int values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:redValueString] scanHexInt:&r];
    [[NSScanner scannerWithString:greenValueString] scanHexInt:&g];
    [[NSScanner scannerWithString:blueValueString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

@end

@interface SubwayListTableViewController ()

@property (nonatomic, copy) NSArray *subwayLines;

@property (nonatomic, strong) SubwayListTableViewCell *dummyCell;

@end

@implementation SubwayListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.allowsSelection = NO;
    [self.tableView registerClass:[SubwayListTableViewCell class] forCellReuseIdentifier:CellReuseIdentifier];
    
    // Get full path of the resource, convert it to NSData and deserialize the data blob
    NSString *path = [[NSBundle mainBundle] pathForResource:@"subway-lister" ofType:@"json"];
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    
    NSError *jsonParseError = nil;
    id parsedData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonParseError];
    
    if (!jsonParseError && parsedData && [parsedData isKindOfClass:[NSDictionary class]]) {
        self.subwayLines = [(NSDictionary *)parsedData objectForKey:@"lines"];
    } else {
        self.subwayLines = @[];
    }
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark - UITableViewControllerDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.subwayLines count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SubwayListTableViewCell *cell = (SubwayListTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellReuseIdentifier forIndexPath:indexPath];

    NSDictionary *itemInfo = self.subwayLines[indexPath.row];
    cell.title.text = itemInfo[@"name"];
    cell.desc.text = itemInfo[@"desc"];
    cell.letter.text = itemInfo[@"letter"];
    cell.letter.backgroundColor = [UIColor colorForHexString:itemInfo[@"hexcolor"]];
    
    // Make sure autolayout constraints are applied before cell is drawn to table for its first time
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    
    return cell;
}

// Add dynamic cell sizing using auto layout
// We will fill the dummy cell with the values that would be displayed at the cell at a given index path
// Then we will call updateConstraints to let the autolayout engine render the cell and its subviews
// Then we can call systemLayoutSizeFittingSize on the cells content view to determine the height
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *itemInfo = self.subwayLines[indexPath.row];
    
    // Fill the dummy cell just like the one at indexpath would appear as so I can calulate the proper cell height
    if (!self.dummyCell)
        self.dummyCell = [[SubwayListTableViewCell alloc] init];
    
    self.dummyCell.title.text = itemInfo[@"name"];
    self.dummyCell.desc.text = itemInfo[@"desc"];
    self.dummyCell.letter.text = itemInfo[@"letter"];
    self.dummyCell.letter.backgroundColor = [UIColor colorForHexString:itemInfo[@"hexcolor"]];
    
    // Force the content to layout with custom constraints created in updateConstraints
    [self.dummyCell setNeedsUpdateConstraints];
    [self.dummyCell updateConstraintsIfNeeded];
    
    // Set the width of the cell to match the width of the table view.
    self.dummyCell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(tableView.bounds), CGRectGetHeight(self.dummyCell.bounds));
    
    // Do the layout pass on the cell, which will calculate the frames for all the views based on the constraints.
    [self.dummyCell setNeedsLayout];
    [self.dummyCell layoutIfNeeded];
    
    // Get the actual height required for the cell's contentView
    CGFloat height = [self.dummyCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    
    // Add an extra point to the height to account for the cell separator, which is added between the bottom of the cell's contentView and the bottom of the table view cell.
    height += 1.0f;
    return height;
}

@end

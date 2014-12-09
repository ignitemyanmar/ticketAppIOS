//
//  BusCell.m
//  BusOperator
//
//  Created by Macbook Pro on 5/14/14.
//  Copyright (c) 2014 Ignite Software Solution. All rights reserved.
//

#import "BusCell.h"

@implementation BusCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectBusType:) name:@"selectBusType" object:nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//- (IBAction)selectBusType:(id)sender {
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"selectBusTypeOnClicked" object:@(sender.tag)];
//}

- (void)didSelectBusType:(NSNotification*)notification
{
    NSString* str = (NSString*)notification.object;
    
    NSDictionary* dict = @{@"cell": self, @"string": str};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"busTypeRetured" object:dict];
}
@end

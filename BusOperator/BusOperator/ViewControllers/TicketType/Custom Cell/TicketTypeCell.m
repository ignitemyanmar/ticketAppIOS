//
//  TicketTypeCell.m
//  BusOperator
//
//  Created by Macbook Pro on 6/12/14.
//  Copyright (c) 2014 Ignite Software Solution. All rights reserved.
//

#import "TicketTypeCell.h"

@implementation TicketTypeCell

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
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

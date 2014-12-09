//
//  SeatlayoutCell.h
//  BusOperator
//
//  Created by Macbook Pro on 6/11/14.
//  Copyright (c) 2014 Ignite Software Solution. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SeatlayoutCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *cellRowCount;
@property (strong, nonatomic) IBOutlet UILabel *cellColCount;
@property (strong, nonatomic) IBOutlet UILabel *cellTotalSeat;


@end

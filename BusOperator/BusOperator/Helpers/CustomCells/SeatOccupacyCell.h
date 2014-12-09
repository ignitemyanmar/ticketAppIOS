//
//  SeatOccupacyCell.h
//  BusOperator
//
//  Created by Macbook Pro on 5/12/14.
//  Copyright (c) 2014 Ignite Software Solution. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SeatOccupacyCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UILabel *cellLblName;

@property (strong, nonatomic) IBOutlet UILabel *cellLblNrc;

@property (weak, nonatomic) IBOutlet UILabel *cellLblAgent;


@end

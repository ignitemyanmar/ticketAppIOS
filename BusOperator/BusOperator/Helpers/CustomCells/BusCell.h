//
//  BusCell.h
//  BusOperator
//
//  Created by Macbook Pro on 5/14/14.
//  Copyright (c) 2014 Ignite Software Solution. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BusCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UITextField *cellTxtBusNo;
@property (strong, nonatomic) IBOutlet UIButton *cellBtnType;

@property (strong, nonatomic) IBOutlet UIView *cellBtnBkgView;

- (IBAction)selectBusType:(id)sender;

@end

//
//  TripReportCell.h
//  BusOperator
//
//  Created by Macbook Pro on 5/9/14.
//  Copyright (c) 2014 Ignite Software Solution. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TripReportCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *cellLblDate;
@property (strong, nonatomic) IBOutlet UILabel *cellLblTotalSeat;
@property (strong, nonatomic) IBOutlet UILabel *cellLblTotalSales;
@property (strong, nonatomic) IBOutlet UILabel *cellLblUnitPrice;
@property (strong, nonatomic) IBOutlet UILabel *cellLblTransactionNo;
@property (strong, nonatomic) IBOutlet UIView *cellBtnBkgView;
@property (strong, nonatomic) IBOutlet UIView *cellBtnEditBkgView;
@property (weak, nonatomic) IBOutlet UIView *cellBtnHolidayBkgView;
@property (weak, nonatomic) IBOutlet UIView *cellSeperator;
@property (weak, nonatomic) IBOutlet UILabel *cellLblTextExtra;




@end

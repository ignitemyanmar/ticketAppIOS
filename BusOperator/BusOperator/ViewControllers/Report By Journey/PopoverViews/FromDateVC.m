//
//  FromDateVC.m
//  BusOperator
//
//  Created by Macbook Pro on 5/9/14.
//  Copyright (c) 2014 Ignite Software Solution. All rights reserved.
//

#import "FromDateVC.h"

@interface FromDateVC () <CKCalendarDelegate>

@property (strong, nonatomic) NSDateFormatter* dateFormatter;
@property (strong, nonatomic) NSDate* minimumDate;
@property (assign, nonatomic) CGSize sizeM;

@end

@implementation FromDateVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    _calenderView.delegate = self;
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"yyyy-MM-dd"];
    self.minimumDate = [self.dateFormatter dateFromString:@"2012-09-20"];
    
    _calenderView.onlyShowCurrentMonth = NO;
    
    _sizeM = self.preferredContentSize;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CKCalendarDelegate

- (void)calendar:(CKCalendarView *)calendar configureDateItem:(CKDateItem *)dateItem forDate:(NSDate *)date {
    // TODO: play with the coloring if we want to...
    //    if ([self dateIsDisabled:date]) {
    //        dateItem.backgroundColor = [UIColor redColor];
    //        dateItem.textColor = [UIColor whiteColor];
    //    }
}

- (BOOL)calendar:(CKCalendarView *)calendar willSelectDate:(NSDate *)date {
    return YES;//![self dateIsDisabled:date];
}

- (void)calendar:(CKCalendarView *)calendar didSelectDate:(NSDate *)date {
    
    NSString* strDate = [self.dateFormatter stringFromDate:date];
    NSString* str = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentvc"];
    if ([str isEqualToString:@"seatoccupacyreportvc"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"selectFromDateFromSeatReport" object:strDate];
    }
    else if ([str isEqualToString:@"tripreportvc"])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"didSelectFromDate" object:strDate];
    }
    else if ([str isEqualToString:@"addbusschedulevc"])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"selectDateFromBusSchedule" object:strDate];
    }
    else if ([str isEqualToString:@"checkbusschedulevc"])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"didSelectDateFromCheckBus" object:strDate];
    }
    else if ([str isEqualToString:@"ShowBusSchedule"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"didSelectDateFromShowBusSchedule" object:strDate];
    }
    else if ([str isEqualToString:@"addnewBusSchedule"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"didSelectDateFromAddNewBusSchedule" object:strDate];
    }
    
}

- (BOOL)calendar:(CKCalendarView *)calendar willChangeToMonth:(NSDate *)date {
    if ([date laterDate:self.minimumDate] == date) {
        _calenderView.backgroundColor = [UIColor colorWithRed:19.0/255 green:62.0/255 blue:72.0/255 alpha:1];
        return YES;
    } else {
        _calenderView.backgroundColor = [UIColor redColor];
        return NO;
    }
}

- (void)calendar:(CKCalendarView *)calendar didLayoutInRect:(CGRect)frame {
    NSLog(@"calendar layout: %@", NSStringFromCGRect(frame));
}


@end

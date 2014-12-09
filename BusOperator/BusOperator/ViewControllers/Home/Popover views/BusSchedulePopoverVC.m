//
//  BusSchedulePopoverVC.m
//  BusOperator
//
//  Created by Macbook Pro on 5/15/14.
//  Copyright (c) 2014 Ignite Software Solution. All rights reserved.
//

#import "BusSchedulePopoverVC.h"
#import "UIStoryboard+MultipleStoryboards.h"
#import "AddBusScheduleVC.h"

@interface BusSchedulePopoverVC ()


@property (weak, nonatomic) IBOutlet UIButton *btnDaily;
@property (weak, nonatomic) IBOutlet UIButton *btnDepartureSale;
@property (weak, nonatomic) IBOutlet UIButton *btnAdvancedSale;


- (IBAction)DailySaleReport:(id)sender;

- (IBAction)AddBusSchedule:(id)sender;

- (IBAction)CheckBusSchedule:(id)sender;


@end

@implementation BusSchedulePopoverVC

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
    
    [_btnDaily setTitle:@"ေန ့စဥ္အေရာင္း ၾကည့္ရန္" forState:UIControlStateNormal];
    _btnDaily.titleLabel.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    
    [_btnDepartureSale setTitle:@"ထြက္ခြာခ်ိန္အလုုိက္ အေရာင္း ၾကည့္ရန္" forState:UIControlStateNormal];
    _btnDepartureSale.titleLabel.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    
    [_btnAdvancedSale setTitle:@"အထူး(ၾကိဳတင္) အေရာင္း ၾကည့္ရန္" forState:UIControlStateNormal];
    _btnAdvancedSale.titleLabel.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)DailySaleReport:(id)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"didSelectDailySaleReport" object:nil];
}

- (IBAction)AddBusSchedule:(id)sender {
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"didSelectAddBusSchedule" object:nil];
    
}

- (IBAction)CheckBusSchedule:(id)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"didSelectCheckBusSchedule" object:nil];
}
@end

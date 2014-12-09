//
//  ManageCarPriceVC.m
//  BusOperator
//
//  Created by Macbook Pro on 5/26/14.
//  Copyright (c) 2014 Ignite Software Solution. All rights reserved.
//

#import "ManageCarPriceVC.h"
#import "AddBusScheduleVC.h"
#import "CheckBusScheduleVC.h"
#import "UIStoryboard+MultipleStoryboards.h"

@interface ManageCarPriceVC ()

@property (strong, nonatomic) UIPopoverController* mypopovervc;

@property (weak, nonatomic) IBOutlet UIButton *btnHolidaySchedule;
@property (weak, nonatomic) IBOutlet UIButton *btnBusSchedule;


@end

@implementation ManageCarPriceVC

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
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"BkgColor.png"]];
    
    _btnHolidaySchedule.titleLabel.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    [_btnHolidaySchedule setTitle:@"ခရီးစဥ္နားရက္ စီမံရန္" forState:UIControlStateNormal];
    
    _btnBusSchedule.titleLabel.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    [_btnBusSchedule setTitle:@"ကားထြက္ခ်ိန္ စီမံရန္" forState:UIControlStateNormal];

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

//-(void)prepareForSegue:(UIStoryboardPopoverSegue *)segue sender:(id)sender{
//    _mypopovervc = [(UIStoryboardPopoverSegue *)segue popoverController];
//}



@end

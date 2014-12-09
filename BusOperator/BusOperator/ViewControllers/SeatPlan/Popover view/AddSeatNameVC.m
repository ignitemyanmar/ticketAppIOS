//
//  AddSeatNameVC.m
//  BusOperator
//
//  Created by Macbook Pro on 6/11/14.
//  Copyright (c) 2014 Ignite Software Solution. All rights reserved.
//

#import "AddSeatNameVC.h"

@interface AddSeatNameVC ()
- (IBAction)AddSeatname:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *txtSeatname;

@end

@implementation AddSeatNameVC

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
}

- (void)viewWillAppear:(BOOL)animated
{
    if ([_seatno isEqualToString:@"Label"]) {
        _txtSeatname.text = @"";
    }
    else _txtSeatname.text = _seatno;
    
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

- (IBAction)AddSeatname:(id)sender {
    
    if (_txtSeatname.text.length > 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"finishAddingSeatName" object:_txtSeatname.text];
    }
    
}
@end

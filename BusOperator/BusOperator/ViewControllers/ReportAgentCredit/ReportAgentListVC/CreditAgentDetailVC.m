//
//  CreditAgentDetailVC.m
//  BusOperator
//
//  Created by Macbook Pro on 10/17/14.
//  Copyright (c) 2014 Ignite Software Solution. All rights reserved.
//

#import "CreditAgentDetailVC.h"
#import "InputCreditVC.h"
#import "InputCommissionVC.h"
#import "InputPrepaidVC.h"
#import "TripCommissionVC.h"
#import "PaymentListVC.h"
#import "CreditListVC.h"

@interface CreditAgentDetailVC ()

@property (weak, nonatomic) IBOutlet UIButton *btnInputCredit;
@property (weak, nonatomic) IBOutlet UIButton *btnInputCommission;
@property (weak, nonatomic) IBOutlet UIButton *btnTripcommision;
@property (weak, nonatomic) IBOutlet UIButton *btnInputPrepaid;
@property (weak, nonatomic) IBOutlet UIButton *btnCredit;
@property (weak, nonatomic) IBOutlet UIButton *btnPaymentlist;

- (IBAction)InputCredit:(id)sender;
- (IBAction)InputCommision:(id)sender;
- (IBAction)TripCommisionList:(id)sender;
- (IBAction)InputPrepaid:(id)sender;
- (IBAction)CreditList:(id)sender;
- (IBAction)PaymentList:(id)sender;



@end

@implementation CreditAgentDetailVC

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
    
    _btnInputCredit.titleLabel.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    [_btnInputCredit setTitle:@"အရင္အေၾကြးေဟာင္းမ်ားထည့္ရန္" forState:UIControlStateNormal];

    _btnInputCommission.titleLabel.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    [_btnInputCommission setTitle:@"Commission ထည့္ရန္" forState:UIControlStateNormal];
    
    _btnTripcommision.titleLabel.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    [_btnTripcommision setTitle:@"ခရီးစဥ္-Commission မ်ား" forState:UIControlStateNormal];
    
    _btnInputPrepaid.titleLabel.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    [_btnInputPrepaid setTitle:@"စရံေငြ ထည့္ရန္" forState:UIControlStateNormal];
    
    _btnCredit.titleLabel.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    [_btnCredit setTitle:@"ေၾကြးစာရင္းမ်ားၾကည့္ရန္" forState:UIControlStateNormal];
    
    _btnPaymentlist.titleLabel.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    [_btnPaymentlist setTitle:@"ေပးျပီးသားစာရင္းမ်ားၾကည့္ရန္" forState:UIControlStateNormal];

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

- (IBAction)InputCredit:(id)sender {
    
    InputCreditVC* nexvc = (InputCreditVC*)[self.storyboard instantiateViewControllerWithIdentifier:@"InputCreditVC"];
    nexvc.agentinfo = [_agentinfo copy];
    [self.navigationController pushViewController:nexvc animated:YES];
}

- (IBAction)InputCommision:(id)sender {
    InputCommissionVC* nexvc = (InputCommissionVC*)[self.storyboard instantiateViewControllerWithIdentifier:@"InputCommissionVC"];
    nexvc.agentid = [_agentinfo[@"id"] intValue];
    [self.navigationController pushViewController:nexvc animated:YES];
    
}

- (IBAction)TripCommisionList:(id)sender {
    TripCommissionVC* nexvc = (TripCommissionVC*)[self.storyboard instantiateViewControllerWithIdentifier:@"TripCommissionVC"];
    nexvc.agentid = [_agentinfo[@"id"] intValue];
    [self.navigationController pushViewController:nexvc animated:YES];
}

- (IBAction)InputPrepaid:(id)sender {
    
    InputPrepaidVC* nexvc = (InputPrepaidVC*) [self.storyboard instantiateViewControllerWithIdentifier:@"InputPrepaidVC"];
    nexvc.agentinfo = [_agentinfo copy];
    [self.navigationController pushViewController:nexvc animated:YES];
}

- (IBAction)CreditList:(id)sender {
    CreditListVC* nexvc = (CreditListVC*) [self.storyboard instantiateViewControllerWithIdentifier:@"CreditListVC"];
    nexvc.agentid = [_agentinfo[@"id"] intValue];
    nexvc.prepaidamt = _prepaidamt;
    [self.navigationController pushViewController:nexvc animated:YES];
    
}

- (IBAction)PaymentList:(id)sender {
    
    PaymentListVC* nexvc = (PaymentListVC*) [self.storyboard instantiateViewControllerWithIdentifier:@"PaymentListVC"];
    nexvc.agentid =[_agentinfo[@"id"] intValue];
    [self.navigationController pushViewController:nexvc animated:YES];
}
@end

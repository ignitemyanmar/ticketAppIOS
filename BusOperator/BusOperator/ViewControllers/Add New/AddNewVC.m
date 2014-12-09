//
//  AddNewVC.m
//  BusOperator
//
//  Created by Macbook Pro on 6/4/14.
//  Copyright (c) 2014 Ignite Software Solution. All rights reserved.
//

#import "AddNewVC.h"
#import "ShowEditAllVC.h"
#import "OperatorShowEditAllVC.h"

@interface AddNewVC ()

@property (weak, nonatomic) IBOutlet UIButton *btnCity;
@property (weak, nonatomic) IBOutlet UIButton *btnAgentGroup;
@property (weak, nonatomic) IBOutlet UIButton *btnBusType;
@property (weak, nonatomic) IBOutlet UIButton *btnOperator;
@property (weak, nonatomic) IBOutlet UIButton *btnTicketType;
@property (weak, nonatomic) IBOutlet UIButton *btnCommissionType;

- (IBAction)SearchCity:(id)sender;
- (IBAction)SearchAgentGroup:(id)sender;
- (IBAction)SearchBusType:(id)sender;
- (IBAction)SearchOperator:(id)sender;
- (IBAction)SearchTicketType:(id)sender;
- (IBAction)SearchCommissionType:(id)sender;

@end

@implementation AddNewVC

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
    
    NSDictionary* userinfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"userinfo"];
    NSString* usertype = userinfo[@"type"];
    if (![usertype isEqualToString:@"operator"]) {
    
    UIButton *backbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [backbtn setTitle:@"< ခရီးသြားလုုပ္ငန္း ေရြးရန္" forState:UIControlStateNormal];
    backbtn.titleLabel.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    [backbtn setTitleColor:[UIColor colorWithRed:0.0f/255 green:122.0f/255 blue:255.0f/255 alpha:1] forState:UIControlStateNormal];
    backbtn.adjustsImageWhenDisabled = NO;
    backbtn.frame = CGRectMake(0, 0, 150, 40);
    [backbtn addTarget:self action:@selector(dismissThisView) forControlEvents:UIControlEventTouchUpInside];
    backbtn.tintColor= [UIColor colorWithRed:243.0/255 green:130.0/255 blue:0 alpha:1];
    UIBarButtonItem *backbaritem = [[UIBarButtonItem alloc] initWithCustomView:backbtn];
    
    self.navigationItem.leftBarButtonItem = backbaritem;
    }

    
    _btnCity.titleLabel.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    [_btnCity setTitle:@"ျမိဳ ့" forState:UIControlStateNormal];
    
    _btnAgentGroup.titleLabel.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    [_btnAgentGroup setTitle:@"၀န္ေဆာင္မႈလုုပ္ငန္း အဖြဲ ့အစည္း" forState:UIControlStateNormal];
    _btnBusType.titleLabel.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    [_btnBusType setTitle:@"ကားအမ်ိဴးအစား" forState:UIControlStateNormal];
    _btnOperator.titleLabel.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    [_btnOperator setTitle:@"ခရီးသြားလုုပ္ငန္း" forState:UIControlStateNormal];
    _btnTicketType.titleLabel.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    [_btnTicketType setTitle:@"လက္မွတ္အမ်ိဴးအစား" forState:UIControlStateNormal];
    _btnCommissionType.titleLabel.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    [_btnCommissionType setTitle:@"Commissionခ အမ်ိဳးအစား" forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dismissThisView
{
    [self.tabBarController.navigationController popViewControllerAnimated:YES];
}

- (IBAction)SearchCity:(id)sender {
    ShowEditAllVC* destvc = (ShowEditAllVC*)[self.storyboard instantiateViewControllerWithIdentifier:@"ShowEditAllVC"];
    destvc.previousvc = @"city";
    [self.navigationController pushViewController:destvc animated:YES];
}

- (IBAction)SearchAgentGroup:(id)sender {
    ShowEditAllVC* destvc = (ShowEditAllVC*)[self.storyboard instantiateViewControllerWithIdentifier:@"ShowEditAllVC"];
    destvc.previousvc = @"agentgroup";
    [self.navigationController pushViewController:destvc animated:YES];

}

- (IBAction)SearchBusType:(id)sender {
    ShowEditAllVC* destvc = (ShowEditAllVC*)[self.storyboard instantiateViewControllerWithIdentifier:@"ShowEditAllVC"];
    destvc.previousvc = @"bustype";
    [self.navigationController pushViewController:destvc animated:YES];
}

- (IBAction)SearchOperator:(id)sender {
    
    OperatorShowEditAllVC* destvc = (OperatorShowEditAllVC*)[self.storyboard instantiateViewControllerWithIdentifier:@"OperatorShowEditAllVC"];
    [self.navigationController pushViewController:destvc animated:YES];
}

- (IBAction)SearchTicketType:(id)sender {
    
    ShowEditAllVC* destvc = (ShowEditAllVC*)[self.storyboard instantiateViewControllerWithIdentifier:@"ShowEditAllVC"];
    destvc.previousvc = @"tickettype";
    [self.navigationController pushViewController:destvc animated:YES];
}

- (IBAction)SearchCommissionType:(id)sender {
    
    ShowEditAllVC* destvc = (ShowEditAllVC*)[self.storyboard instantiateViewControllerWithIdentifier:@"ShowEditAllVC"];
    destvc.previousvc = @"commissiontype";
    [self.navigationController pushViewController:destvc animated:YES];

}
@end

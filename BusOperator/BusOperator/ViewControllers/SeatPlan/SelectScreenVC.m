//
//  SelectScreenVC.m
//  BusOperator
//
//  Created by Macbook Pro on 6/10/14.
//  Copyright (c) 2014 Ignite Software Solution. All rights reserved.
//

#import "SelectScreenVC.h"

@interface SelectScreenVC ()

@property (weak, nonatomic) IBOutlet UIButton *btnSeatLayout;

@property (weak, nonatomic) IBOutlet UIButton *btnSeatPlan;

@end

@implementation SelectScreenVC

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
    backbtn.adjustsImageWhenDisabled = NO;
    backbtn.frame = CGRectMake(0, 0, 150, 40);
    [backbtn addTarget:self action:@selector(dismissThisView) forControlEvents:UIControlEventTouchUpInside];
    backbtn.tintColor= [UIColor colorWithRed:243.0/255 green:130.0/255 blue:0 alpha:1];
    UIBarButtonItem *backbaritem = [[UIBarButtonItem alloc] initWithCustomView:backbtn];
    
    self.navigationItem.leftBarButtonItem = backbaritem;
    }
    
    _btnSeatLayout.titleLabel.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    [_btnSeatLayout setTitle:@"ကားထိုုင္ခံုုေနရာ စီစဥ္ရန္" forState:UIControlStateNormal];
    
    _btnSeatPlan.titleLabel.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    [_btnSeatPlan setTitle:@"ကားထိုုင္ခံုုနံပါတ္ သတ္မွတ္ရန္" forState:UIControlStateNormal];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

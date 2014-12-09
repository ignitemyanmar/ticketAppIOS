//
//  DepartureReportWithSeatNoVC.m
//  BusOperator
//
//  Created by Macbook Pro on 6/17/14.
//  Copyright (c) 2014 Ignite Software Solution. All rights reserved.
//

#import "DepartureReportWithSeatNoVC.h"
#import "JDStatusBarNotification.h"
#import "TripReportCell.h"
#import "Reachability.h"

@interface DepartureReportWithSeatNoVC () <UITableViewDataSource, UITableViewDelegate>


@property (strong, nonatomic) NSMutableArray* imageArray;
@property (assign, nonatomic) BOOL istvReload;
@property (strong, nonatomic) NSString* documentDirectoryFilename;
@property (strong, nonatomic) Reachability* reachability;
@property (nonatomic) BOOL reachable;

@property (strong, nonatomic) IBOutlet UITableView *tbreportbyseat;
@property (strong, nonatomic) IBOutlet UILabel *lblSeatNo;
@property (strong, nonatomic) IBOutlet UILabel *lblPerson;
@property (strong, nonatomic) IBOutlet UILabel *lblSoldby;
@property (strong, nonatomic) IBOutlet UILabel *lblUnitPrice;
@property (strong, nonatomic) IBOutlet UILabel *lblTransactionNo;
@property (strong, nonatomic) IBOutlet UILabel *lblTotal;
@property (strong, nonatomic) IBOutlet UILabel *lblTotalAmt;
@property (strong, nonatomic) IBOutlet UIView *tbHeaderView;
@property (strong, nonatomic) IBOutlet UIView *viewTotal;


@end

@implementation DepartureReportWithSeatNoVC

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
    
    self.title = @"Seat Report";
    
    self.reachability = [Reachability reachabilityForInternetConnection];
    [self.reachability startNotifier];
    self.reachable = [self.reachability currentReachabilityStatus];
    
    _imageArray = [[NSMutableArray alloc] init];
    
    UIButton *righBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    righBtn.frame = CGRectMake(0, 0, 50, 50);
    
    [righBtn setTitleColor:[UIColor colorWithRed:0.0f/255.0f green:122.0f/255.0f blue:255.0f/255.0f alpha:1] forState:UIControlStateNormal];
    
    [righBtn setTitle:@"Print" forState:UIControlStateNormal];
    [righBtn addTarget:self action:@selector(printOnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc] initWithCustomView:righBtn];
    
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:rightBarBtn, nil]];
    
//    _lblTotalAmt.text = @"10000 Ks";
    
    
    _lblSeatNo.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblSeatNo.text = @"ခံုု နံပါတ္";
    
    _lblPerson.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblPerson.text = @"၀ယ္သူ";
    
    _lblSoldby.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblSoldby.text = @"ေရာင္းသူ";
    
    _lblUnitPrice.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblUnitPrice.text = @"တန္ဖိုုး";
    
    _lblTransactionNo.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblTransactionNo.text = @"အေရာင္း နံပါတ္စဥ္";
    
    _lblTotal.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblTotal.text = @"စုုစုုေပါင္း";
    
    long totalAmt = 0;
    for (NSDictionary* dict in _dataFiller) {
        totalAmt += [dict[@"price"] longLongValue];
    }
    _lblTotalAmt.text = [NSString stringWithFormat:@"%ld Ks",totalAmt];
    
    if (!self.reachable) {
        NSDictionary* dict1 = @{@"seat_no": @"1", @"name":@"Daw Aye", @"agent":@"City Mart", @"price":@"2000 Ks", @"sale_id":@"201451201"};
        NSDictionary* dict2 = @{@"seat_no": @"4", @"name":@"U Ba", @"agent":@"Agent 1", @"price":@"2000 Ks", @"sale_id":@"201451202"};
        NSDictionary* dict3 = @{@"seat_no": @"6", @"name":@"Daw Mya", @"agent":@"Agent 1", @"price":@"2000 Ks", @"sale_id":@"201451205"};
        NSDictionary* dict4 = @{@"seat_no": @"8", @"name":@"Daw Hla", @"agent":@"Agent 5", @"price":@"2000 Ks", @"sale_id":@"201451219"};
        NSDictionary* dict5 = @{@"seat_no": @"9", @"name":@"U Aye", @"agent":@"Agent 2", @"price":@"2000 Ks", @"sale_id":@"201451226"};
        
        _dataFiller = @[dict1,dict2,dict3,dict4,dict5];
        _lblTotalAmt.text = @"8000 Ks";
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)printOnClicked
{
    [self convertViewToImage];
    [self createPDF];
    
    NSArray *activityItems = @[[NSData dataWithContentsOfFile:self.documentDirectoryFilename]];
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems
                                                                                         applicationActivities:nil];
    [self presentViewController:activityViewController animated:YES completion:NULL];
}

- (void)convertViewToImage
{
    [_imageArray removeAllObjects];
//    UIImage *infoView = [self captureView:_bkgInfoView withRect:CGRectMake(0, 0, _bkgInfoView.frame.size.width, _bkgInfoView.frame.size.height)];
    UIImage *tbHearder = [self captureView:_tbHeaderView withRect:CGRectMake(0, 0, _tbHeaderView.frame.size.width, _tbHeaderView.frame.size.height)];
    
    UIImage *totalView = [self captureView:_viewTotal withRect:CGRectMake(0, 0, _viewTotal.frame.size.width, _viewTotal.frame.size.height)];
    
//    UIImage *resizedInfo = [UIImage imageWithCGImage:[infoView CGImage] scale:(infoView.scale * 2.0) orientation:(infoView.imageOrientation)];
//    [_imageArray addObject:resizedInfo];
    UIImage *resizedHeader = [UIImage imageWithCGImage:[tbHearder CGImage] scale:(tbHearder.scale * 2.0) orientation:(tbHearder.imageOrientation)];
    [_imageArray addObject:resizedHeader];
    
    self.istvReload = YES;
    for (int i = 0; i < _dataFiller.count; i++) {
        NSIndexPath *indexP = [NSIndexPath indexPathForRow:i inSection:0];
        [self tableView:_tbreportbyseat cellForRowAtIndexPath:indexP];
    }
    self.istvReload = NO;
    UIImage *resizedtotalView = [UIImage imageWithCGImage:[totalView CGImage] scale:(totalView.scale * 2.0) orientation:(totalView.imageOrientation)];
    [_imageArray addObject:resizedtotalView];
    
}

- (void)createPDF
{
    // A4
    int totalcount = _imageArray.count;
    float multiplier = totalcount/24.0f;
    if (!(fmodf(multiplier, 1.0) == 0.0)) {
        multiplier +=1;
    }
    int mulInt = (int)multiplier;
    // A4
    CGRect pdfPageBounds = CGRectMake(0, 0, 595, 700);//612,792 // 842
    int counter = 0;
    BOOL pageStart = YES;
    CGFloat ticketStartPoint = 0.0;
    
    NSMutableData *pdfData = [[NSMutableData alloc] init];
    UIGraphicsBeginPDFContextToData(pdfData, pdfPageBounds, nil); {
        for (int outLoop = 0; outLoop < mulInt; outLoop++) {
            UIGraphicsBeginPDFPageWithInfo(pdfPageBounds, nil);
            pageStart = YES;
            for (int i = 1; i < 25; i++) { //SMT: 2 TICKETS PER PAGE
                
                UIImage *gymLogo = self.imageArray[counter];//[UIImage imageNamed:@"concrete_wall.png"];
                CGPoint drawingLogoOrgin;
                if (pageStart) {
                    drawingLogoOrgin = CGPointMake(5,5);
                    pageStart = NO;
                    ticketStartPoint = 5;
                }
                else
                {
                    UIImage* prevImg = self.imageArray[counter-1];
                    ticketStartPoint += prevImg.size.height;
                    drawingLogoOrgin = CGPointMake(5, ticketStartPoint);
                }
                
                [gymLogo drawAtPoint:drawingLogoOrgin];
                if (counter < self.imageArray.count-1) {
                    counter++;
                    
                }
                else break;
                
            }
            
        }
        
    } UIGraphicsEndPDFContext();
    
    NSArray* documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    
    NSString* documentDirectory = [documentDirectories objectAtIndex:0];
    self.documentDirectoryFilename = [documentDirectory stringByAppendingPathComponent:@"TripReportBySeatNEW.pdf"];
    
    // instructs the mutable data object to write its context to a file on disk
    [pdfData writeToFile:self.documentDirectoryFilename atomically:YES];
}


- (UIImage *)captureView:(UIView *)view withRect:(CGRect)cellRect
{
    UIGraphicsBeginImageContextWithOptions(cellRect.size, NO, 0.0);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    [view.layer renderInContext:ctx];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}


- (void) JDStatusBarHidden:(BOOL)hidden status:(NSString *)status duration:(NSTimeInterval)interval
{
    if(hidden) {
        [JDStatusBarNotification dismiss];
    } else {
        [JDStatusBarNotification addStyleNamed:@"StatusBarStyle" prepare:^JDStatusBarStyle *(JDStatusBarStyle *style) {
            style.barColor = [UIColor colorWithRed:251.0/255.0 green:143.0/255.0 blue:27.0/255.0 alpha:1.0];
            style.textColor = [UIColor whiteColor];
            return style;
        }];
        if(interval != 0) {
            [JDStatusBarNotification showWithStatus:status dismissAfter:interval styleName:@"StatusBarStyle"];
        } else {
            [JDStatusBarNotification showWithStatus:status styleName:@"StatusBarStyle"];
            [JDStatusBarNotification showActivityIndicator:YES indicatorStyle:UIActivityIndicatorViewStyleGray];
        }
    }
}

#pragma mark - UITableview Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataFiller.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //STARTING POINT
    NSString* cellid = @"dailyseatcell";
    TripReportCell* cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    
    NSDictionary* dict = _dataFiller[indexPath.row];
    NSLog(@"Seat Report Dict = %@", dict);
    
    /*
     {
     "bus_id": "3",
     "sale_id": 3,
     "order_id": "2",
     "order_date": "2014-06-18",
     "seat_no": "A1",
     "name": "saw",
     "agent": "Myaynigone City Mart",
     "price": "15000"
     }
     */
    
    cell.cellLblDate.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    cell.cellLblTotalSeat.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    cell.cellLblTotalSales.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    cell.cellLblUnitPrice.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    cell.cellLblTransactionNo.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    cell.cellLblTextExtra.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    
    cell.cellLblDate.text = dict[@"seat_no"];
    cell.cellLblTotalSeat.text = dict[@"name"];
    cell.cellLblTotalSales.text = dict[@"agent"];
    cell.cellLblUnitPrice.text = [NSString stringWithFormat:@"%@",dict[@"price"]];
    cell.cellLblTransactionNo.text = [NSString stringWithFormat:@"%@",dict[@"sale_id"]];
    int comm = [dict[@"price"] intValue] - [dict[@"commission"] intValue];
    cell.cellLblTextExtra.text = [NSString stringWithFormat:@"%d(%@)",comm,dict[@"commission"]];
    
    if (self.istvReload) {
        UIImage *img = [self captureView:cell.contentView withRect:CGRectMake(0, 0, cell.contentView.frame.size.width, cell.contentView.frame.size.height)];
        UIImage *resizedtb = [UIImage imageWithCGImage:[img CGImage] scale:(img.scale * 2.0) orientation:(img.imageOrientation)];
        [_imageArray addObject:resizedtb];
    }
    
    
    return cell;
}

@end

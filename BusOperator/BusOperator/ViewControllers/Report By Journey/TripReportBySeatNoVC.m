//
//  TripReportBySeatNoVC.m
//  BusOperator
//
//  Created by Macbook Pro on 5/9/14.
//  Copyright (c) 2014 Ignite Software Solution. All rights reserved.
//

#import "TripReportBySeatNoVC.h"
#import "TripReportCell.h"
#import "JDStatusBarNotification.h"
#import "City.h"
#import <MessageUI/MessageUI.h>
#import "Reachability.h"

@interface TripReportBySeatNoVC () <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, UIPrintInteractionControllerDelegate, MFMailComposeViewControllerDelegate>


@property (strong, nonatomic) NSMutableArray* imageArray;
@property (assign, nonatomic) BOOL istvReload;

@property (strong, nonatomic) NSString* documentDirectoryFilename;

@property (strong, nonatomic) Reachability* reachability;
@property (nonatomic) BOOL reachable;

@property (strong, nonatomic) IBOutlet UILabel *lblTripName;
@property (strong, nonatomic) IBOutlet UILabel *lblTripDate;
@property (strong, nonatomic) IBOutlet UILabel *lblBusNo;
@property (strong, nonatomic) IBOutlet UILabel *lblTripTime;
@property (strong, nonatomic) IBOutlet UIView *bkgInfoView;
@property (strong, nonatomic) IBOutlet UILabel *lblTotal;
@property (strong, nonatomic) IBOutlet UIView *tbHeaderView;

@property (strong, nonatomic) IBOutlet UILabel *lblTitleSeatno;
@property (strong, nonatomic) IBOutlet UILabel *lblTitlePerson;
@property (strong, nonatomic) IBOutlet UILabel *lblTitleSoldby;
@property (strong, nonatomic) IBOutlet UILabel *lblTitleUnitprice;
@property (strong, nonatomic) IBOutlet UILabel *lblTitleTransactionno;
@property (strong, nonatomic) IBOutlet UITableView *tbSeatReport;
@property (strong, nonatomic) IBOutlet UIView *viewTotal;
@property (strong, nonatomic) IBOutlet UILabel *lblDeparturedate;

@property (weak, nonatomic) IBOutlet UILabel *lblTitleTrip;
@property (weak, nonatomic) IBOutlet UILabel *lblTitleBusno;
@property (weak, nonatomic) IBOutlet UILabel *lblTitleDate;
@property (weak, nonatomic) IBOutlet UILabel *lblDepartureDate;
@property (weak, nonatomic) IBOutlet UILabel *lblTitleTime;
@property (weak, nonatomic) IBOutlet UILabel *lbltitleCom;


@end

@implementation TripReportBySeatNoVC

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
    
    self.title = @"Trip Report By Seat";
    
    [self addDashedBorder:_bkgInfoView];
    
    _imageArray = [[NSMutableArray alloc] init];
    
    UIButton *righBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    righBtn.frame = CGRectMake(0, 0, 50, 50);
//    [filter setBackgroundImage:[UIImage imageNamed:@"filters"] forState:UIControlStateNormal];
    [righBtn setTitleColor:[UIColor colorWithRed:0.0f/255.0f green:122.0f/255.0f blue:255.0f/255.0f alpha:1] forState:UIControlStateNormal];
    
    [righBtn setTitle:@"Print" forState:UIControlStateNormal];
    [righBtn addTarget:self action:@selector(printOnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc] initWithCustomView:righBtn];
    
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:rightBarBtn, nil]];
    
    _lblTotal.text = @"10000 Ks";
    
    self.reachability = [Reachability reachabilityForInternetConnection];
    [self.reachability startNotifier];
    self.reachable = [self.reachability currentReachabilityStatus];
    
    _lblTitleSeatno.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblTitleSeatno.text = @"ခံုု နံပါတ္";
    
    _lblTitlePerson.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblTitlePerson.text = @"၀ယ္သူ";
    
    _lblTitleSoldby.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblTitleSoldby.text = @"ေရာင္းသူ";
    
    _lblTitleUnitprice.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblTitleUnitprice.text = @"တန္ဖိုုး";
    
    _lblTitleTransactionno.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblTitleTransactionno.text = @"အေရာင္း နံပါတ္စဥ္";
    
    _lblTripName.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblTripDate.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblTripTime.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblBusNo.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblDeparturedate.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    
    _lblTripName.text = _dataToPass[@"tripName"];
    _lblTripDate.text = _dataToPass[@"tripDate"];
    _lblTripTime.text = _dataToPass[@"tripTime"];
    _lblBusNo.text = _dataToPass[@"busno"];
    _lblDeparturedate.text = _dataToPass[@"departuredate"];
    
    _lblTitleDate.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblTitleDate.text = @"ေရာင္းသည့္ေန ့:";
    
    _lblTitleTrip.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblTitleTrip.text = @"ခရီးစဥ္ :";
    
    _lblTitleTime.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblTitleTime.text = @"ကားထြက္ခ်ိန္ :";
    
    _lblDepartureDate.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblDepartureDate.text = @"ကားထြက္မည့္ေန ့:";
    
    _lblTitleBusno.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    _lblTitleBusno.text = @"ကားနံပါတ္ :";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.reachable) {
        long totalAmt = 0;
        for (NSDictionary* dict in _dataFiller) {
            NSString* str = [NSString stringWithFormat:@"%@",dict[@"price"]];
            totalAmt += [str longLongValue];
        }
        _lblTotal.text = [NSString stringWithFormat:@"%ld Ks",totalAmt];
        
    }
    else {
        _lblTripName.text = @"Yangon - Mandalay";
        _lblTripDate.text = @"17-7-2014";
        _lblTripTime.text = @"09:30 AM";
        _lblBusNo.text = @"AA/1234";
        _lblDeparturedate.text = @"17-7-2014";
        
        NSDictionary* dict1 = @{@"seatno": @"1", @"person":@"Daw Aye", @"soldby":@"City Mart", @"unitprice":@"2000 Ks", @"transactionno":@"201451201"};
        NSDictionary* dict2 = @{@"seatno": @"4", @"person":@"U Ba", @"soldby":@"Agent 1", @"unitprice":@"2000 Ks", @"transactionno":@"201451202"};
        NSDictionary* dict3 = @{@"seatno": @"6", @"person":@"Daw Mya", @"soldby":@"Agent 1", @"unitprice":@"2000 Ks", @"transactionno":@"201451205"};
        NSDictionary* dict4 = @{@"seatno": @"8", @"person":@"Daw Hla", @"soldby":@"Agent 5", @"unitprice":@"2000 Ks", @"transactionno":@"201451219"};
        NSDictionary* dict5 = @{@"seatno": @"9", @"person":@"U Aye", @"soldby":@"Agent 2", @"unitprice":@"2000 Ks", @"transactionno":@"201451226"};
        NSDictionary* dict6 = @{@"seatno": @"1", @"person":@"Daw Aye", @"soldby":@"City Mart", @"unitprice":@"2000 Ks", @"transactionno":@"201451201"};
        NSDictionary* dict7 = @{@"seatno": @"4", @"person":@"U Ba", @"soldby":@"Agent 1", @"unitprice":@"2000 Ks", @"transactionno":@"201451202"};
        NSDictionary* dict8 = @{@"seatno": @"6", @"person":@"Daw Mya", @"soldby":@"Agent 1", @"unitprice":@"2000 Ks", @"transactionno":@"201451205"};
        NSDictionary* dict9 = @{@"seatno": @"8", @"person":@"Daw Hla", @"soldby":@"Agent 5", @"unitprice":@"2000 Ks", @"transactionno":@"201451219"};
        NSDictionary* dict10 = @{@"seatno": @"9", @"person":@"U Aye", @"soldby":@"Agent 2", @"unitprice":@"2000 Ks", @"transactionno":@"201451226"};
        
        _dataFiller = @[dict1,dict2,dict3,dict4,dict5,dict6,dict7,dict8,dict9,dict10];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addDashedBorder:(UIView*)view
{
    //border definitions
    CGFloat cornerRadius = 0;
    CGFloat borderWidth = 1;
    NSInteger dashPattern1 = 4;
    NSInteger dashPattern2 = 4;
    UIColor *lineColor = [UIColor blackColor];
    
    //drawing
    CGRect frame = view.bounds;
    
    CAShapeLayer *_shapeLayer = [CAShapeLayer layer];
    
    //creating a path
    CGMutablePathRef path = CGPathCreateMutable();
    
    //drawing a border around a view
    CGPathMoveToPoint(path, NULL, 0, frame.size.height - cornerRadius);
    CGPathAddLineToPoint(path, NULL, 0, cornerRadius);
    CGPathAddArc(path, NULL, cornerRadius, cornerRadius, cornerRadius, M_PI, -M_PI_2, NO);
    CGPathAddLineToPoint(path, NULL, frame.size.width - cornerRadius, 0);
    CGPathAddArc(path, NULL, frame.size.width - cornerRadius, cornerRadius, cornerRadius, -M_PI_2, 0, NO);
    CGPathAddLineToPoint(path, NULL, frame.size.width, frame.size.height - cornerRadius);
    CGPathAddArc(path, NULL, frame.size.width - cornerRadius, frame.size.height - cornerRadius, cornerRadius, 0, M_PI_2, NO);
    CGPathAddLineToPoint(path, NULL, cornerRadius, frame.size.height);
    CGPathAddArc(path, NULL, cornerRadius, frame.size.height - cornerRadius, cornerRadius, M_PI_2, M_PI, NO);
    
    //path is set as the _shapeLayer object's path
    _shapeLayer.path = path;
    CGPathRelease(path);
    
    _shapeLayer.backgroundColor = [[UIColor clearColor] CGColor];
    _shapeLayer.frame = frame;
    _shapeLayer.masksToBounds = NO;
    [_shapeLayer setValue:[NSNumber numberWithBool:NO] forKey:@"isCircle"];
    _shapeLayer.fillColor = [[UIColor clearColor] CGColor];
    _shapeLayer.strokeColor = [lineColor CGColor];
    _shapeLayer.lineWidth = borderWidth;
    _shapeLayer.lineDashPattern = [NSArray arrayWithObjects:[NSNumber numberWithInt:dashPattern1], [NSNumber numberWithInt:dashPattern2], nil];
    _shapeLayer.lineCap = kCALineCapRound;
    
    //_shapeLayer is added as a sublayer of the view, the border is visible
    [view.layer addSublayer:_shapeLayer];
    view.layer.cornerRadius = cornerRadius;
}

- (void)printOnClicked
{
    [self convertViewToImage];
    [self createPDF];
    
//    NSArray *activityItems = @[[NSData dataWithContentsOfFile:self.documentDirectoryFilename]];
//    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems
//                                                                                         applicationActivities:nil];
//    [self presentViewController:activityViewController animated:YES completion:NULL];
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Get Your Tickets" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Print", @"Email", @"Cancel",nil];
    
    
    actionSheet.delegate = self;
    [actionSheet showInView:self.view];
}

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [actionSheet  dismissWithClickedButtonIndex:2 animated:YES];
    
    if (buttonIndex == 1) {
        if ([MFMailComposeViewController canSendMail]) {
            
            NSData *data = [NSData dataWithContentsOfFile:self.documentDirectoryFilename];
            MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
            mailController.mailComposeDelegate = self;
            [mailController setToRecipients:[NSArray arrayWithObjects:nil]];
            //        [mailController setSubject:@"Check out this App"];
            
            [mailController addAttachmentData:data mimeType:@"application/pdf" fileName:@"MovieTickets.pdf"];
            
            [self presentViewController:mailController animated:YES completion:nil];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Mail Accounts" message:@"There are no mail accounts configured. You can add or create a mail account in Settings." delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
            [alert show];
        }
        
    }
    else if (buttonIndex == 0)
    {
        NSData *data = [NSData dataWithContentsOfFile:self.documentDirectoryFilename];
        
        UIPrintInteractionController *pic = [UIPrintInteractionController sharedPrintController];
        if(pic && [UIPrintInteractionController canPrintData:data] ) {
            pic.delegate = self;
            //            UIPrintInfo *printInfo = [UIPrintInfo printInfo];
            //            printInfo.outputType = UIPrintInfoOutputGeneral;
            //            printInfo.jobName = [path lastPathComponent];
            //            printInfo.duplex = UIPrintInfoDuplexLongEdge;
            //            pic.printInfo = printInfo;
            pic.showsPageRange = YES;
            pic.printingItem = data;
            void (^completionHandler)(UIPrintInteractionController *, BOOL, NSError *) = ^(UIPrintInteractionController *pic, BOOL completed, NSError *error) {
                //self.content = nil;
                if (!completed && error) {
                    NSLog(@"FAILED! due to error in domain %@ with error code %ld", error.domain, (long)error.code);
                }
            };
            //            [pic presentAnimated:YES completionHandler:completionHandler];
            //            [pic presentFromRect:self.view.frame inView:self.view animated:YES completionHandler:completionHandler];
            [pic presentFromBarButtonItem:self.navigationItem.rightBarButtonItem animated:YES completionHandler:completionHandler];
        }
        
    }
    
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [controller dismissViewControllerAnimated:YES completion:nil];
}



- (void)convertViewToImage
{
    [_imageArray removeAllObjects];
    UIImage *infoView = [self captureView:_bkgInfoView withRect:CGRectMake(0, 0, _bkgInfoView.frame.size.width, _bkgInfoView.frame.size.height)];
    UIImage *tbHearder = [self captureView:_tbHeaderView withRect:CGRectMake(0, 0, _tbHeaderView.frame.size.width, _tbHeaderView.frame.size.height)];
    
    UIImage *totalView = [self captureView:_viewTotal withRect:CGRectMake(0, 0, _viewTotal.frame.size.width, _viewTotal.frame.size.height)];
    
    UIImage *resizedInfo = [UIImage imageWithCGImage:[infoView CGImage] scale:(infoView.scale * 2.0) orientation:(infoView.imageOrientation)];
    [_imageArray addObject:resizedInfo];
    UIImage *resizedHeader = [UIImage imageWithCGImage:[tbHearder CGImage] scale:(tbHearder.scale * 2.0) orientation:(tbHearder.imageOrientation)];
    [_imageArray addObject:resizedHeader];
    
    self.istvReload = YES;
    for (int i = 0; i < _dataFiller.count; i++) {
        NSIndexPath *indexP = [NSIndexPath indexPathForRow:i inSection:0];
        [self tableView:_tbSeatReport cellForRowAtIndexPath:indexP];
    }
    self.istvReload = NO;
    UIImage *resizedtotalView = [UIImage imageWithCGImage:[totalView CGImage] scale:(totalView.scale * 2.0) orientation:(totalView.imageOrientation)];
    [_imageArray addObject:resizedtotalView];

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

- (UIImage *)renderScrollViewToImage
{
    UIImage* image = nil;
    
    UIGraphicsBeginImageContext(_tbSeatReport.contentSize);
    {
        CGPoint savedContentOffset = _tbSeatReport.contentOffset;
        CGRect savedFrame = _tbSeatReport.frame;
        
        _tbSeatReport.contentOffset = CGPointZero;
        _tbSeatReport.frame = CGRectMake(0, 0, _tbSeatReport.contentSize.width, _tbSeatReport.contentSize.height);
        
        [_tbSeatReport.layer renderInContext: UIGraphicsGetCurrentContext()];
        image = UIGraphicsGetImageFromCurrentImageContext();
        
        _tbSeatReport.contentOffset = savedContentOffset;
        _tbSeatReport.frame = savedFrame;
    }
    UIGraphicsEndImageContext();
    
    return image;
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
    NSString* cellid = @"tripReportBySeatNoCell";
    TripReportCell* cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    
    NSDictionary* dict = _dataFiller[indexPath.row];
    
    cell.cellLblDate.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    cell.cellLblTotalSeat.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    cell.cellLblTotalSales.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    cell.cellLblUnitPrice.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    cell.cellLblTransactionNo.font = [UIFont fontWithName:@"Zawgyi-One" size:14.0f];
    
    if (self.reachable) {
        cell.cellLblDate.text = dict[@"seat_no"];
        cell.cellLblTotalSeat.text = dict[@"customer_name"];
        cell.cellLblTotalSales.text = dict[@"agent_name"];
        cell.cellLblUnitPrice.text = [NSString stringWithFormat:@"%@",dict[@"price"]];
        cell.cellLblTransactionNo.text = [NSString stringWithFormat:@"%@",dict[@"ticket_no"]];
        int comPrice = [dict[@"price"] intValue] - [dict[@"commission"] intValue];
        cell.cellLblTextExtra.text = [NSString stringWithFormat:@"%d(%@)",comPrice,dict[@"commission"]];
    }
    else {
        cell.cellLblDate.text = dict[@"seatno"];
        cell.cellLblTotalSeat.text = dict[@"person"];
        cell.cellLblTotalSales.text = dict[@"soldby"];
        cell.cellLblUnitPrice.text = dict[@"unitprice"];
        cell.cellLblTransactionNo.text = dict[@"transactionno"];

    }
    
    if (self.istvReload) {
        UIImage *img = [self captureView:cell.contentView withRect:CGRectMake(0, 0, cell.contentView.frame.size.width, cell.contentView.frame.size.height)];
        UIImage *resizedtb = [UIImage imageWithCGImage:[img CGImage] scale:(img.scale * 2.0) orientation:(img.imageOrientation)];
        [_imageArray addObject:resizedtb];
    }

    
    return cell;
}


@end

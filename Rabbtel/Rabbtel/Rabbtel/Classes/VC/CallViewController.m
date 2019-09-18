//
//  CallViewController.m
//  Rabbtel
//
//  Created by WangYing on 2018/7/21.
//  Copyright © 2018 Teleclub. All rights reserved.
//

#import "AppDelegate.h"
#import "CallViewController.h"
#import "ContactsViewController.h"
#import "LocalAccessNumberViewController.h"
#import "CallHistoryTableViewCell.h"
#import "CallRecord.h"
#import "Util.h"
#import "AFNetworking.h"
#import "Constants.h"

#import <CoreTelephony/CTCallCenter.h>
#import <CoreTelephony/CTCall.h>

@interface CallViewController () <ContactsViewControllerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray *localAccessNumbers;
@property (nonatomic, strong) CTCallCenter *objCallCenter;
@property (nonatomic, strong) NSDate* startTime;
@property (nonatomic, strong) NSDate* endTime;
@property (strong, nonatomic) NSMutableArray *callHistoryArray;

@end

@implementation CallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.localAccessNumbers = [NSArray arrayWithObjects:
                               @"647-258-9522",
                               @"519-489-1258",
                               @"519-804-1500",
                               @"778-785-2088",
                               @"403-775-9675",
                               @"780-669-4412",
                               @"306-206-0428",
                               @"306-500-0282",
                               @"418-263-4479",
                               @"213-289-5005",
                               @"206-582-0797",
                               nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(CallStateDidChange:) name:@"CTCallStateDidChange" object:nil];
    self.objCallCenter = [[CTCallCenter alloc] init];
    self.objCallCenter.callEventHandler = ^(CTCall* call) {
        NSDictionary *dict = [NSDictionary dictionaryWithObject:call.callState
                                                         forKey:@"callState"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CTCallStateDidChange" object:nil userInfo:dict];
    };
    
    self.startTime = nil;
    self.endTime = nil;
    
    self.callHistoryArray = [NSMutableArray array];
    
    [self loadCallHistory];
    
    [self getBalance];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tfAccessNumber setText:[self.localAccessNumbers objectAtIndex:[Util getLocalAccessNumber]]];
}

- (void)CallStateDidChange:(NSNotification *)notification {
    NSString *callInfo = [[notification userInfo] objectForKey:@"callState"];
    
    if([callInfo isEqualToString: CTCallStateDialing])
    {
        //The call state, before connection is established, when the user initiates the call.
        NSLog(@"Call is dailing");
        [self unblockingUser];
    }

    if([callInfo isEqualToString: CTCallStateIncoming])
    {
        //The call state, before connection is established, when a call is incoming but not yet answered by the user.
        NSLog(@"Call is Coming");
    }
    
    if([callInfo isEqualToString: CTCallStateConnected])
    {
        //The call state when the call is fully established for all parties involved.
        NSLog(@"Call Connected");
        self.startTime = [NSDate date];
    }
    
    if([callInfo isEqualToString: CTCallStateDisconnected])
    {
        //The call state Ended.
        NSLog(@"Call Ended");
        [self blockingUser];
        self.endTime = [NSDate date];
        
        if (self.startTime != nil) {
            NSTimeInterval diff = [self.endTime timeIntervalSinceDate:self.startTime];
            if (diff >= 60 && [Util isTopupAvailable] == NO) {
                [self setCanTopup];
                [Util setTopupAvailable:@"1"];
            }
        }
        
        self.startTime = nil;
        self.endTime = nil;
    }
}

- (IBAction)onTriggerPhoneNumber:(id)sender {
    [self.tfCallNumber endEditing:YES];
}

- (IBAction)onContacts:(id)sender {
    ContactsViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"contactsVC"];
    vc.delegate = self;
    [self presentViewController:vc animated:NO completion:nil];
}

- (IBAction)onAccessNumber:(id)sender {
    LocalAccessNumberViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"localVC"];
    [self presentViewController:vc animated:NO completion:nil];
}

- (IBAction)onCall:(id)sender {
    NSString *cardNumber = [Util getRealPhoneNumber:self.tfAccessNumber.text];
    NSString *phoneNumber = [Util getRealPhoneNumber:self.tfCallNumber.text];
    
    [self callWithNumber:phoneNumber withAccessNumber:cardNumber];
    [self addCallRecord:phoneNumber withAccessNumber:cardNumber];
}

- (void)callWithNumber:(NSString*)phoneNumber withAccessNumber:(NSString*)accessNumber {
    if ([accessNumber isEqualToString:@""] || [phoneNumber isEqualToString:@""]) {
        return;
    }
    
    NSString *callNumber = [NSString stringWithFormat:@"tel://%@,%@", accessNumber, phoneNumber];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callNumber]];
}

- (void)selectContactNumber:(NSString*)number {
    [self.tfCallNumber setText:number];
}

- (void)getBalance {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    
    NSString *apiUrl = [NSString stringWithFormat:@"%@%@", BASE_URL_PRODUCTION, API_BALANCE];
    
    NSDictionary *params = @{
                             PARAM_TOKEN        : [Util getToken],
                             PARAM_IMEI         : [[[UIDevice currentDevice] identifierForVendor] UUIDString],
                             PARAM_SIM          : [Util getAccount].phone,
                             PARAM_TYPE         : @"ios"
                             };
    [manager POST:apiUrl
       parameters:params
          success:^(NSURLSessionTask *task, id responseObject) {
              
              BOOL status = [[responseObject objectForKey:@"status"] boolValue];
              if (status) {
                  [Util setBalance:[responseObject[@"balance"] doubleValue]];
                  [self.lblBalance setText:[NSString stringWithFormat:@"Balance $%.2f", [Util getBalance]]];
              } else {
                  NSArray *res_data = (NSArray * )responseObject[@"messages"];
                  for (NSDictionary * message in res_data) {
                      [self presentAlert:@"" message:message[@"msg"]];
                      break;
                  }
              }
              
          } failure:^(NSURLSessionTask *operation, NSError *error) {
              NSString *str = [[NSString alloc] initWithData:error.userInfo[@"com.alamofire.serialization.response.error.data"] encoding:NSUTF8StringEncoding];
              NSLog(@"%@",str);
          }
     ];
}

- (void)blockingUser {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    
    NSString *apiUrl = [NSString stringWithFormat:@"%@%@", BASE_URL_PRODUCTION, API_BLOCKING];
    
    NSDictionary *params = @{
                             PARAM_TOKEN        : [Util getToken],
                             PARAM_PHONE        : [Util getAccount].phone,
                             PARAM_IMEI         : [[[UIDevice currentDevice] identifierForVendor] UUIDString],
                             PARAM_SIM          : [Util getAccount].phone,
                             PARAM_TYPE         : @"ios"
                             };
    [manager POST:apiUrl
       parameters:params
          success:^(NSURLSessionTask *task, id responseObject) {
          } failure:^(NSURLSessionTask *operation, NSError *error) {
          }
     ];
}

- (void)unblockingUser {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    
    NSString *apiUrl = [NSString stringWithFormat:@"%@%@", BASE_URL_PRODUCTION, API_UNBLOCKING];
    
    NSDictionary *params = @{
                             PARAM_TOKEN        : [Util getToken],
                             PARAM_PHONE        : [Util getAccount].phone,
                             PARAM_IMEI         : [[[UIDevice currentDevice] identifierForVendor] UUIDString],
                             PARAM_SIM          : [Util getAccount].phone,
                             PARAM_TYPE         : @"ios"
                             };
    [manager POST:apiUrl
       parameters:params
          success:^(NSURLSessionTask *task, id responseObject) {
          } failure:^(NSURLSessionTask *operation, NSError *error) {
          }
     ];
}

- (void)setCanTopup {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    
    NSString *apiUrl = [NSString stringWithFormat:@"%@%@", BASE_URL_PRODUCTION, API_SET_CANTOPUP];
    
    NSDictionary *params = @{
                             PARAM_TOKEN        : [Util getToken],
                             PARAM_IMEI         : [[[UIDevice currentDevice] identifierForVendor] UUIDString],
                             PARAM_SIM          : [Util getAccount].phone,
                             PARAM_TYPE         : @"ios"
                             };
    [manager POST:apiUrl
       parameters:params
          success:^(NSURLSessionTask *task, id responseObject) {
          } failure:^(NSURLSessionTask *operation, NSError *error) {
          }
     ];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.callHistoryArray.count;
}

#pragma mark - UITableView Delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CallHistoryTableViewCell* cell = (CallHistoryTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"callHistoryCell" forIndexPath:indexPath];
    if (!cell) {
        cell = (CallHistoryTableViewCell*)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"callHistoryCell"];
    }
    
    CallRecord *record = (CallRecord*)[self.callHistoryArray objectAtIndex:indexPath.row];
    [cell.lblPhoneNumber setText:record.phoneNumber];
    [cell.lblCalledTime setText:record.calledTime];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CallRecord *record = (CallRecord*)[self.callHistoryArray objectAtIndex:indexPath.row];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:record.phoneNumber message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *callAction = [UIAlertAction actionWithTitle:@"Call" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self callWithNumber:record.phoneNumber withAccessNumber:record.accessNumber];
        [self updateCallRecord:indexPath.row];
        
    }];
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self removeCallReocrd:indexPath.row];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:callAction];
    [alert addAction:deleteAction];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

// load all call history from core data
- (void)loadCallHistory {
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = appDelegate.persistentContainer.viewContext;
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"CallRecords" inManagedObjectContext:context];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request error:&error];
    
    self.callHistoryArray = [NSMutableArray array];
    if (objects.count != 0) {
        for (int i = 0; i < objects.count; i ++) {
            CallRecord *callRecord = [CallRecord initWithObject:objects[i]];
            [self.callHistoryArray addObject:callRecord];
        }
    }
    
    [self.callHistoryArray sortUsingComparator:^NSComparisonResult(CallRecord *obj1, CallRecord *obj2) {
        return [obj2.calledTime compare:obj1.calledTime];
    }];

    [self.tblCallHistory reloadData];
}

- (void)addCallRecord:(NSString*)phoneNumber withAccessNumber:(NSString*)accessNumber {
    CallRecord* record = [[CallRecord alloc] init];
    record.phoneNumber = phoneNumber;
    record.accessNumber = accessNumber;
    record.calledTime = [Util getDateString:[NSDate date] withFormat:@"MMM dd, yyyy    H:mm"];
    [self.callHistoryArray insertObject:record atIndex:0];
    
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = appDelegate.persistentContainer.viewContext;
    
    NSManagedObject *callRecord = [NSEntityDescription insertNewObjectForEntityForName:@"CallRecords" inManagedObjectContext:context];
    [callRecord setValue:record.phoneNumber forKey:@"phone_number"];
    [callRecord setValue:record.accessNumber forKey:@"access_number"];
    [callRecord setValue:record.calledTime forKey:@"called_time"];
    
    NSError *error;
    [context save:&error];
    
    [self.tblCallHistory reloadData];
}

- (void)updateCallRecord:(NSInteger)position {
    CallRecord *record = (CallRecord*)[self.callHistoryArray objectAtIndex:position];
    record.calledTime = [Util getDateString:[NSDate date] withFormat:@"MMM dd, yyyy    H:mm"];
    [self.callHistoryArray setObject:record atIndexedSubscript:position];
    
    [self.callHistoryArray sortUsingComparator:^NSComparisonResult(CallRecord *obj1, CallRecord *obj2) {
        return [obj2.calledTime compare:obj1.calledTime];
    }];
    
    [self.tblCallHistory reloadData];
}

- (void)removeCallReocrd:(NSInteger)position {
    CallRecord *record = (CallRecord*)[self.callHistoryArray objectAtIndex:position];
    [self.callHistoryArray removeObjectAtIndex:position];
    
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = appDelegate.persistentContainer.viewContext;
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"CallRecords" inManagedObjectContext:context];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"called_time like %@", record.calledTime];
    [fetchRequest setEntity:entityDesc];
    [fetchRequest setPredicate:predicate];
    
    NSError *error;
    NSArray *items = [context executeFetchRequest:fetchRequest error:&error];
    
    for (NSManagedObject *managedObject in items) {
        [context deleteObject:managedObject];
    }
    
    [self.tblCallHistory reloadData];
}

@end

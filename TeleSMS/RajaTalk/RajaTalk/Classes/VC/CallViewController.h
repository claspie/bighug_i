//
//  CallViewController.h
//  RajaTalk
//
//  Created by WangYing on 2018/7/21.
//  Copyright © 2018 Teleclub. All rights reserved.
//

#import "BaseViewController.h"

@interface CallViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UITextField *tfCallNumber;
@property (weak, nonatomic) IBOutlet UITextField *tfAccessNumber;
@property (strong, nonatomic) IBOutlet UILabel *lblBalance;
@property (strong, nonatomic) IBOutlet UITableView *tblCallHistory;

@end

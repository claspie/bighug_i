//
//  CallHistoryTableViewCell.h
//  Rabbtel
//
//  Created by Wang Xin on 2019/4/24.
//  Copyright © 2019 Teleclub. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CallHistoryTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *lblPhoneNumber;
@property (strong, nonatomic) IBOutlet UILabel *lblCalledTime;


@end

NS_ASSUME_NONNULL_END

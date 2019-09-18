//
//  LocalAccessNumberTableViewCell.h
//  Rabbtel
//
//  Created by WangYing on 2018/9/4.
//  Copyright © 2018 Teleclub. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LocalAccessNumberTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *lblCellTitle;
@property (strong, nonatomic) IBOutlet UIImageView *ivCellImage;

- (void)setCellTitle:(NSString*)title;
- (void)setCellChecked:(BOOL)checked;

@end

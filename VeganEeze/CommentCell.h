//
//  CommentCell.h
//  VeganEeze
//
//  Created by Brandon Ruger on 8/24/15.
//  Copyright (c) 2015 Brandon Ruger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentCell : UITableViewCell

{
    IBOutlet UILabel *username;
    IBOutlet UITextView *comment;
}

- (void)updateCellWithComments:(NSString*)usersScreenName userComment:(NSString*)usersComment;

@end

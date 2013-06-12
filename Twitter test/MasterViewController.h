//
//  MasterViewController.h
//  Twitter test
//
//  Created by Администратор on 01.06.13.
//  Copyright (c) 2013 Администратор. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MasterViewController : UITableViewController {
    NSArray *tweets; // массив для хранения твитов
}

// загрузка твитов
-(void)fetchTweets;

// загрузка дополнительных твитов
-(IBAction)moretweet:(id)sender;

@end
//
//  DetailViewController.h
//  Twitter test
//
//  Created by Администратор on 01.06.13.
//  Copyright (c) 2013 Администратор. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController {
    IBOutlet UIImageView *profileImage; // картинка пользователя
    IBOutlet UILabel *nameLabel; // имя польщователя
    IBOutlet UILabel *tweetLabel; // текст твита
}

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end

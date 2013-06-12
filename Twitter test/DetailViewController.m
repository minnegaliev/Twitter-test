//
//  DetailViewController.m
//  Twitter test
//
//  Created by Администратор on 01.06.13.
//  Copyright (c) 2013 Администратор. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()
- (void)configureView;
@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view
        [self configureView];
    }
}

- (void)configureView
{
    if (self.detailItem) {
        NSDictionary *tweet = self.detailItem; // твит целиком
        NSString *name = [[tweet objectForKey:@"user"] objectForKey:@"name"]; // имя пользователя
        NSString *text = [tweet objectForKey:@"text"]; // текст твита
        tweetLabel.numberOfLines = 0;
        tweetLabel.text = text;
        nameLabel.text = name;
        // получение картинки пользователя
        NSString *imageUrl = [[tweet objectForKey:@"user"] objectForKey:@"profile_image_url"]; 
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
        profileImage.image = [UIImage imageWithData:data];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end

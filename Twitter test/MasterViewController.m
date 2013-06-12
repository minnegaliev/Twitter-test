//
//  MasterViewController.m
//  Twitter test
//
//  Created by Администратор on 01.06.13.
//  Copyright (c) 2013 Администратор. All rights reserved.
//

#import "MasterViewController.h"

#import "DetailViewController.h"

@interface MasterViewController () {
    NSMutableArray *_objects;
}
@end

@implementation MasterViewController

// количество загружаемых твитов по умолчанию = 30
int count = 30;

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self fetchTweets];
    
    // обновление при оттягивании вниз, "pull to refresh"
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    [refresh addTarget:self
        action:@selector(refreshView:)
        forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresh;
    [self.refreshControl addTarget:self
    action:@selector(refreshView:)
    forControlEvents:UIControlEventValueChanged];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

// получить твиты
- (void)fetchTweets
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        // конвертация количества из числового значения в строковое
        NSString* strcount = [NSString stringWithFormat:@"%d", count];
        
        // ссылка на json пользователя flatsoft и на количество твитов равное текущему значению count
        NSString* url = [NSString stringWithFormat:@"%@=%@", @"https://api.twitter.com/1/statuses/user_timeline.json?include_entities=true&include_rts=true&screen_name=flatsoft&count", strcount];
        
        NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString: url]];
                                                    
        NSError* error;
        
        // парсинг json
        tweets = [NSJSONSerialization JSONObjectWithData:data
                                                 options:kNilOptions
                                                   error:&error];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return tweets.count; // количество строк в tableview равно количеству загружаемых твитов
}

// вывод твитов в tableview
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TweetCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *tweet = [tweets objectAtIndex:indexPath.row]; // берем отдельную строку (твит) из json
    NSString *text = [tweet objectForKey:@"text"]; // получаем текст твита
    NSString *name = [[tweet objectForKey:@"user"] objectForKey:@"name"]; // получаем имя пользователя
    NSString *time = [tweet objectForKey:@"created_at"]; // получаем дату и время твита
    
    cell.textLabel.text = text; // выводим в ячейку текст твита
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@, %@", name, time];// выводим в ячейку автора, дату и время
    
    // получаем ссылку на картинку пользователя
    NSString *imageUrl = [[tweet objectForKey:@"user"] objectForKey:@"profile_image_url"]; 
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
    
    cell.imageView.image = [UIImage imageWithData:data]; // добавляем картинку в ячейку

    return cell;
}


// открыть отдельный твит на весь экран
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showTweet"]) {
        
        NSInteger row = [[self tableView].indexPathForSelectedRow row];
        NSDictionary *tweet = [tweets objectAtIndex:row];
        
        DetailViewController *detailController = segue.destinationViewController;
        detailController.detailItem = tweet;
    }
}

// обновление твитов, pull to refresh
-(void)refreshView:(UIRefreshControl *)refresh
{
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refreshing data..."];
    
    [self fetchTweets]; // обновление твитов
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d, h:mm a"]; // дата и время обновления
        NSString *lastUpdated = [NSString stringWithFormat:@"Last updated on %@",
                                [formatter stringFromDate:[NSDate date]]]; // запись о последнем обновлении
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:lastUpdated];
    [refresh endRefreshing]; 
}

// загрузка еще 30 твитов при нажатии на кнопку внизу
-(IBAction)moretweet:(id)sender
{
    count = count+30; // +30 твитов к текущему количеству
    [self fetchTweets]; // обновление (подгрузка) твитов
}

@end

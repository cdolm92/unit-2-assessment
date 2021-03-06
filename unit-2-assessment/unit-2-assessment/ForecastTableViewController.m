//
//  ForecastTableViewController.m
//  unit-2-assessment
//
//  Created by Christella on 10/17/15.
//  Copyright © 2015 Michael Kavouras. All rights reserved.
//

#import "ForecastTableViewController.h"
#import "WeatherPost.h"
#import "APIManager.h"
#import "WeatherTableViewCell.h"
#import "ForecastDetailViewController.h"
#import <AFNetworking/AFNetworking.h>

@interface ForecastTableViewController ()

@property (nonatomic) NSMutableArray *forecastResults;

@end

@implementation ForecastTableViewController


-(void)fetchForecastData {
  
    
     NSURL *urlString = [NSURL URLWithString:@"https://api.forecast.io/forecast/31706003c47eda54bf750cbd568bc9f5/0.6667,90.5500"];
    
  //   NSURL *urlString = [NSURL URLWithString:@"https://api.forecast.io/forecast/31706003c47eda54bf750cbd568bc9f5/25.7753,80.2089"];
    
    
    
    
//     AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    
    // fetch data from the instagram endpoint and print json response
    [APIManager GETRequestWithURL:urlString completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        NSArray *dailyForecast = json[@"daily"][@"data"];
        
        // reset my array
        self.forecastResults = [[NSMutableArray alloc] init];
        
        // loop through all json posts
        for (NSDictionary *daily in dailyForecast) {
            
            // create new post from json
            WeatherPost *post = [[WeatherPost alloc] initWithJSON:daily];
            
            // add post to array
            [self.forecastResults addObject:post];
        }
        
        [self.tableView reloadData];
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fetchForecastData];
 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.forecastResults.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WeatherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ForecastCellIdentifier" forIndexPath:indexPath];
    
    WeatherPost *post = self.forecastResults[indexPath.row];
    
    cell.minTempLabel.text = [NSString stringWithFormat:@"%li", (long)post.minTemp];
    cell.maxTempLabel.text = [NSString stringWithFormat:@"%li", (long)post.maxTemp];
    cell.dayTempLabel.text = [NSString stringWithFormat:@"%@",post.weatherDay];
    
    NSString *imageName = [post.icon lowercaseString];
    
    cell.weatherIconImage.image = [UIImage imageNamed:imageName];
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    NSLog(@"preparing...");
    
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    
    WeatherPost *post = self.forecastResults[indexPath.row];
    
    NSString *chanceOfRainPer = [NSString stringWithFormat:@"%@", post.chanceOfRain];
    NSString *humidityPer = [NSString stringWithFormat:@"%@", post.humid];
    NSString *mphOfWind = [NSString stringWithFormat:@"%@", post.windSpeed];
    NSString *weatherDetail = [NSString stringWithFormat:@"%@", post.forcastDetail];
    
    NSString *imageName = [post.icon lowercaseString];
    UIImage *image =[UIImage imageNamed:imageName];

    
    ForecastDetailViewController *detailViewController = segue.destinationViewController;
    detailViewController.chanceOfRain = chanceOfRainPer;
    detailViewController.humidity = humidityPer;
    detailViewController.windMPH = mphOfWind;
    detailViewController.weatherDetails = weatherDetail;
    detailViewController.icon = image;
    
}

- (NSString *)objectForIndexPath:(NSIndexPath *)indexPath {
   
        
        return self.forecastResults[indexPath.row];
   
}









@end

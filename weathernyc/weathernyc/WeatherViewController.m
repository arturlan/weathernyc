//
//  WeatherViewController.m
//  weathernyc
//
//  Created by Artur Lan on 11/24/16.
//  Copyright © 2016 Artur Lan. All rights reserved.
//

#import "WeatherViewController.h"
#import "ForecastTableViewCell.h"
#import "Location.h"
#import <AFNetworking/AFNetworking.h>
#import "APIManager.h"
#import "WeatherForecastResult.h"
#import "NSDate+HumanReadable.h"

@interface WeatherViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSMutableArray *forecasts;
@property (nonatomic) Location *location;
@property (weak, nonatomic) IBOutlet UITextField *latitudeLabel;
@property (weak, nonatomic) IBOutlet UITextField *longitudeLabel;
@end

@implementation WeatherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.dataSource = self;
    [self.tableView reloadData];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)getData:(UIButton *)sender {
    
    
    if (![self.latitudeLabel.text isEqualToString:@""] || ![self.longitudeLabel.text isEqualToString:@""]) {
        
        self.location = [[Location alloc]init];
        
        self.location.latitude = [self.latitudeLabel.text integerValue];
        self.location.longitude = [self.longitudeLabel.text integerValue];
        
        [self.location saveUserLocation];
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }
}

- (IBAction)convertTemperature:(UIButton *)sender {
    
}


- (void) viewWillAppear:(BOOL)animated{
    
    [self setUpCustomTableViewCells];
    
    self.location = [[Location alloc]init];
    [self.location loadUserLocation];
    
    NSLog(@"latitude: %ld, longitude: %ld", self.location.latitude, self.location.longitude);
    
    [APIManager GETWeatherForecastWithLatitude:self.location.latitude AndLongitude:self.location.longitude CompletionHandler:^(id results) {
        
        if ([results isKindOfClass:[NSDictionary class]]) {
            
            self.forecasts = [[NSMutableArray alloc]init];
            
            NSArray *searchResults = results[@"daily"][@"data"];
            
            
            for (NSDictionary *result in searchResults){
                
                WeatherForecastResult *forecast = [[WeatherForecastResult alloc] initWithJSON:result];
                
                [self.forecasts addObject:forecast];
                
            }
            
            [self.tableView reloadData];
        }
        
        
    }];
    
    [self.tableView reloadData];
}


-(void)setUpCustomTableViewCells{
    
    UINib *nib = [UINib nibWithNibName:@"ForecastTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"ForecastCellIdentifier"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.forecasts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ForecastTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ForecastCellIdentifier" forIndexPath:indexPath];
    
    WeatherForecastResult *forecast = self.forecasts[indexPath.row];
    
    NSDate *date = [NSDate dateWithTimeIntervalSinceReferenceDate:forecast.dayOfWeek];
    cell.dayOfWeekLabel.text = [date weekdayName];
    
    cell.tempLabel.text = [NSString stringWithFormat:@"Low: %ld, High: %ld",forecast.tempMin, forecast.tempMax];
    cell.iconImageVIew.image = [UIImage imageNamed:forecast.imageName];
    
    return cell;
}


@end

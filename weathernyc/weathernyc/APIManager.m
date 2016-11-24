//
//  APIManager.m
//  weathernyc
//
//  Created by Artur Lan on 11/24/16.
//  Copyright © 2016 Artur Lan. All rights reserved.
//

#import "APIManager.h"
#import <AFNetworking/AFNetworking.h>
#define ForecastAPIKey @"https://api.forecast.io/forecast/8040fc5b15adaaafabbe7de9c3ff5458/"

@implementation APIManager




+ (void)GETWeatherForecastWithLatitude: (NSInteger)latitude
                          AndLongitude: (NSInteger)longitude
                     CompletionHandler:(void(^)(id results))completionHandler{
    
    NSString *urlString = [NSString stringWithFormat:@"%@%ld,%ld", ForecastAPIKey, latitude, longitude];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:urlString parameters:nil success:^(NSURLSessionTask *task, id responseObject) {
        
        completionHandler(responseObject);
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        
        NSLog(@"Error: %@", error);
        
    }];
    
    
}

@end

//
//  APIManager.h
//  weathernyc
//
//  Created by Artur Lan on 11/24/16.
//  Copyright © 2016 Artur Lan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APIManager : NSObject

+ (void)GETWeatherForecastWithLatitude: (NSInteger)latitude
                          AndLongitude: (NSInteger)longitude
                     CompletionHandler:(void(^)(id results))completionHandler;

@end

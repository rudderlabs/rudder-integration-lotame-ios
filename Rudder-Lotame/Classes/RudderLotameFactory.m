//
//  RudderLotameFactory.m
//  Rudder-Lotame
//
//  Created by Dhawal on 10/06/20.
//

#import "RudderLotameFactory.h"
#import "RudderLotameIntegration.h"
#import <Rudder/RSLogger.h>

@implementation RudderLotameFactory

static RudderLotameFactory *sharedInstance;

+ (instancetype)instance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (nonnull NSString *)key {
    return @"Lotame";
}

- (nonnull id<RSIntegration>)initiate:(nonnull NSDictionary *)config client:(nonnull RSClient *)client rudderConfig:(nonnull RSConfig *)rudderConfig {
    [RSLogger logDebug:@"Creating RudderIntegrationFactory"];
    return [[RudderLotameIntegration alloc] initWithConfig:config withAnalytics:client withRudderConfig:rudderConfig];
}

@end





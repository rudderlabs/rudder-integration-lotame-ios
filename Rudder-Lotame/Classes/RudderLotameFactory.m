//
//  RudderLotameFactory.m
//  Rudder-Lotame
//
//  Created by Dhawal on 10/06/20.
//

#import "RudderLotameFactory.h"
#import "RudderLotameIntegration.h"
#import "RudderLogger.h"

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

- (nonnull id<RudderIntegration>)initiate:(nonnull NSDictionary *)config client:(nonnull RudderClient *)client rudderConfig:(nonnull RudderConfig *)rudderConfig {
    [RudderLogger logDebug:@"Creating RudderIntegrationFactory"];
    return [[RudderLotameIntegration alloc] initWithConfig:config withAnalytics:client withRudderConfig:rudderConfig];
}

@end





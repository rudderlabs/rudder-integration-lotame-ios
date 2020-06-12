//
//  RudderLotameIntegration.h
//  Lotame
//
//  Created by Ruchira Moitra on 02/04/20.
//

#import <Foundation/Foundation.h>
#import <Rudder/Rudder.h>

NS_ASSUME_NONNULL_BEGIN

@interface RudderLotameIntegration : NSObject<RudderIntegration>

@property (nonatomic) BOOL sendEvents;

- (instancetype)initWithConfig:(NSDictionary *)config withAnalytics:(RudderClient *)client withRudderConfig:(RudderConfig*) rudderConfig;


@end

NS_ASSUME_NONNULL_END

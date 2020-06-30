//
//  RudderLotameIntegration.h
//  Lotame
//
//  Created by Dhawal on 10/06/20.
//

#import <Foundation/Foundation.h>
#import <Rudder/Rudder.h>

NS_ASSUME_NONNULL_BEGIN

@interface RudderLotameIntegration : NSObject<RSIntegration>

@property (nonatomic) BOOL sendEvents;

- (instancetype)initWithConfig:(NSDictionary *)config withAnalytics:(RSClient *)client withRudderConfig:(RSConfig*) rudderConfig;


@end

NS_ASSUME_NONNULL_END

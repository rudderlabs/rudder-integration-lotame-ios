//
//  RudderLotameFactory.h
//  Rudder-Lotame
//
//  Created by Dhawal on 10/06/20.
//

#import <Foundation/Foundation.h>
#import <Rudder/RudderIntegrationFactory.h>

NS_ASSUME_NONNULL_BEGIN

@interface RudderLotameFactory : NSObject<RudderIntegrationFactory>

+ (instancetype) instance;

@end

NS_ASSUME_NONNULL_END

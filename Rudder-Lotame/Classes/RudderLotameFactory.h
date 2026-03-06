//
//  RudderLotameFactory.h
//  Rudder-Lotame
//
//  Created by Dhawal on 10/06/20.
//

#import <Foundation/Foundation.h>
#import <Rudder/RSIntegrationFactory.h>

NS_ASSUME_NONNULL_BEGIN

@interface RudderLotameFactory : NSObject<RSIntegrationFactory>

+ (instancetype) instance;

@end

NS_ASSUME_NONNULL_END

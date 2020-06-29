//
//  LotameIntegration.h
//  Lotame
//
//  Created by Dhawal on 10/06/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LotameIntegration : NSObject

+ (id)getInstance:(NSDictionary *)fieldMappings withLogLevel:(int)logLevel;
+ (void)registerCallback:(void(^)(void))onSyncCallback;
- (void)syncDspUrls:(NSArray *)dspUrls withUserId:(NSString *)userId withForceSync:(Boolean)force;
- (void)syncBcpAndDspUrls:(NSString *)userId withBcpUrls:(NSArray *)bcpUrls withDspUrls:(NSArray *)dspUrls;
- (void)reset;
@end

NS_ASSUME_NONNULL_END

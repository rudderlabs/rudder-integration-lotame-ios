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
- (void)syncDspUrls:(NSArray *)dspUrls withUserId:(NSString *)userId;
- (void)processBcpUrls:(NSArray *)bcpUrls withDspUrls:(NSArray *)dspUrls withUserId:(NSString *)userId;
- (void)reset;
@end

NS_ASSUME_NONNULL_END

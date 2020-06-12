//
//  LotameStorage.h
//  Lotame
//
//  Created by Dhawal on 10/06/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LotameStorage : NSObject

+ getInstance;
- (long)getLastSyncTime;
- (void)setLastSyncTime:(long)syncTime;
- (void)reset;
@end

NS_ASSUME_NONNULL_END

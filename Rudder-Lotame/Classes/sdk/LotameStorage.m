//
//  LotameStorage.m
//  Lotame
//
//  Created by Dhawal on 10/06/20.
//

#import "LotameStorage.h"

static LotameStorage* sharedInstance;

@implementation LotameStorage

+ (id)getInstance {
    if (sharedInstance == nil) {
        sharedInstance = [[self alloc] init];
    }
    return sharedInstance;
}

NSString *const RudderPrefsKey = @"rl_lotame";
NSString *const LotameLastSyncTime = @"rl_lotame_last_sync";

- (void)setLastSyncTime:(long)syncTime {
    [[NSUserDefaults standardUserDefaults] setValue:[[NSNumber alloc] initWithLong:syncTime] forKey:LotameLastSyncTime];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (long)getLastSyncTime {
    NSNumber *syncTime = [[NSUserDefaults standardUserDefaults] valueForKey:LotameLastSyncTime];
    if(syncTime == nil) {
        return -1;
    } else {
        return [syncTime longValue];
    }
}

- (void)reset {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:LotameLastSyncTime];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end

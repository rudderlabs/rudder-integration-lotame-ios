//
//  LotameIntegration.m
//  Lotame
//
//  Created by Dhawal on 10/06/20.
//

#import "LotameIntegration.h"
#import "LotameStorage.h"
#import "LotameLogger.h"

static NSDictionary* mappings;
static LotameStorage* storage;
static dispatch_block_t callback;
static LotameIntegration* sharedInstance;
static dispatch_queue_t requestQueue;
static long SYNC_INTERVAL = 60 * 60 * 24 * 7; // 7 days in milliseconds



@implementation LotameIntegration

+ (id)getInstance:(NSDictionary *)fieldMappings withLogLevel:(int)logLevel {
    if (sharedInstance == nil) {
        sharedInstance = [[self alloc] init];
    }
    if (requestQueue == nil) {
        requestQueue = dispatch_queue_create("lotameRequestQueue", DISPATCH_QUEUE_SERIAL);
    }
    mappings = fieldMappings;
    storage = [LotameStorage getInstance];
    [LotameLogger initiate:logLevel];
    return sharedInstance;
}

- (long)getCurrentTime {
    return [[[NSDate alloc] init] timeIntervalSince1970];
}

// figure out how to handle errors
- (void (^)(void)) getRequestBlock:(NSString *)url {
    return ^{
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
        [request setHTTPMethod:@"GET"];

        NSError *error = nil;
        NSHTTPURLResponse *response = nil;

        [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];

        int responseCode = (int) [response statusCode];
        if (responseCode < 400) {
            [LotameLogger logDebug:[NSString stringWithFormat:@"GET request to %@ returned a %d response", url, responseCode]];
        } else {
            [LotameLogger logError:[NSString stringWithFormat:@"GET request to %@ returned a %d response", url, responseCode]];
        }
    };
}

- (NSString *)compileUrl:(NSString *)url withUserId:(NSString *)userId withRandomValue:(NSString *)randomValue {
    NSString* replacePattern = @"{{%@}}";
    NSString *key, *value;
    
    // TODO : add exception handling
    url = [url stringByReplacingOccurrencesOfString:[NSString stringWithFormat:replacePattern, @"random"] withString:randomValue];
    if (userId != nil) {
        url = [url stringByReplacingOccurrencesOfString:[NSString stringWithFormat:replacePattern, @"userId"]
                                             withString:[userId stringByReplacingOccurrencesOfString:@" " withString:@"+"]];
    }
    if (mappings != nil) {
        for(key in mappings) {
            value = [mappings objectForKey:key];
            url = [url stringByReplacingOccurrencesOfString:[NSString stringWithFormat:replacePattern, key] withString:value];
        }
    }
    
    return url;
}

- (void)syncDspUrls:(nonnull NSArray *)dspUrls withUserId:(NSString *)userId {
    [LotameLogger logDebug:[[NSString alloc] initWithFormat:@"Syncing DSP Urls : %@", dspUrls]];
    [self processDspUrls:dspUrls withUserId:userId];
    
    // set last sync time
    [LotameLogger logDebug:@"Updating last sync time with current time"];
    [storage setLastSyncTime:[[[NSDate alloc] init] timeIntervalSince1970]];
    
    // executing onSync callback
    [self executeCallback];
}

- (void)makeGetRequest:(NSString *)url {
    // create and configure the GET request
    [LotameLogger logDebug:[NSString stringWithFormat:@"Creating a GET request with url %@", url]];

    // make the get request
    if (requestQueue != nil) {
        dispatch_async(requestQueue, [self getRequestBlock:url]);
    }
}

- (bool)areDspUrlsToBeSynced {
    long lastSyncTime = [storage getLastSyncTime];
    long currentTime = [self getCurrentTime];
    
    if (lastSyncTime == -1) {
        return true;
    } else {
        return (currentTime - lastSyncTime) >= SYNC_INTERVAL;
    }
}

- (void)processUrls:(NSString *)urlType withUrls:(NSArray *)urls withUserId:(NSString *)userId {
    NSString* currentTime = [NSString stringWithFormat:@"%ld", [self getCurrentTime]];
    
    if (urls != nil) {
        for(NSString* url in urls) {
            [self makeGetRequest:[self compileUrl:url withUserId:userId withRandomValue:currentTime]];
        }
    } else {
        [LotameLogger logWarn:[NSString stringWithFormat:@"No %@Urls found in config", urlType]];
    }
}

- (void)processDspUrls:(nonnull NSArray *)dspUrls withUserId:(nonnull NSString *)userId {
    [self processUrls:@"dsp" withUrls:dspUrls withUserId:userId];
}

- (void)processBcpUrls:(nonnull NSArray *)bcpUrls withDspUrls:(nonnull NSArray *)dspUrls withUserId:(nonnull NSString *)userId {
    [LotameLogger logDebug:[[NSString alloc] initWithFormat:@"Processing BCP Urls : %@", bcpUrls]];
    [self processUrls:@"bcp" withUrls:bcpUrls withUserId:nil];
    // sync dsp urls if 7 days have passed since they were last synced
    if (userId != nil && [self areDspUrlsToBeSynced]) {
        [LotameLogger logDebug:@"Last DSP url sync was 7 days ago,syncing again"];
        [self syncDspUrls:dspUrls withUserId:userId];
    }
}

- (void)reset {
    [storage reset];
}

+ (void)registerCallback:(nonnull void (^)(void))onSyncCallback { 
    callback = onSyncCallback;
    [LotameLogger logInfo:@"onSync callback successfully registered"];
}

- (void)executeCallback {
    if (callback != nil) {
        callback();
        [LotameLogger logDebug:@"onSync callback executed"];
    } else {
        [LotameLogger logDebug:@"No onSync callback registered"];
    }
}

@end

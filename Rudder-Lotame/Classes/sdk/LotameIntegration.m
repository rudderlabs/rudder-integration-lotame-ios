//
//  LotameIntegration.m
//  Lotame
//
//  Created by Dhawal on 10/06/20.
//

#import "LotameIntegration.h"
#import "LotameStorage.h"
#import "LotameLogger.h"

static long SYNC_INTERVAL = 60 * 60 * 24 * 7; // 7 days in seconds

static NSDictionary* mappings;
static LotameStorage* storage;
static dispatch_block_t callback;
static LotameIntegration* sharedInstance;
static dispatch_queue_t requestQueue;


@implementation LotameIntegration

+ (instancetype)getInstance:(NSDictionary *)fieldMappings withLogLevel:(int)logLevel {
    if (sharedInstance == nil) {
        sharedInstance = [[self alloc] initWithMappings:fieldMappings withLogLevel:logLevel];
    }
    return sharedInstance;
}

- (instancetype)initWithMappings:(NSDictionary *)fieldMappings withLogLevel:(int)logLevel {
    self  = [super init];
    if (self) {
        mappings = fieldMappings;
        storage = [LotameStorage getInstance];
        [LotameLogger initiate:logLevel];
        if (requestQueue == nil) {
            requestQueue = dispatch_queue_create("lotameRequestQueue", DISPATCH_QUEUE_SERIAL);
        }
    }
    return self;
}

+ (void)registerCallback:(nonnull void (^)(void))onSyncCallback {
    callback = onSyncCallback;
    [LotameLogger logInfo:@"onSync callback successfully registered"];
}

- (void)syncBcpUrls:(nonnull NSArray *)bcpUrls withUserId:(nonnull NSString *)userId {
    [LotameLogger logDebug:[[NSString alloc] initWithFormat:@"Processing BCP Urls : %@", bcpUrls]];
    [self processUrls:@"bcp" withUrls:bcpUrls withUserId:nil];
}

- (void)syncDspUrls:(nonnull NSArray *)dspUrls withUserId:(NSString *)userId withForceSync:(Boolean)force{
    [LotameLogger logDebug:[[NSString alloc] initWithFormat:@"Syncing DSP Urls : %@", dspUrls]];
    
    // sync dsp urls if 7 days have passed since they were last synced
    if (force || [self areDspUrlsToBeSynced]) {
        if (!force) {
            [LotameLogger logDebug:[[NSString alloc] initWithFormat:@"Last DSP url sync was 7 days ago,syncing again"]];
        }
        [self processUrls:@"dsp" withUrls:dspUrls withUserId:userId];
        
        // set last sync time
        [LotameLogger logDebug:@"Updating last sync time with current time"];
        [storage setLastSyncTime:[[[NSDate alloc] init] timeIntervalSince1970]];
        
        // executing onSync callback
        [LotameLogger logDebug:[[NSString alloc] initWithFormat:@"Executing onSync callback"]];
        [self executeCallback];
    }
}

- (void) syncBcpAndDspUrls:(NSString *)userId withBcpUrls:(NSArray *)bcpUrls withDspUrls:(NSArray *)dspUrls {
    [self syncBcpUrls:bcpUrls withUserId:userId];
    [self syncDspUrls:dspUrls withUserId:userId withForceSync:false];
}

- (void)makeGetRequest:(NSString *)url {
    // create and configure the GET request
    [LotameLogger logDebug:[NSString stringWithFormat:@"Creating a GET request with url %@", url]];

    // make the get request
    if (requestQueue != nil) {
        dispatch_async(requestQueue, [self getRequestBlock:url]);
    }
}

- (void)reset {
    [LotameLogger logDebug:@"Resetting Storage"];
    [storage reset];
}

- (void)executeCallback {
    if (callback != nil) {
        callback();
        [LotameLogger logDebug:@"onSync callback executed"];
    } else {
        [LotameLogger logDebug:@"No onSync callback registered"];
    }
}

- (NSString *)compileUrl:(NSString *)url withUserId:(NSString *)userId withRandomValue:(NSString *)randomValue {
    NSString* replacePattern = @"{{%@}}";
    NSString *key, *value;
    
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

- (bool)areDspUrlsToBeSynced {
    long lastSyncTime = [storage getLastSyncTime];
    // return true if the urls haven't been synced before or if 7 days have passed since the last sync
    return (lastSyncTime == -1) || (([self getCurrentTime] - lastSyncTime) >= SYNC_INTERVAL);
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

- (long)getCurrentTime {
    return [[[NSDate alloc] init] timeIntervalSince1970];
}

@end

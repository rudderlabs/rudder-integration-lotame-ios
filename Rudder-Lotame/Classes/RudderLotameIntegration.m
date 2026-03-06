//
//  RudderLotameIntegration.m
//  Lotame
//
//  Created by Dhawal on 10/06/20.
//

#import "RudderLotameIntegration.h"
#import <Rudder/RSLogger.h>
#import "LotameIntegration.h"
#import "LotameLogger.h"

static NSArray* bcpUrls;
static NSArray* dspUrls;
static LotameIntegration* lotameClient;

@implementation RudderLotameIntegration

#pragma mark - Initialization

- (instancetype) initWithConfig:(NSDictionary *)config withAnalytics:(nonnull RSClient *)client  withRudderConfig:(nonnull RSConfig *)rudderConfig {
    self = [super init];
    if(self){
        if (config != nil) {
            [RSLogger logDebug:@"Initializing Lotame SDK"];
            
            bcpUrls = [self getUrlConfig:@"bcp" withConfig:config];
            dspUrls = [self getUrlConfig:@"dsp" withConfig:config];
            lotameClient = [LotameIntegration getInstance:[self getMappingConfig:config] withLogLevel:[rudderConfig logLevel]];
        }
    }
    return self;
}


- (void) dump:(RSMessage *)message {
    @try {
        if (message != nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self processRudderEvent:message];
            });
        }
    } @catch (NSException *ex) {
        [RSLogger logError:[[NSString alloc] initWithFormat:@"%@", ex]];
    }
}

- (void) processRudderEvent: (nonnull RSMessage *) message {
    NSString* type = message.type;
    NSString* userId = [message userId];
    
    if (type != nil) {
        if ([type isEqualToString:@"screen"]){
            if (userId != nil) {
                [lotameClient syncBcpAndDspUrls:userId withBcpUrls:bcpUrls withDspUrls:dspUrls];
            } else {
                [RSLogger logWarn:@"RudderIntegration: Lotame: screen: no userId found, not syncing any pixels" ];
            }
        }
        else if ([type isEqualToString:@"identify"]) {
            if (userId != nil) {
                [lotameClient syncDspUrls:dspUrls withUserId:userId withForceSync:true];
            } else {
                [RSLogger logWarn:@"RudderIntegration: Lotame: identify: no userId found, not syncing any pixels" ];
            }
        }
        else {
            [RSLogger logDebug: [[NSString alloc] initWithFormat:@"RudderIntegration: Lotame: Message Type %@ not supported", type]] ;
        }
    } else {
        [RSLogger logDebug:@"RudderIntegration: Lotame: processEvent: eventType null"];
    }
}

- (void)reset {
    [lotameClient reset];
}

- (NSArray *)convertArrayOfDictsToArray:(NSString *)urlType withArray:(NSMutableArray *)arrayOfDicts {
    NSString* urlKey = [[NSString alloc] initWithFormat:@"%@UrlTemplate", urlType ];
    NSMutableArray* list = [[NSMutableArray alloc] init];
    NSString *value;
    
    for(NSDictionary* url in arrayOfDicts) {
        value = [url objectForKey:urlKey];
        if (value != nil && [value length] > 0) {
            [list addObject:value];
        }
    }
    return [list count] > 0 ? list : nil;
}

- (NSDictionary *)convertArrayOfDictsToDict:(NSArray *)arrayOfDicts {
    NSMutableDictionary* map = [[NSMutableDictionary alloc] init];
    NSString *key, *value;
    
    for(NSDictionary* node in arrayOfDicts) {
        key = [node objectForKey:@"key"];
        value = [node objectForKey:@"value"];
        if ((key != nil && [key length] > 0) && (value != nil && [value length] > 0)) {
            [map setObject:value forKey:key];
        }
    }
    return [map count] > 0 ? map : nil;
}

- (NSArray *)getUrlConfig:(NSString *)urlType withConfig:(NSDictionary *)configMap {
    NSString* iFrameKey = [[NSString alloc] initWithFormat:@"%@UrlSettingsIframe", urlType];
    NSString* pixelKey = [[NSString alloc] initWithFormat:@"%@UrlSettingsPixel", urlType];
    
    NSMutableArray* iFrames = [configMap objectForKey:iFrameKey];
    NSMutableArray* pixels = [configMap objectForKey:pixelKey];
    
    NSMutableArray* urlList = nil;
    if (pixels != nil && iFrames != nil) {
        urlList = pixels;
        [urlList addObjectsFromArray:iFrames];
    } else if (pixels != nil && iFrames == nil) {
        urlList = pixels;
    } else if (pixels == nil && iFrames != nil) {
        urlList = iFrames;
    } else {
        return nil;
    }
    
    return [self convertArrayOfDictsToArray:urlType withArray:urlList];
}

- (NSDictionary *)getMappingConfig:(NSDictionary *)configMap {
    NSArray* arrayOfMappings = [configMap objectForKey:@"mappings"];
    if (arrayOfMappings ==  nil) return nil;
    
    return [self convertArrayOfDictsToDict:arrayOfMappings];
}

@end





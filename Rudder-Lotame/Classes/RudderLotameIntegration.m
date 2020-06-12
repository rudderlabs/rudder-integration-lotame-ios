//
//  RudderLotameIntegration.m
//  Lotame
//
//  Created by Ruchira Moitra on 02/04/20.
//

#import "RudderLotameIntegration.h"
#import "RudderLogger.h"
#import "LotameUtils.h"
#import "LotameIntegration.h"
#import "LotameLogger.h"

static NSArray* bcpUrls;
static NSArray* dspUrls;
static LotameIntegration* lotameClient;

@implementation RudderLotameIntegration

#pragma mark - Initialization

- (instancetype) initWithConfig:(NSDictionary *)config withAnalytics:(nonnull RudderClient *)client  withRudderConfig:(nonnull RudderConfig *)rudderConfig {
    self = [super init];
    if(self){
        if (config != nil) {
            [RudderLogger logDebug:@"Initializing Lotame SDK"];
            
            NSDictionary* mappings;
            bcpUrls = [LotameUtils getUrlConfig:@"bcp" withConfig:config];
            dspUrls = [LotameUtils getUrlConfig:@"dsp" withConfig:config];
            mappings = [LotameUtils getMappingConfig:config];
            
            lotameClient = [LotameIntegration getInstance:mappings withLogLevel:[rudderConfig logLevel]];
        }
    }
    return self;
}


- (void) dump:(RudderMessage *)message {
    @try {
        if (message != nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self processRudderEvent:message];
            });
        }
    } @catch (NSException *ex) {
        [RudderLogger logError:[[NSString alloc] initWithFormat:@"%@", ex]];
    }
}

- (void) processRudderEvent: (nonnull RudderMessage *) message {
    NSString *type = message.type;
    
    if ([type isEqualToString:@"identify"]) {
        NSString* userId = [message userId];
        if (userId != nil) {
            [lotameClient syncDspUrls:dspUrls withUserId:userId];
        } else {
            [RudderLogger logWarn:@"RudderIntegration: Lotame: identify: no userId found, not syncing any pixels" ];
        }
    }
    else if ([type isEqualToString:@"screen"]){
        [lotameClient processBcpUrls:bcpUrls withDspUrls:dspUrls withUserId:[message userId]];
    }
    else {
        [RudderLogger logDebug: [[NSString alloc] initWithFormat:@"RudderIntegration: Lotame: Message Type %@ not supported", type]] ;
    }
}


- (void)reset {
    [lotameClient reset];
}

@end





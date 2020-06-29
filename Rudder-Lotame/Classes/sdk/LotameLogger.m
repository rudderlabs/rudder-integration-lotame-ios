//
//  LotameLogger.m
//  Lotame
//
//  Created by Dhawal on 11/06/20.
//

#import "LotameLogger.h"

static NSString *TAG = @"LotameIntegration";
static int logLevel;

@implementation LotameLogger

int const LotameLogLevelVerbose = 5;
int const LotameLogLevelDebug = 4;
int const LotameLogLevelInfo = 3;
int const LotameLogLevelWarning = 2;
int const LotameLogLevelError = 1;
int const LotameLogLevelNone = 0;

- (instancetype)init
{
    self = [super init];
    if (self) {
        logLevel = LotameLogLevelError;
    }
    return self;
}

+ (void)initiate:(int)_logLevel {
    if (_logLevel > LotameLogLevelVerbose) {
        logLevel = LotameLogLevelVerbose;
    } else if (_logLevel < LotameLogLevelNone) {
        logLevel = LotameLogLevelNone;
    } else {
        logLevel = _logLevel;
    }
}

+ (void)logVerbose:(NSString *)message {
    if (logLevel >= LotameLogLevelVerbose) {
        NSLog(@"%@: Verbose: %@", TAG, message);
    }
}

+ (void)logDebug:(NSString *)message {
    if (logLevel >= LotameLogLevelDebug) {
        NSLog(@"%@: Debug: %@", TAG, message);
    }
}

+ (void)logInfo:(NSString *)message {
    if (logLevel >= LotameLogLevelInfo) {
        NSLog(@"%@: Info: %@", TAG, message);
    }
}

+ (void)logWarn:(NSString *)message {
    if (logLevel >= LotameLogLevelWarning) {
        NSLog(@"%@: Warn: %@", TAG, message);
    }
}

+ (void)logError:(NSString *)message {
    if (logLevel >= LotameLogLevelError) {
        NSLog(@"%@: Error: %@", TAG, message);
    }
}

@end

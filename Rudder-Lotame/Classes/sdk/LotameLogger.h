//
//  LotameLogger.h
//  Lotame
//
//  Created by Dhawal on 11/06/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LotameLogger : NSObject

extern int const LotameLogLevelVerbose;
extern int const LotameLogLevelDebug;
extern int const LotameLogLevelInfo;
extern int const LotameLogLevelWarning;
extern int const LotameLogLevelError;
extern int const LotameLogLevelNone;

+ (void) initiate: (int) _logLevel;

+ (void) logVerbose: (NSString*) message;
+ (void) logDebug: (NSString*) message;
+ (void) logInfo: (NSString*) message;
+ (void) logWarn: (NSString*) message;
+ (void) logError: (NSString*) message;


@end

NS_ASSUME_NONNULL_END

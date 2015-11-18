#import <Foundation/Foundation.h>
#import <FBSimulatorControl/FBSimulator.h>
#import <FBSimulatorControl/FBSimulatorApplication.h>
#import <FBSimulatorControl/FBSimulatorConfiguration.h>
#import <FBSimulatorControl/FBSimulatorControl.h>
#import <FBSimulatorControl/FBSimulatorControl+Private.h>
#import <FBSimulatorControl/FBSimulatorControlConfiguration.h>
#import <FBSimulatorControl/FBProcessLaunchConfiguration+Private.h>
#import <FBSimulatorControl/FBSimulatorSession.h>
#import <FBSimulatorControl/FBSimulatorSessionInteraction.h>


int main(int argc, const char * argv[]) {
    FBSimulatorManagementOptions options =
    FBSimulatorManagementOptionsDeleteManagedSimulatorsOnFirstStart |
    FBSimulatorManagementOptionsKillUnmanagedSimulatorsOnFirstStart |
    FBSimulatorManagementOptionsDeleteOnFree;
    
    FBSimulatorControlConfiguration *configuration = [FBSimulatorControlConfiguration
                                                      configurationWithSimulatorApplication:[FBSimulatorApplication simulatorApplicationWithError:nil]
                                                      namePrefix:nil
                                                      bucket:0
                                                      options:options];
    
    FBSimulatorControl *control = [[FBSimulatorControl alloc] initWithConfiguration:configuration];
    
    dispatch_apply(2, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(size_t foo) {
        NSError *error = nil;
        FBSimulatorSession *session = [control createSessionForSimulatorConfiguration:FBSimulatorConfiguration.iPhone5 error:&error];
        
        FBApplicationLaunchConfiguration *appLaunch = [FBApplicationLaunchConfiguration
                                                       configurationWithApplication:[FBSimulatorApplication systemApplicationNamed:@"MobileSafari"]
                                                       arguments:@[]
                                                       environment:@{}];
        
        BOOL success = [[[session.interact
                          bootSimulator]
                         launchApplication:appLaunch]
                        performInteractionWithError:&error];
        NSLog(@"success: %i", success);
    });
}

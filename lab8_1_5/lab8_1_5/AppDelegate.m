#import "AppDelegate.h"
#import "Record+CoreDataClass.h"
#import "Record+CoreDataProperties.h" 

@interface AppDelegate ()

@end

@implementation AppDelegate
@synthesize
managedObjectContext,managedObjectModel,persistentStoreCoordinator;


// 1
- (NSManagedObjectContext *) managedObjectContext {
if (managedObjectContext != nil) { return managedObjectContext;
}
NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
if (coordinator != nil) { managedObjectContext =
[[NSManagedObjectContext alloc] init];
        [managedObjectContext
setPersistentStoreCoordinator: coordinator];
    }
    return managedObjectContext;
}
//2
- (NSManagedObjectModel *)managedObjectModel {
if (managedObjectModel != nil) { return managedObjectModel;
}
managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
          return managedObjectModel;
      }
- (NSURL *)applicationDocumentsDirectory { return [[[NSFileManager defaultManager]
URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
      }
//3
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
if (persistentStoreCoordinator != nil) { return persistentStoreCoordinator;
}
NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"flight.sqlite"];
NSError *error = nil;
persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![persistentStoreCoordinator
addPersistentStoreWithType:NSSQLiteStoreType configuration:nil
URL:storeURL options:nil error:&error]) {
}
    return persistentStoreCoordinator;
}

- (void)saveContext {
// Исправлено: заменено persistentContainer на ваш managedObjectContext
NSManagedObjectContext *context = self.managedObjectContext;
NSError *error = nil;
if ([context hasChanges] && ![context save:&error]) {
NSLog(@"Unresolved error %@, %@", error, error.userInfo);
abort(); }}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions: (NSDictionary *)launchOptions {

    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"HasLaunchedOnce"]) {
    [[NSUserDefaults standardUserDefaults] setBool: YES forKey:@"HasLaunchedOnce"];
            [[NSUserDefaults standardUserDefaults] synchronize];
    Record* firstFlight = [NSEntityDescription insertNewObjectForEntityForName:@"Record" inManagedObjectContext:self.managedObjectContext];
    firstFlight.cityFrom = @"Челябинск"; firstFlight.cityTo = @"Москва"; firstFlight.aviaCompany = @"Аэрофлот"; firstFlight.price = 1000.0;
    Record* secondFlight = [NSEntityDescription insertNewObjectForEntityForName:@"Record" inManagedObjectContext:self.managedObjectContext];
    secondFlight.cityFrom = @"Челябинск"; secondFlight.cityTo = @"Москва"; secondFlight.aviaCompany = @"ЧелАвиа"; secondFlight.price = 2000.0;
    Record* thirdFlight = [NSEntityDescription insertNewObjectForEntityForName:@"Record" inManagedObjectContext:self.managedObjectContext];
    thirdFlight.cityFrom = @"Екатеринбург"; thirdFlight.cityTo = @"Уфа"; thirdFlight.aviaCompany = @"Аэрофлот"; thirdFlight.price = 500.0;
    Record* fourthFlight = [NSEntityDescription insertNewObjectForEntityForName:@"Record" inManagedObjectContext:self.managedObjectContext];
    fourthFlight.cityFrom = @"Челябинск"; fourthFlight.cityTo = @"Уфа"; fourthFlight.aviaCompany = @"РусЛайн"; fourthFlight.price = 1500.0;
    Record* fifthFlight = [NSEntityDescription insertNewObjectForEntityForName:@"Record" inManagedObjectContext:self.managedObjectContext];
    fifthFlight.cityFrom = @"Екатеринбург"; fifthFlight.cityTo = @"Москва"; fifthFlight.aviaCompany = @"Аэрофлот"; fifthFlight.price = 800.0;
            [self saveContext];
        }
    
    return YES;
}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
}


@end

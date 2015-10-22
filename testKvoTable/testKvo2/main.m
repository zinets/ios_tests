#import <Foundation/Foundation.h>

@interface Party : NSObject
{
    // just adding this instance variable is enough to create a KVC and KVO compliant
    // attendees property
    NSMutableArray *attendees;
}

- (void)printAttendeesAddress;
@end

@implementation Party
- (id)init {
    attendees = [NSMutableArray array];
    return self;
}

- (void)printAttendeesAddress {
    NSLog(@"Attendees array is at address %p", attendees);
}
@end

@interface MyObserver : NSObject
@end

@implementation MyObserver
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    NSLog(@"Received notification: keyPath:%@ ofObject:%@ change:%@",
          keyPath, object, change);
}
@end

int main (int argc, const char * argv[]) {
    
    Party *party = [Party new];
    MyObserver *observer = [MyObserver new];
    
    // observe attendees property
    [party addObserver:observer
            forKeyPath:@"attendees"
               options:(NSKeyValueObservingOptionNew |
                        NSKeyValueObservingOptionOld)
               context:NULL];
    
    [party printAttendeesAddress];
    
    // modifications to attendees will be logged by observer
    NSMutableArray *attendees = [party
                                 mutableArrayValueForKey:@"attendees"];
    [attendees addObject:@"Joe Blow"];
    [attendees addObject:@"Mary Jane"];
    [attendees replaceObjectAtIndex:0 withObject:@"Spiderman"];
    [attendees removeObjectAtIndex:1];
    
    // this should print the same address as the previous invocation of    this method
    // showing that the instance variable's underlying array isn't    getting copied
    [party printAttendeesAddress];
    

    return 0;
}
// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Tag.h instead.

@import CoreData;

NS_ASSUME_NONNULL_BEGIN

@class Task;
@class TimeEntry;
@class User;

@interface TagID : NSManagedObjectID {}
@end

@interface _Tag : NSManagedObject
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) TagID*objectID;

@property (nonatomic, strong) NSString* value;

@property (nonatomic, strong, nullable) NSSet<Task*> *defaultForTasks;
- (nullable NSMutableSet<Task*>*)defaultForTasksSet;

@property (nonatomic, strong, nullable) NSSet<TimeEntry*> *usedForEntries;
- (nullable NSMutableSet<TimeEntry*>*)usedForEntriesSet;

@property (nonatomic, strong, nullable) User *user;

@end

@interface _Tag (DefaultForTasksCoreDataGeneratedAccessors)
- (void)addDefaultForTasks:(NSSet<Task*>*)value_;
- (void)removeDefaultForTasks:(NSSet<Task*>*)value_;
- (void)addDefaultForTasksObject:(Task*)value_;
- (void)removeDefaultForTasksObject:(Task*)value_;

@end

@interface _Tag (UsedForEntriesCoreDataGeneratedAccessors)
- (void)addUsedForEntries:(NSSet<TimeEntry*>*)value_;
- (void)removeUsedForEntries:(NSSet<TimeEntry*>*)value_;
- (void)addUsedForEntriesObject:(TimeEntry*)value_;
- (void)removeUsedForEntriesObject:(TimeEntry*)value_;

@end

@interface _Tag (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveValue;
- (void)setPrimitiveValue:(NSString*)value;

- (NSMutableSet<Task*>*)primitiveDefaultForTasks;
- (void)setPrimitiveDefaultForTasks:(NSMutableSet<Task*>*)value;

- (NSMutableSet<TimeEntry*>*)primitiveUsedForEntries;
- (void)setPrimitiveUsedForEntries:(NSMutableSet<TimeEntry*>*)value;

- (User*)primitiveUser;
- (void)setPrimitiveUser:(User*)value;

@end

@interface TagAttributes: NSObject 
+ (NSString *)value;
@end

@interface TagRelationships: NSObject
+ (NSString *)defaultForTasks;
+ (NSString *)usedForEntries;
+ (NSString *)user;
@end

NS_ASSUME_NONNULL_END

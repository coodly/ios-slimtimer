// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Tag.h instead.

#import <CoreData/CoreData.h>

extern const struct TagAttributes {
	__unsafe_unretained NSString *value;
} TagAttributes;

extern const struct TagRelationships {
	__unsafe_unretained NSString *defaultForTasks;
	__unsafe_unretained NSString *usedForEntries;
	__unsafe_unretained NSString *user;
} TagRelationships;

@class Task;
@class TimeEntry;
@class User;

@interface TagID : NSManagedObjectID {}
@end

@interface _Tag : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) TagID* objectID;

@property (nonatomic, strong) NSString* value;

//- (BOOL)validateValue:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSSet *defaultForTasks;

- (NSMutableSet*)defaultForTasksSet;

@property (nonatomic, strong) NSSet *usedForEntries;

- (NSMutableSet*)usedForEntriesSet;

@property (nonatomic, strong) User *user;

//- (BOOL)validateUser:(id*)value_ error:(NSError**)error_;

@end

@interface _Tag (DefaultForTasksCoreDataGeneratedAccessors)
- (void)addDefaultForTasks:(NSSet*)value_;
- (void)removeDefaultForTasks:(NSSet*)value_;
- (void)addDefaultForTasksObject:(Task*)value_;
- (void)removeDefaultForTasksObject:(Task*)value_;

@end

@interface _Tag (UsedForEntriesCoreDataGeneratedAccessors)
- (void)addUsedForEntries:(NSSet*)value_;
- (void)removeUsedForEntries:(NSSet*)value_;
- (void)addUsedForEntriesObject:(TimeEntry*)value_;
- (void)removeUsedForEntriesObject:(TimeEntry*)value_;

@end

@interface _Tag (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveValue;
- (void)setPrimitiveValue:(NSString*)value;

- (NSMutableSet*)primitiveDefaultForTasks;
- (void)setPrimitiveDefaultForTasks:(NSMutableSet*)value;

- (NSMutableSet*)primitiveUsedForEntries;
- (void)setPrimitiveUsedForEntries:(NSMutableSet*)value;

- (User*)primitiveUser;
- (void)setPrimitiveUser:(User*)value;

@end

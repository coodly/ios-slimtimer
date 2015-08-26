// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Task.h instead.

#import <CoreData/CoreData.h>

extern const struct TaskAttributes {
	__unsafe_unretained NSString *complete;
	__unsafe_unretained NSString *hidden;
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *taskId;
	__unsafe_unretained NSString *temporary;
	__unsafe_unretained NSString *touchedAt;
} TaskAttributes;

extern const struct TaskRelationships {
	__unsafe_unretained NSString *defaultTags;
	__unsafe_unretained NSString *syncStatus;
	__unsafe_unretained NSString *timeEntry;
	__unsafe_unretained NSString *user;
} TaskRelationships;

@class Tag;
@class SyncStatus;
@class TimeEntry;
@class User;

@interface TaskID : NSManagedObjectID {}
@end

@interface _Task : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) TaskID* objectID;

@property (nonatomic, strong) NSNumber* complete;

@property (atomic) BOOL completeValue;
- (BOOL)completeValue;
- (void)setCompleteValue:(BOOL)value_;

//- (BOOL)validateComplete:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* hidden;

@property (atomic) BOOL hiddenValue;
- (BOOL)hiddenValue;
- (void)setHiddenValue:(BOOL)value_;

//- (BOOL)validateHidden:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* name;

//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* taskId;

@property (atomic) int32_t taskIdValue;
- (int32_t)taskIdValue;
- (void)setTaskIdValue:(int32_t)value_;

//- (BOOL)validateTaskId:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* temporary;

@property (atomic) BOOL temporaryValue;
- (BOOL)temporaryValue;
- (void)setTemporaryValue:(BOOL)value_;

//- (BOOL)validateTemporary:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSDate* touchedAt;

//- (BOOL)validateTouchedAt:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSSet *defaultTags;

- (NSMutableSet*)defaultTagsSet;

@property (nonatomic, strong) SyncStatus *syncStatus;

//- (BOOL)validateSyncStatus:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSSet *timeEntry;

- (NSMutableSet*)timeEntrySet;

@property (nonatomic, strong) User *user;

//- (BOOL)validateUser:(id*)value_ error:(NSError**)error_;

@end

@interface _Task (DefaultTagsCoreDataGeneratedAccessors)
- (void)addDefaultTags:(NSSet*)value_;
- (void)removeDefaultTags:(NSSet*)value_;
- (void)addDefaultTagsObject:(Tag*)value_;
- (void)removeDefaultTagsObject:(Tag*)value_;

@end

@interface _Task (TimeEntryCoreDataGeneratedAccessors)
- (void)addTimeEntry:(NSSet*)value_;
- (void)removeTimeEntry:(NSSet*)value_;
- (void)addTimeEntryObject:(TimeEntry*)value_;
- (void)removeTimeEntryObject:(TimeEntry*)value_;

@end

@interface _Task (CoreDataGeneratedPrimitiveAccessors)

- (NSNumber*)primitiveComplete;
- (void)setPrimitiveComplete:(NSNumber*)value;

- (BOOL)primitiveCompleteValue;
- (void)setPrimitiveCompleteValue:(BOOL)value_;

- (NSNumber*)primitiveHidden;
- (void)setPrimitiveHidden:(NSNumber*)value;

- (BOOL)primitiveHiddenValue;
- (void)setPrimitiveHiddenValue:(BOOL)value_;

- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;

- (NSNumber*)primitiveTaskId;
- (void)setPrimitiveTaskId:(NSNumber*)value;

- (int32_t)primitiveTaskIdValue;
- (void)setPrimitiveTaskIdValue:(int32_t)value_;

- (NSNumber*)primitiveTemporary;
- (void)setPrimitiveTemporary:(NSNumber*)value;

- (BOOL)primitiveTemporaryValue;
- (void)setPrimitiveTemporaryValue:(BOOL)value_;

- (NSDate*)primitiveTouchedAt;
- (void)setPrimitiveTouchedAt:(NSDate*)value;

- (NSMutableSet*)primitiveDefaultTags;
- (void)setPrimitiveDefaultTags:(NSMutableSet*)value;

- (SyncStatus*)primitiveSyncStatus;
- (void)setPrimitiveSyncStatus:(SyncStatus*)value;

- (NSMutableSet*)primitiveTimeEntry;
- (void)setPrimitiveTimeEntry:(NSMutableSet*)value;

- (User*)primitiveUser;
- (void)setPrimitiveUser:(User*)value;

@end

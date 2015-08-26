// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Year.h instead.

#import <CoreData/CoreData.h>

extern const struct YearAttributes {
	__unsafe_unretained NSString *value;
} YearAttributes;

extern const struct YearRelationships {
	__unsafe_unretained NSString *months;
	__unsafe_unretained NSString *user;
} YearRelationships;

@class Month;
@class User;

@interface YearID : NSManagedObjectID {}
@end

@interface _Year : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) YearID* objectID;

@property (nonatomic, strong) NSNumber* value;

@property (atomic) int32_t valueValue;
- (int32_t)valueValue;
- (void)setValueValue:(int32_t)value_;

//- (BOOL)validateValue:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSSet *months;

- (NSMutableSet*)monthsSet;

@property (nonatomic, strong) User *user;

//- (BOOL)validateUser:(id*)value_ error:(NSError**)error_;

@end

@interface _Year (MonthsCoreDataGeneratedAccessors)
- (void)addMonths:(NSSet*)value_;
- (void)removeMonths:(NSSet*)value_;
- (void)addMonthsObject:(Month*)value_;
- (void)removeMonthsObject:(Month*)value_;

@end

@interface _Year (CoreDataGeneratedPrimitiveAccessors)

- (NSNumber*)primitiveValue;
- (void)setPrimitiveValue:(NSNumber*)value;

- (int32_t)primitiveValueValue;
- (void)setPrimitiveValueValue:(int32_t)value_;

- (NSMutableSet*)primitiveMonths;
- (void)setPrimitiveMonths:(NSMutableSet*)value;

- (User*)primitiveUser;
- (void)setPrimitiveUser:(User*)value;

@end

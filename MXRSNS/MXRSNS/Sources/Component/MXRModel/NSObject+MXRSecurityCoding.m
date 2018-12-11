//
//  NSObject+MXRSecurityCoding.m
//  huashida_home
//
//  Created by MountainX on 2017/11/29.
//  Copyright © 2017年 苏州梦想人软件科技有限公司. All rights reserved.
//

#import "NSObject+MXRSecurityCoding.h"
#import <objc/runtime.h>

@implementation NSObject (MXRSecurityCoding)

- (NSDictionary *)propertyClassesByName

{
    
    // Check for a cached value (we use _cmd as the cache key,
    
    // which represents @selector(propertyNames))
    
    NSMutableDictionary *dictionary = objc_getAssociatedObject([self class], _cmd);
    
    if (dictionary)
        
    {
        
        return dictionary;
        
    }
    
    // Loop through our superclasses until we hit NSObject
    
    dictionary = [NSMutableDictionary dictionary];
    
    Class subclass = [self class];
    
    while (subclass != [NSObject class])
        
    {
        
        unsigned int propertyCount;
        
        objc_property_t *properties = class_copyPropertyList(subclass,
                                                             
                                                             &propertyCount);
        
        for (int i = 0; i < propertyCount; i++)
            
        {
            
            // Get property name
            
            objc_property_t property = properties[i];
            
            const char *propertyName = property_getName(property);
            
            NSString *key = @(propertyName);
            
            // Check if there is a backing ivar
            
            char *ivar = property_copyAttributeValue(property, "V");
            
            if (ivar)
                
            {
                
                // Check if ivar has KVC-compliant name
                
                NSString *ivarName = @(ivar);
                
                if ([ivarName isEqualToString:key] ||
                    
                    [ivarName isEqualToString:[@"_" stringByAppendingString:key]])
                    
                {
                    
                    // Get type
                    
                    Class propertyClass = nil;
                    
                    char *typeEncoding = property_copyAttributeValue(property, "T");
                    
                    switch (typeEncoding[0])
                    
                    {
                            
                        case 'c': // Numeric types
                            
                        case 'i':
                            
                        case 's':
                            
                        case 'l':
                            
                        case 'q':
                            
                        case 'C':
                            
                        case 'I':
                            
                        case 'S':
                            
                        case 'L':
                            
                        case 'Q':
                            
                        case 'f':
                            
                        case 'd':
                            
                        case 'B':
                            
                        {
                            
                            propertyClass = [NSNumber class];
                            
                            break;
                            
                        }
                            
                        case '*': // C-String
                            
                        {
                            
                            propertyClass = [NSString class];
                            
                            break;
                            
                        }
                            
                        case '@': // Object
                            
                        {
                            
                            //TODO: get class name
                            
                            break;
                            
                        }
                            
                        case '{': // Struct
                            
                        {
                            
                            propertyClass = [NSValue class];
                            
                            break;
                            
                        }
                            
                        case '[': // C-Array
                            
                        case '(': // Enum
                            
                        case '#': // Class
                            
                        case ':': // Selector
                            
                        case '^': // Pointer
                            
                        case 'b': // Bitfield
                            
                        case '?': // Unknown type
                            
                        default:
                            
                        {
                            
                            propertyClass = nil; // Not supported by KVC
                            
                            break;
                            
                        }
                            
                    }
                    
                    free(typeEncoding);
                    
                    // If known type, add to dictionary
                    
                    //                    if (propertyClass) dictionary[propertyName] = propertyClass;
                    if (propertyClass) dictionary[[NSString stringWithUTF8String:propertyName]] = propertyClass;
                    
                }
                
                free(ivar);
                
            }
            
        }
        
        free(properties);
        
        subclass = [subclass superclass];
        
    }
    
    // Cache and return dictionary
    
    objc_setAssociatedObject([self class], _cmd, dictionary,
                             
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    return dictionary;
    
}

@end

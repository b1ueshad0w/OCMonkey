//
//  Macros.h
//  OCMonkey
//
//  Created by gogleyin on 28/04/2017.
//
//

#ifndef Macros_h
#define Macros_h

#define ARC4RANDOM_MAX 0x100000000

#define MIN(a,b)    ((a) < (b) ? (a) : (b))
#define MAX(a,b)    ((a) > (b) ? (a) : (b))

#define RandomZeroToOne arc4random() / (double)ARC4RANDOM_MAX

#endif /* Macros_h */

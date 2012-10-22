/* Copyright (c) 2012 Scott Lembcke and Howling Moon Software
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

#import "ccConfig.h"

#if CC_ENABLE_CHIPMUNK_INTEGRATION
#import "CCDrawNode.h"

@class ChipmunkSpace;
struct cpSpace *space;

/**
 A Node that draws the components of a physics engine.
 
 Supported physics engines:
	- Chipmunk
	- Objective-Chipmunk
 
 @since v2.1
 */
@interface CCPhysicsDebugNode : CCDrawNode
{
	ChipmunkSpace *_spaceObj;
	struct cpSpace *_spacePtr;
}

// property for the cpSpace
@property (nonatomic, readwrite, assign) struct cpSpace *space;

/** Create a debug node for an Objective-Chipmunk space. */
+ (id) debugNodeForChipmunkSpace:(ChipmunkSpace *)space;

/** Create a debug node for a regular Chipmunk space. */
+ (id) debugNodeForCPSpace:(struct cpSpace *)space;

@end

#endif // CC_ENABLE_CHIPMUNK_INTEGRATION

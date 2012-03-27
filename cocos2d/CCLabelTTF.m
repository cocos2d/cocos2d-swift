/*
 * cocos2d for iPhone: http://www.cocos2d-iphone.org
 *
 * Copyright (c) 2008-2010 Ricardo Quesada
 * Copyright (c) 2011 Zynga Inc.
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
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */


#import "CCLabelTTF.h"
#import "Support/CGPointExtension.h"
#import "ccMacros.h"
#import "CCShaderCache.h"
#import "CCGLProgram.h"
#import "CCFileUtils.h"

#ifdef __CC_PLATFORM_IOS
#import "Platforms/iOS/CCDirectorIOS.h"
#endif

#if CC_USE_LA88_LABELS
#define SHADER_PROGRAM kCCShader_PositionTextureColor
#else
#define SHADER_PROGRAM kCCShader_PositionTextureA8Color
#endif

@implementation CCLabelTTF

- (id) init
{
    return [self initWithString:@"" fontName:@"Helvetica" fontSize:12];
}

+ (id) labelWithString:(NSString*)string dimensions:(CGSize)dimensions alignment:(CCTextAlignment)alignment lineBreakMode:(CCLineBreakMode)lineBreakMode fontName:(NSString*)name fontSize:(CGFloat)size;
{
	return [[[self alloc] initWithString: string dimensions:dimensions alignment:alignment lineBreakMode:lineBreakMode fontName:name fontSize:size]autorelease];
}

+ (id) labelWithString:(NSString*)string dimensions:(CGSize)dimensions alignment:(CCTextAlignment)alignment fontName:(NSString*)name fontSize:(CGFloat)size
{
	return [[[self alloc] initWithString: string dimensions:dimensions alignment:alignment fontName:name fontSize:size]autorelease];
}

+ (id) labelWithString:(NSString*)string fontName:(NSString*)name fontSize:(CGFloat)size
{
	return [[[self alloc] initWithString: string fontName:name fontSize:size]autorelease];
}


- (id) initWithString:(NSString*)str dimensions:(CGSize)dimensions alignment:(CCTextAlignment)alignment lineBreakMode:(CCLineBreakMode)lineBreakMode fontName:(NSString*)name fontSize:(CGFloat)size
{
	if( (self=[super init]) ) {

		// shader program
		self.shaderProgram = [[CCShaderCache sharedShaderCache] programForKey:SHADER_PROGRAM];

		dimensions_ = CGSizeMake( dimensions.width, dimensions.height );
		alignment_ = alignment;
		fontName_ = [name retain];
		fontSize_ = size;
		lineBreakMode_ = lineBreakMode;

		[self setString:str];
	}
	return self;
}

- (id) initWithString:(NSString*)str dimensions:(CGSize)dimensions alignment:(CCTextAlignment)alignment fontName:(NSString*)name fontSize:(CGFloat)size
{
	return [self initWithString:str dimensions:dimensions alignment:alignment lineBreakMode:CCLineBreakModeWordWrap fontName:name fontSize:size];
}

- (id) initWithString:(NSString*)str fontName:(NSString*)name fontSize:(CGFloat)size
{
	if( (self=[super init]) ) {

		// shader program
		self.shaderProgram = [[CCShaderCache sharedShaderCache] programForKey:SHADER_PROGRAM];

		dimensions_ = CGSizeZero;
		fontName_ = [name retain];
		fontSize_ = size;

		[self setString:str];
	}
	return self;
}

- (void) setString:(NSString*)str
{
	[string_ release];
	string_ = [str copy];
    
    NSString* fontName = fontName_;
    
#ifdef __CC_PLATFORM_MAC
    if ([[fontName lowercaseString] hasSuffix:@".ttf"] || YES)
    {
        // This is a file, register font with font manager
        NSString* fontFile = [[CCFileUtils sharedFileUtils] fullPathFromRelativePath:fontName];
        NSURL* fontURL = [NSURL fileURLWithPath:fontFile];
        CTFontManagerRegisterFontsForURL((CFURLRef)fontURL, kCTFontManagerScopeProcess, NULL);
        fontName = [[fontFile lastPathComponent] stringByDeletingPathExtension];
    }
#endif

	CCTexture2D *tex;
	if( dimensions_.width == 0 || dimensions_.height == 0 )
		tex = [[CCTexture2D alloc] initWithString:str
										 fontName:fontName
										 fontSize:fontSize_  * CC_CONTENT_SCALE_FACTOR()];
	else
		tex = [[CCTexture2D alloc] initWithString:str
									   dimensions:CC_SIZE_POINTS_TO_PIXELS(dimensions_)
										alignment:alignment_
									lineBreakMode:lineBreakMode_
										 fontName:fontName
										 fontSize:fontSize_  * CC_CONTENT_SCALE_FACTOR()];

#ifdef __CC_PLATFORM_IOS
	// iPad ?
	if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) {
		if( CC_CONTENT_SCALE_FACTOR() == 2 )
			[tex setResolutionType:kCCResolutioniPadRetinaDisplay];
		else
			[tex setResolutionType:kCCResolutioniPad];
	}
	// iPhone ?
	else
	{
		if( CC_CONTENT_SCALE_FACTOR() == 2 )
			[tex setResolutionType:kCCResolutioniPhoneRetinaDisplay];
		else
			[tex setResolutionType:kCCResolutioniPhone];
	}
#endif

	[self setTexture:tex];
	[tex release];

	CGRect rect = CGRectZero;
	rect.size = [texture_ contentSize];
	[self setTextureRect: rect];
}

-(NSString*) string
{
	return string_;
}

- (void)setFontName:(NSString*)fontName
{
	if( fontName != fontName_ ) {
		[fontName_ release];
		fontName_ = [fontName retain];
    
		// Force update
		[self setString:[self string]];
	}
}

- (NSString*)fontName
{
    return fontName_;
}

- (void) setFontSize:(float)fontSize
{
	if( fontSize != fontSize_ ) {
		fontSize_ = fontSize;
		
		// Force update
		[self setString:[self string]];
	}
}

- (float) fontSize
{
    return fontSize_;
}

-(void) setDimensions:(CGSize) dim
{
    if( dim.width != dimensions_.width || dim.height != dimensions_.height)
	{
        dimensions_ = dim;
        
		// Force update
		[self setString:[self string]];
    }
}

-(CGSize) dimensions
{
    return dimensions_;
}

-(void) setAlignment:(NSTextAlignment)alignment
{
    if (alignment != alignment_)
    {
        alignment_ = alignment;
        
        // Force update
        [self setString:[self string]];
    }
}

- (NSTextAlignment) alignment
{
    return alignment_;
}

- (void) dealloc
{
	[string_ release];
	[fontName_ release];

	[super dealloc];
}

- (NSString*) description
{
	// XXX: string_, fontName_ can't be displayed here, since they might be already released

	return [NSString stringWithFormat:@"<%@ = %08X | FontSize = %.1f>", [self class], self, fontSize_];
}
@end

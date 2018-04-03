# Bruno

This simple lib helps you to represent image in RGB565 format.

Example use:

```swift
// get some source image
let source = UIImage(...)

// resize image to 8x8pm, convert image from RGB8888 to RGB565 format
let data = source.encodeRGB565(width: 8, height: 8)

// convert image from RGB565 to RGB8888 format
let image = data?.decodeRGB565(width: 8, height: 8)
```

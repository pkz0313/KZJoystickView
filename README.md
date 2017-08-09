# KZJoystickView
An easy-to-use custom joystick view.

![](https://github.com/pkz0313/KZJoystickView/blob/master/KZJoystickView/KZJoystickView.gif)

# Usage
#### First Step
Drag the file "KZJoystickView.swift" to your swift project

#### Second Step
Create a view with xib and specify the class name.

![specify the class name](https://github.com/pkz0313/KZJoystickView/blob/master/KZJoystickView/image1.png)

#### Third Step
Make a association with @IBOutlet

![specify the class name](https://github.com/pkz0313/KZJoystickView/blob/master/KZJoystickView/image2.png)

#### Finally the last Step 
Set delegate

```joystickView.delegate = self```

Protocol

```    
func joystickViewDidEndMoving(_ joystickView: KZJoystickView) {   }
    
func joystickView(_ joystickView: KZJoystickView, didMoveto angle: Int, distance: Float) { }
```
# Example
Clone or download and run the example project

# Requirement
iOS 8.0+

# License
This is released under the MIT license.

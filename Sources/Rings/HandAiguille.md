## HandAiguille

### Preview
https://user-images.githubusercontent.com/1284944/117106480-83aeff80-adb2-11eb-8e82-d77d9569dcca.mov

### Usage: 
```swift
  // Create empty hand aiguille with default size, and set the hand aiguille background red
  HandAiguille() {
  }.handBackground(Color.red)
  
  // Create empty hand aiguille with time provider, and specify its time unit.
  @State var hourProvider: Double = 0.0
  HandAiguille(time: $hourProvider, unit: .hour) {
  }.handBackgroudn(Color.red)
  
  // Create hand aiguille with Image
  @State var secsProvider: Double = 0.0
  HandAiguille(time: $secsProvider) {
    Image("SpadeHand")
  }
  
  // Create apple watch style hand
  HandFactory.standard.makeAppleWatchStyleHand(time: $secsProvider)
```

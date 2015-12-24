# UITextField-History
A category of UITextfiled that can automatic record user's input history.（可以自动记录用户输入的UITextField扩展,，使用Swift2编写）

## Usage
```ruby
pod 'UITextField-History', :git => 'https://github.com/Jameson-zxm/UITextField-History.git'
```

## Demo
<img src="https://github.com/Jameson-zxm/UITextField-History/blob/master/demo.gif" widht="323" height="412">

## Example Code

```
  override func viewDidLoad() {
     super.viewDidLoad()
     
     textField1.identify = "ViewController:textField1"
     textField1.clearButtonTitle = "清除所有历史"
     textField1.showHistoryBeginEdit = true
     textField1.dismissHistoryEndEdit = true
     textField1.delegate = self
     
     textField2.identify = "ViewController:textField2"
     textField2.clearButtonTitle = "清除历史"
     textField2.showHistoryBeginEdit = true
     textField2.delegate = self
  }

  override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
      super.touchesBegan(touches, withEvent: event)
      
      textField2.addHistory()
      textField2.resignFirstResponder()
      textField2.dismissHistoryView()
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
      self.textField1.dismissHistoryView()
      self.textField2.dismissHistoryView()
  }
```

## Contact
* morenotepad@163.


## License
(The MIT License)

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the 'Software'), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


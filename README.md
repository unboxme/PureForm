PureForm — the easiest way to build form such as login, questionnaire and etc. screens from JSON file. PureForm provides parsing properties and special params into objects for further manipulation of them. 

## Setup

### Manually

Download the source files from the [PureForm subdirectory](https://github.com/unboxme/PureForm/tree/master/PureForm). Then just add source files to your Xcode project and import the `PureLayout.h` header.

### Cocoapods

Add the pod PureForm to your Podfile:

```ruby
platform :ios, '8.0'

target 'YourProject' do
    pod 'PureForm'
end
```

Then, run the following command:

```terminal
$ pod install
```

## Usage

PureForm is clean and pretty easy to use in several steps:

1. Describe your form in a JSON file using `JSON Rules` paragraph below;
2. Create settings via `PFSettings` using `Settings` paragraph below:

    ```objc
    PFSettings *settings = [[PFSettings alloc] init];
    settings.keyboardTypeValidation = YES;
    settings.formDelegate = self;
    settings.tableViewDelegate = self;

    // etc.
    ```
3. Create a `PFFormController` instance with a `UITableView` and settings which were created at the previous step:

    ```objc
    self.formController = [[PFFormController alloc] initWithTableView:self.tableView settings:settings];
    ```
4. Just use a `makeFormWithJSONFile:` method to create and display your form from the JSON file from the first step:

    ```objc
    [self.formController makeFormWithJSONFile:@"form"];
    ```

5. That's it!

## Settings

The [settings header](PureForm/Models/PFSettings.h) is fully documented. There are main params here you can set:

* `keyboardTypeValidation`
* `failureReasons`
* `cellHeight`

As well as delegates for `UIKit` controls:

* `PFFormDelegate`
* `UITableViewDelegate`
* `UITextFieldDelegate`
* `PFSegmentedControlDelegate`
* `PFSwitchControlDelegate`
* `PFSliderControlDelegate`
* `PFStepperControlDelegate`

## JSON Rules

Describe your custom cell in JSON just using property names and values for them. Of course, __reserved words__ and __special chars__ are used too. You can find reserved words and special chars in a [constants header](PureForm/Common/PFConstants.h).

### Basics

* Pairs of class cell name or cell identifier and reserved words are segregated by `<` and `>`. 
* The base structure for 2 cells looks like __(pay attention on levels)__:

 ```
[									   		    /// 0 level
  {
    "<cell_class_name + cell_identifier>": {   // First cell
      property_name_1: {					   /// 1 level
        in_property_name_1.1: value,		   /// 2 level
        in_property_name_1.2: value
      },
      property_name_2: {
        in_property_name_2.1: value
      }
    }
  },
  {
    "<cell_class_name + cell_identifier>": { 	// Second cell
    // Setup
  },
  {
  // etc.
  }
]
```
__Note that JSON parsing supports only 2 levels of nesting yet.__
* If a cell class name or a cell identifier equals to the previous one, you can simplify it using `=` like that:

 ```
 {
    "<= + =>": { 									// Any cell
    // Setup
 },
```
* Usage of reserved words and special chars:

 | Reserved word | Level | Value 
|----------------------|---------|----------
| `<section>`	 | 0 | index of section 
| `<value>`        | 1 | current value
| `<key>`           | 1 | save key for output dictionary
| `<validators>` | 1 | array of validators
| `<display>` 	 | 1 | property name to display value after change
__All reserved words and special chars are optional.__

 | Char | Usage in | Example | Description
 |------------------|-----------|-------------|------
 | ? | property name | textField? | Shows that it's a form for validation — not just a view
 | ! | validator name | min_value! | Starts validation immediately after value change
 | * | property name | text* | Shows that this value is a key for `NSLocalizedString` macros
 | # | value | ic_turtle#6F3F83 or #6F3F83| Uses as it is or for hex coloring image by their name
* Available validator keys for `<validators>`:

 | Validator | Value
|-------------|----------
| `equal` | string or number
| `equal_next` | `true`
| `equal_previous` | `true`
| `equal_length` | number
| `min_length` | number
| `max_length` | number
| `min_value` | number
| `max_value` | number
| `required` | `true`
| `type` | `email` or `full_name`
| `custom` | regex string
__Validators are used in 2 level and they should be nested into `<validators>`.__
  
* Enums are just numeric values in JSON. By the way there are some enums which are associated with string values:
	* `UIKeyboardType`
	* `UITextAutocapitalizationType`
	* `UITextAutocorrectionType`
	* `UITextSpellCheckingType`
	* `UIKeyboardAppearance`
	* `UIReturnKeyType`
	* `UITextFieldViewMode`

### Examples

* Well, how it looks in a real example: 

 ```json
[
  {
    "<TextFieldCell + TextFieldCellIdentifier>": {
      "textField?": {
        "placeholder": "Huh, centered?",
        "textAlignment": 1
      }
    }
  }
]
```

<p align='center'>
	<img height='600' src='https://github.com/unboxme/PureForm/blob/master/Screenshots/centered_text.png'>
</p>

* Now let's make a login form with validators:

 ```json
[
  {
    "<TextFieldCell + TextFieldCellIdentifier>": {
      "textField?": {
        "placeholder": "Login",
        "textAlignment": 1,
        "keyboardType": "UIKeyboardTypeEmailAddress",
        "<key>": "login",
        "<validators>": {
          "type": "email"
        }
      }
    }
  },
  {
    "<= + =>": {
      "textField?": {
        "placeholder": "Password",
        "textAlignment": 1,
        "secureTextEntry": true,
        "<key>": "password",
        "<validators>": {
          "min_length!": 6,
          "max_length!": 25
        }
      }
    }
  },
  {
  "<section>": 1
  },
  {
    "<ButtonCell + ButtonCellIdentifier>": {
      "titleLabel": {
        "text": "Login",
        "textColor": "#6F3F83"
      }
    }
  }
]
```

<p align='center'>
	<img height='600' src='https://github.com/unboxme/PureForm/blob/master/Screenshots/clean_form.png'>
</p>

* It remains only to validate entered values and save they into the dictionary. Credentials from left form satisfies the validators and `[self.formController validate]` will return `YES`:

 ```objc
if ([self.formController validate]) {
	NSDictionary *loginInfo = [self.formController allKeyValuePairs];
	// Send it to server
}
 ```
 
 <p align='center'>
	<img height='600' src='https://github.com/unboxme/PureForm/blob/master/Screenshots/filled_form.png'>
	<img height='600' src='https://github.com/unboxme/PureForm/blob/master/Screenshots/filled_form_error.png'>
</p>

## Notes

* Example project files will open properly only in Xcode 8;
* There is no autoscroll to the active field in the example project.

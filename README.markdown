
## .vimrc

```
let g:quickrun_config = {}

let g:quickrun_config['objc'] = {'command': 'xctool', 'cmdopt': 'test', 'outputter': 'xctool', 'exec': ['%c %o %a']}
```

## .xctool-args

```
[
  "-project",  "YourProjectName",
  "-scheme", "YourScheme",
  "-configuration", "Debug",
  "-sdk", "iphonesimulator"
]
```

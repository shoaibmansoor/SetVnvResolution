SetVncServerResolution
===

Node module to set vnc resolution based on [link](https://superuser.com/a/1334787). 
It is also termed as **Headless Windows** display resolution.  

Features
--------

* **Simple**, **Robust** and **Easy** to use
* Fully customizable by providing different sets of arguments
* No manual intervention required

# Install
```shell
npm i set-vnc-server-resolution

# For easier cli usage install the package globally
npm i -g set-vnc-server-resolution
```

# Usage

From CLI:

```shell
set-vnc-server-resolution -w=1024 -h=768
or
set-vnc-server-resolution --width=1024 --height=768
```


## Commandline Arguments:
* -h, --height: To set height of vnc server [default: 1080] (optional)
* -w, --width: To set width of vnc server [default: 1920] (optional)
* --help: To get help messages

### Any Questions ? Report a Bug ? Enhancements ?
Please open a new issue on [GitHub](https://github.com/shoaibmansoor/SetVnvResolution/issues)

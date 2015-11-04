---
comments: true
layout: post
title: Running a WSGI app via Gunicorn from Python
tags:
- How-to
- Software
- Python
- WSGI
- Gunicorn
---

Anyone who's familiar with Gunicorn will know just how simple it is to get up
and running; `gunicorn myapp.wsgi`.

For a little project I'm working on I wanted to take this up a level and run
Gunicorn from a Python script, passing in any options as required and not
relying on sys.argv.

Because of the way most the Gunicorn application classes are written they
expect to be run from the console_scripts setup and have rather close
integration.

Unfortunately this made getting to the point of running `run.py`
and having Gunicorn start, rather harder than it needed to be.

For the purposes of this post my WSGI application is the example Flask app;

```python
# myapp.wsgi
from flask import Flask

application = Flask(__name__)

@application.route("/")
def hello():
    return "Hello World!"

if __name__ == "__main__":
	application.run()
```

Now, to get this running under Gunicorn we need to create a custom application

```python
# myapp.mycustomapplication
from gunicorn.app.base import Application
from gunicorn import util

class MyCustomApplication(Application):
    '''
    Custom Gunicorn Application
    '''

    def __init__(self, options={}):
        '''__init__ method

        Load the base config and assign some core attributes.
        '''
        self.usage = None
        self.callable = None
        self.options = options
        self.do_load_config()

    def init(self, *args):
        '''init method

        Takes our custom options from self.options and creates a config
        dict which specifies custom settings.
        '''
        cfg = {}
        for k, v in self.options.items():
            if k.lower() in self.cfg.settings and v is not None:
                cfg[k.lower()] = v
        return cfg

    def load(self):
        '''load method

        Imports our application and returns it to be run.
        '''        
        return util.import_app("myapp.wsgi")
```

As far as I can tell the minimum methods you can define is 3;

1. `__init__` - This sets up our base attributes
2. `init` - This is called to load option settings, we use self.options
to set the cfg items.

3. `load` - This loads the application so when `wsgi()` is called the
app runs!

To run the application we just need to initialize the MyCustomApplication
class, passing any options as required.

```python
#!/usr/bin/env python
# myapp.run

from myapp.mycustomapplication import MyCustomApplication

if __name__ == "__main__":
    options = {
        'bind': 'localhost:8080',
    }

    MyCustomApplication(options).run()
```

In practice you'd probably load the options from a config file in your program.


Hopefully this should help you getting Gunicorn running smoothly in a more
integrated manner :)

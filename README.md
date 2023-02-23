#  How to setup

Ok, there is some steps you need to make before you can build this.

Yuo need to build Python packages for embeding and put them following the scheme below

- `imgine/Resources/Python/Resources/app_packages`: side libraries such as numpy and torch
- `imgine/Resources/Python/Resources/python-stdlib`: python standard library
- `imgine/Resources/Frameworks/Python.xcframework`: Python framework

I'm using beeware briefcase for this. You can read tutorial here: https://docs.beeware.org/en/latest/

### Preparing Beeware briefcase

##### 1. Make empty beeware project somewhere, create virtual env and activate it
```
$ mkdir beeware-tutorial
$ cd beeware-tutorial
$ python3 -m venv beeware-venv
$ source beeware-venv/bin/activate
```

##### 2. install briefcase dependency
```
$ python -m pip install briefcase
```

##### 3. make empty briefcase project
```
$ briefcase new
```
It doesnt matter what you specify on setup. BUT! On GUI framework setup it is recomended to use None

##### 4. Install dependecines
```
$ python -m pip install httpx
```

##### 5. Add those dependencies to briefcase config file

in the file `pyproject.toml` of briefcase project folder find 

```
requires = []
```

and change it to:

```
requires = [
    "numpy",
    "torch"
]
```

##### 6. Build frameworks and stuff

```
$ briefcase build macOS Xcode
```

if you ever need update use:

```
$ briefcase update -r macOS Xcode
```

##### 7. Copy python stuff

briefcase will produce some files at `{briefcase_project}/macOS/Xcode/{project_name}`

- `imgine/Resources/Python/Resources/app_packages`: side libraries such as numpy and torch 
  from `{briefcase_project}/macOS/Xcode/{project_name}/{project_name}/app_packages`
- `imgine/Resources/Python/Resources/python-stdlib`: python standard library 
  from `{briefcase_project}/macOS/Xcode/{project_name}/Support/python-stdlib`
- `imgine/Resources/Frameworks/Python.xcframework`: Python framework 
  from `{briefcase_project}/macOS/Xcode/{project_name}/Support/Python.xcframework`

---

Thats all.

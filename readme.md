# Introduction of Python boilerplate

This is a python boilerplate, it enables you to develop a python project without having to handle environment issues, python version issues, packages management..

The magic is:

- This python boilerplate utilize the docker and vscode 'devcontainer' tech.

# How to use it

1. install docker in your computer, or your server
2. Open vscode, install 'Dev Containers' extension
3. git pull this project
4. use vscode open the folder of this project, click the button in the bottom left corner, and then choose 'Reopen in container' option in the dropdown list (if vscode fails to reopen, check question 1)
5. Now you can develop your project on vscode.

- vscode will copy your project into docker
- everying changes of your project files in docker, will sync to your host computer
- you can directly write codes in the docker env by vscode
- if you need to add a python package, just use 'poetry add package_name' to install. Run this command in the docker terminal in your vscode
- you can also use git add, git commit in docker terminal, but might not be able to git push, as your docker doesn't have a SSH private key to your github project. You can use git push on your host computer though.

Python env, package management tools, git tools are all already installed in docker, you don't have to take care of them.

# Questions

1. if vscode fails to reopen because vscode doesn't find your docker, then input 'which docker' in your terminal, copy the output (which is the path of your docker), then open vscode setting.json, add the line below into setting.json

```json
"dev.containers.dockerPath": "the path of your docker"
```

# About this image

This is an unofficial Docker image for the `pas2js` transpiler. It lets you convert Pascal programs or units into JavaScript modules without installing the `pas2js` tool or the Free Pascal Compiler (FPC) on the host.

## Run `pas2js` against source files

A common pattern is to mount your project directory into the container and run `pas2js` with input/output paths inside the container:

```sh
# from your project directory containing MyUnit.pas
docker run --rm -v "$PWD":/src olatov/pas2js:latest pas2js /src/MyUnit.pas -o /src/MyUnit.js
```

Notes:
- Use `-v "$PWD":/src` on Linux/macOS. On Windows PowerShell you may use `${PWD}` or run from Git Bash where `"$PWD"` works.

## Additional flags

Any `pas2js` CLI flags can be appended after the command in the `docker run` invocation. Example:

```sh
docker run --rm -v "$PWD":/src olatov/pas2js:latest pas2js /src/MyUnit.pas -d -O2 -o /src/MyUnit.js
```


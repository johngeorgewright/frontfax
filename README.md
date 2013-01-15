Nethode
=======

Sets up a development environment for frontend developers of Methode sites at Fairfax Media.

Installation
------------

1. Install [node](http://nodejs.org) and [npm](https://npmjs.org)
2. Clone this repo `git clone https://bitbucket.org/johngeorgewright/nethode.git`
3. Install the dependencies `npm i`
4. Start the server `npm start`
5. Then [view the server](http://localhost:8080)

Your Workspace
--------------

By default, before looking at the configured production server, nethode will first check your "workspace". By default it will exist in `../nethode-workspace`. This, together with all other configurations can be configured in a `.env` file.

This is the process in which nethode handles each HTTP request:

1. Receives a request (for example /images/logo.png).
2. Tries to find it in your workspace. If found the file is returned and the process stops here.
3. Proxies the request to the configured production server and returns the result.

Configuration
-------------

To change any configuration of Nethode edit (or create) the `.env` file found in the root of the nethod project.

The file should be in the following format:

```
CONFIG_NAME=value
OTHER_CONFIG_NAME=other value
```

### Configuration Options

- WORKSPACE *Your workspace directory. Needs to be either an absolute path or relative to the nethode root. __Default `../nethode-workspace`__*
- PRODUCTION_HOSTNAME *The production host where remote files will be retreived from. __Default `172.16.133.43`__*
- PRODUCTION_PORT *The production port. __Default `51161`__*


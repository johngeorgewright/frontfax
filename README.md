Frontfax
=======

Sets up a development environment for frontend developers of Methode sites at Fairfax Media.

Installation
------------

1. Install [node](http://nodejs.org) and [npm](https://npmjs.org)
2. Clone this repo `git clone https://bitbucket.org/johngeorgewright/frontfax.git`
3. Install the dependencies `npm i`
4. Start the server `npm start`
5. Then [view the server](http://localhost:8080)
6. After any further configurations create all the required directories for your project with the following command:

   ```sh
   cake -P [PROJECT] setup:workspace
   ```

   ... where `[PROJECT]` is your project name (IE brw2). This needs to be same as what's used on the dev URL (IE `http://172.16.133.43:51161/[PROJECT]`).


Your Workspace
--------------

By default, before looking at the configured production server, frontfax will first check your "workspace". By default it will exist in `../frontfax-workspace`. This, together with all other configurations can be configured in a `.env` file.

This is the process in which frontfax handles each HTTP request:

1. Receives a request (for example /brw2/images/logo.png).
2. Tries to find it in your workspace (../frontfax-workspace/brw2/images/logo.png). If found the file is returned and the process stops here.
3. Proxies the request to the configured production server and returns the result.


Configuration
-------------

To change any configuration of Frontfax edit (or create) the `.env` file found in the root of the nethod project.

The file should be in the following format:

```
CONFIG_NAME=value
OTHER_CONFIG_NAME=other value
```

### Configuration Options

- WORKSPACE *Your workspace directory. Needs to be either an absolute path or relative to the frontfax root. __Default `../frontfax-workspace`__*
- PRODUCTION_HOSTNAME *The production host where remote files will be retreived from. __Default `172.16.133.43`__*
- PRODUCTION_PORT *The production port. __Default `51161`__*

Working on a site
-----------------

Just like the dev server (172.16.133.42:51161) your projects will live at `/[project]` I.E. `http://localhost:8080/brw2`.

### CSS (LESS)

CSS assets can be written in LESS. The advantages are:

- Syntax is the same as CSS, so even if you don't want to use LESS's functionality you can just write plain CSS.
- You can compile a selection of files in to one.

When a request comes in to `/brw2/r/SysConfig/WebPortal/brw2/_files/css/main.css` the process will be:

- Looks for a LESS file at `../frontfax-workspace/brw2/assets/less/main.less`. If it is found it will be rendered to `../frontfax-workspace/brw2/build/css/main.css`.
- Looks for the file `../frontfax-workspace/brw2/build/css/main.css`. If it is found the process will end here and the file is returned.
- Looks for the file `../frontfax-workspace/brw2/r/SysConfig/WebPortal/brw2/_files/css/main.css`

When writing your less files, it is recommended to have one "main" file that includes all the requirements. This means that only one file needs to be uploaded to the production server after development.

Here's an example. Try to split your work in to many easy to read files.

```less
/* assets/header.less */

.header {
	.nav {
		/* nav styles */
	}

	.logo {
		/* logo styles */
	}
}
```

```less
/* assets/article.less */

.article {
	.picture {
		/* picture styles */
	}

	.teaser {
		/* teaser styles */
	}
}
```

```less
/* assets/main.less */

@import 'header';
@import 'article';
```

Now you can point to one CSS file (`/brw2/r/SysConfig/WebPortal/brw2/_files/css/main.css`) and have all your CSS returned:

```css
/* build/main.css */

.header .nav {
	/* nav styles */
}
.header .logo {
	/* logo styles */
}
.article .picture {
	/* picture styles */
}
.article .teaser {
	/* teaser styles */
}
```

### JavaScript

Editing JavaScript files are even simpler. Point to `/brw2/r/SysConfig/WebPortal/brw2/_files/js/main.js` and all files in the `../frontfax-workspace/brw2/assets/js` directory are combined and returned.

If you would like to build the combined all your JS in to one file ibefore uploading to methode, run the following command in the frontfax directory.

```sh
cake -P brw2 build:js
```

This will then combine all the files placed in `../frontfax-workspace/brw2/assets/js` in to `../frontfax-workspace/brw2/build/js/main.js`.

Bugs
----

Report all bugs in the [Bitucket issue list](https://bitbucket.org/johngeorgewright/frontfax/issues).


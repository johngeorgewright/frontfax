Frontfax
=======

Sets up a development environment for frontend developers that can't access the source code. Recently, at the last couple of places that I've been working, it's been somewhat impossible to access the source code of the working project, and therefore, I've been downloading the source via the web, working on it and then posting it back to backend developers to insert in to the project. This is somewhat annoying, so I've developed **Frontfax**.

Installation
------------

1. Install [node](http://nodejs.org) and [npm](https://npmjs.org)
2. Install Frontfax `[sudo] npm i -g frontfax` (TODO: It hasn't been released to NPM yet.
3. Create a project `frontfax project:new myproject`
4. Install the dependencies `cd myproject && npm i`
5. Start the server `npm start`
6. Then [view the server](http://localhost:5000)

Your Workspace
--------------

	- myproject
		- assets
			- css
			- images
			- js
			- less

This is the process in which frontfax handles each HTTP request:

1. Receives a request (for example /images/logo.png).
2. Tries to find it in your workspace (assets/images/logo.png). If found the file is returned and the process stops here.
3. Proxies the request to the configured proxy server and returns the result.

### URL Configuration

The images, js and css URLs are can configured, but these files will always be accessed from you assets directory.

### LESS

While you're working on any less files they will automatically be converted in to css and placed in the css directory.

The advantages are of writing you CSS as LESS are:

- Pre-processing functionality
- Syntax is the same as CSS, so even if you don't want to use LESS's functionality you can just write plain CSS.
- You can compile a selection of files in to one.

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

### JS Combine

While you're working on any js files they will automatically be combined into js/main.js

Configuration
-------------

The configuration file exists at `config/default.json`.

### Options

- **base**          : A base URL which all HTTP request should be prefixed with.
- **assets.css**    : The CSS URL (I.E. /stylesheets)
- **assets.images** : The images URL (I.E. /files/images)
- **assets.js**     : The JavaScript URL (I.E. /javascripts)

### CSS (LESS)



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


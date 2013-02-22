Frontfax
========

Sets up a development environment for frontend developers that can't access the source code. Recently, at the last couple of places that I've been working, it's been somewhat impossible to access the source code of the working project, and therefore, I've been downloading the source via the web, working on it and then posting it back to backend developers to insert in to the project. This is somewhat annoying, so I've developed **Frontfax**.

Installation
------------

1. Install [node](http://nodejs.org) and [npm](https://npmjs.org)
2. Install Frontfax `[sudo] npm i -g frontfax`

Creating a Project
------------------

1. Create a project `frontfax new myproject`
2. Change in to the project's directory `cd myproject`
3. Start the server `npm start`
4. Then [view the server](http://localhost:5000)

Your Workspace
--------------

	- myproject
		- assets
			- css
			- images
			- js
				- src
			- less
		- static

This is the process in which frontfax handles each HTTP request:

1. Receives a request (for example /images/logo.png).
2. Tries to find it in your workspace (assets/images/logo.png). If found the file is returned and the process stops here.
3. Proxies the request to the configured proxy server and returns the result.

### Proxying

The greatest feature of Frontfax is it's ability to target a proxy server for files that don't exist on your computer. To configure the proxy target open `config/default.json` and change the `proxy` option:

```js
{
	...
	"proxy": "http://www.the.site.im.working.on.com"
	...
}
```

### URL Configuration

The images, js, css URLs are can configured, but these files will always be accessed from you assets directory.

The `static` directory is the last place the server looks before proxying the request. This is good for HTML files. You do not need to configure the URL for this as it will consider the root to be accessible from the static directory.

To change the URLs open the `config/default.json` file and edit the `[image|css|js].paths` urls. 

### LESS

To install LESS support run the following command in your project directory `frontfax add --less`.

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

Now you can point to one CSS file (`/my/configured/css/path/main.css`) and have all your CSS returned:

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

While you're working on any js files they will automatically be combined from assets/js/src/*.js into assets/js/main.js.

### Templating

While working on your static files in the `static` directory, you can also use a variety of templating languages.

#### [Jade](http://jade-lang.com/)

1. Install jade `npm i jade`
2. Use the jade extension (`.jade`) when editing your templates

#### [Coffee-Cup](https://github.com/gradus/coffeecup)

1. Install coffee cup `npm i coffeecup`
2. Use the coffee extension (`.coffee`) when editing your templates

#### [Swig](http://paularmstrong.github.com/swig/)

1. Install consolidate and swig `npm i consolidate swig`
2. All html files will now be parsed with swig.

Bugs
----

Report all bugs in the [Bitucket issue list](https://bitbucket.org/johngeorgewright/frontfax/issues).


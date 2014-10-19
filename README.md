# Sailor Module Message

[![Build Status](http://img.shields.io/travis/sailorjs/sailor-module-messenger/master.svg?style=flat)](https://travis-ci.org/sailorjs/sailor-module-messenger)
[![Dependency status](http://img.shields.io/david/sailorjs/sailor-module-messenger.svg?style=flat)](https://david-dm.org/sailorjs/sailor-module-messenger)
[![Dev Dependencies Status](http://img.shields.io/david/dev/sailorjs/sailor-module-messenger.svg?style=flat)](https://david-dm.org/sailorjs/sailor-module-messenger#info=devDependencies)
[![NPM Status](http://img.shields.io/npm/dm/sailor-module-messenger.svg?style=flat)](https://www.npmjs.org/package/sailor-module-messenger)

> Messaging System between Users

## Install

```bash
sailor install sailor-module-message [--save or --save-dev]
```

## API

### Basic CRUD

### created a new message

```
POST /message
```

The minimum information to create a new message is:

```json
{
	to: "userID",
	from: "userID",
	text: "yourMessageText"
}
```

Additionally you can specify the status. By default the status is `unread`.


The rest of CRUD method is following [sailor-module-blueprints](https://github.com/sailorjs/sailor-module-blueprints) schema. 

Check tests for more information and sample usages.


## License

MIT © sailorjs



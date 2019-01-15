---
id: impress-router
title: impress-router
---

> express style router for koa v2

<div class="badges">

[![Build Status](https://img.shields.io/travis/magicdawn/express-modern.svg?style=flat-square)](https://travis-ci.org/magicdawn/impress-router)
[![Coverage Status](https://img.shields.io/codecov/c/github/magicdawn/impress-router.svg?style=flat-square)](https://codecov.io/gh/magicdawn/impress-router)
[![node version](https://img.shields.io/node/v/impress-router.svg?style=flat-square)](https://www.npmjs.com/package/impress-router)
[![npm version](https://img.shields.io/npm/v/impress-router.svg?style=flat-square)](https://www.npmjs.com/package/impress-router)
[![npm downloads](https://img.shields.io/npm/dm/impress-router.svg?style=flat-square)](https://www.npmjs.com/package/impress-router)
[![npm license](https://img.shields.io/npm/l/impress-router.svg?style=flat-square)](http://magicdawn.mit-license.org)
[![Greenkeeper badge](https://badges.greenkeeper.io/magicdawn/impress-router.svg)](https://greenkeeper.io/)

</div>

## Install

```sh
npm i impress-router -S
```

## basic usage

```js
const App = require('koa')
const Router = require('impress-router')

const app = new App()
const router = new Router()
app.use(router)
```

## `new Router(opts)`

opts

| key           | type      | default | description                                                                                                      |
| ------------- | --------- | ------- | ---------------------------------------------------------------------------------------------------------------- |
| `strict`      | `Boolean` | `false` | when `false` the trailing `/` is optional`, see [path-to-regexp](https://github.com/pillarjs/path-to-regexp) doc |
| `sensitive`   | `Boolean` | `false` | when `false`, case is not`sensitive`, see [path-to-regexp](https://github.com/pillarjs/path-to-regexp) doc       |
| `mergeParams` | `Boolean` | `true`  | when `true`, merge params when we have nested routers                                                            |
| `useThis`     | `Boolean` | `true`  | when `true`, the handler`this`equal to`ctx`, like koa v1 does                                                    |

## `router.use([path], middleware)`

> middleware can be mount on path, or on the root path `/`

#### arguments

| name         | type                           | required | default | description    |
| ------------ | ------------------------------ | -------- | ------- | -------------- |
| `path`       | `String`                       | `false`  | `'/'`   | the mount path |
| `middleware` | `Function` / `Array<Function>` | `true`   |         | the handler    |

> in the handler, `ctx` will have some extra prop attached
>
> - `ctx.basePath` the mount path
> - `ctx.path` the path with `ctx.basePath` trimed
> - `ctx.originalPath` the untrimed path
>
> It's kind like Express `req.baseUrl` / `req.originalUrl` does

for Example

```js
const App = require('koa')
const Router = require('impress-router')

const app = new App()
const router = new Router()
app.use(router)

router.use('/public', (ctx, next) {
  // when requesting `/public/js/foo.js`
  ctx.path // `/js/foo.js`
  ctx.basePath // `/public`
  ctx.originalPath // `/public/js/foo.js`
  return next()
})
```

> when we request `/public/js/foo.js`
>
> - `ctx.path` will be `/js/foo.js`
> - `ctx.basePath` will be `/public`
> - `ctx.originalPath` will be `/public/js/foo.js`

## `router.method(path, handler)`

- `get` / `post` / `...` methods exposed by `methods` module are supported
- `all` method supported, via `router.all(path,fn)`
- auto `OPTIONS` response, the router automatic build the `Allow` response
- auto `HEAD` response

#### Example

```js
const app = new (require('koa'))()
const router = new (require('impress-router'))()
app.use(router)

router.get('/hello', ctx => {
  ctx.body = 'world'
})

router.all('/foo', ctx => {
  ctx.body = 'bar'
})
```

### `ctx.params`

```js
const app = new (require('koa'))()
const Router = require('impress-router')
const router = new Router()
app.use(router)

const userRouter = new Router()
router.use('/user/:uid', userRouter)

userRouter.get('/:field', ctx => {
  ctx.body = {
    uid: ctx.params.uid,
    field: ctx.params.field,
  }
})

// GET /user/magicdawn/name
// =>
// { uid: 'magicdawn', field: 'name' }
```

## router.augmentApp(app)

> this method will augment the koa app instance, will

- add `app.use(path, middleware)` support, the original `app.use` lack support of `path`
- add `app.get` / `app.post` support

## Why

- express.Router is very nice
- koa-router package is not very friendly, especially on middleware mount on path

so I'm porting it to koa

## License

the MIT License http://magicdawn.mit-license.org

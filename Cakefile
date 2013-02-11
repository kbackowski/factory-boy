{spawn, exec} = require 'child_process'

build = (callback) ->
  exec 'mkdir -p lib', (err, stdout, stderr) ->
    throw new Error(err) if err
    exec "./node_modules/.bin/coffee --compile --output lib/ src/", (err, stdout, stderr) ->
      throw new Error(err) if err
      callback() if callback

watch = (callback) ->
  exec 'mkdir -p lib', (err, stdout, stderr) ->
    throw new Error(err) if err
    app = spawn "./node_modules/.bin/coffee", ['-w', '-c', '-o', 'lib', 'src']
    app.stdout.pipe(process.stdout)
    app.stderr.pipe(process.stderr)
    app.on 'exit', (status) -> callback?() if status is 0

clean = (callback) ->
  exec 'rm -fr lib/', (err, stdout, stderr) ->
    throw new Error(err) if err
    callback() if callback

task 'build', 'Build lib from src', -> build()
task 'watch', 'Build and watch lib from src', -> watch()
task 'clean', 'Remove generate lib folder', -> watch()

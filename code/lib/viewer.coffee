---
---

### Ben Scott # 2015-10-26 # Viewer ###

'use strict' # just like JavaScript

### Constants & Aliases ###
{abs,floor,random,sqrt} = Math # destructuring fun
T = THREE

### DOM ###
dir = "/js/assets" # directory
divID = "CoffeeCode" # id of parent
container = null # parent in the HTML document

### WebGL ###
loader = new T.JSONLoader()
textureLoader = new T.TextureLoader()

### `Main`

This is the program entrypoint, and it initializes all of the
[Three.js][] objects.
- `@scene`: An object representing everything in the
    environment, including `camera`s, 3D models, etc.
- `@camera`: The main rendering viewpoint, typically uses
    perspective rather than orthogonal rendering.
- `@renderer`: ... I'll... get back to you about exactly
    what it is that this one does!
###
class Main
    constructor: (filename) ->
        @scene = new T.Scene()
        @scene.fog = new T.Fog(0x00,2**12,2**16)
        @camera = new T.PerspectiveCamera(
            75,768/512,1,65536)
        @renderer = new T.WebGLRenderer {
            antialias: true, alpha: true }
        @renderer.setSize(768,512)
        @renderer.setClearColor(0x0,0)
        @ambient = new T.AmbientLight(0x404040)
        @scene.add @ambient
        @light = new T.DirectionalLight(0xEFEFED,1)
        @light.position.set(512,512,512)
        @scene.add @light
        @import3D(filename)

    init: (distance = 1024) ->
        @initDOM()
        @initControls()
        @camera.position.z = distance
        @render()

    initDOM: ->
        container = document.getElementById(divID)
        container.appendChild(@renderer.domElement)

    initControls: ->
        @controls = new T.OrbitControls(
            @camera,@renderer.domElement)
        @controls.userZoom = false

    update: ->
        @controls.update()

    ### `Main.render`

    This needs to be a bound function, and is the callback
    used by `requestAnimationFrame`, which does a bunch of
    stuff, e.g., calling render at the proper framerate.
    ###
    render: =>
        requestAnimationFrame(@render)
        @update()
        @renderer.render(@scene,@camera)

    ### `Main.import3D`

    This needs to be a bound function, and is the callback
    used by the `JSONLoader` to initialize geometry from
    the provided filename.
    ###
    import3D: (filename) =>
        albedo = textureLoader.load(
            "#{dir}/#{filename}_albedo.png")
        normal = textureLoader.load(
            "#{dir}/#{filename}_normal.jpg")
        spec = textureLoader.load(
            "#{dir}/#{filename}_spec.png")

        loader.load(
            "#{dir}/#{filename}.js"
            (geo) =>
                mat = new T.MeshPhongMaterial {
                    color: 0xAEAEAE
                    specular: 0xAAAAAA
                    shininess: 10
                    map: albedo
                    specularMap: spec
                    normalMap: normal
                    normalScale: new T.Vector2(0.8,0.8) }
                mesh = new T.Mesh(geo, mat)
                mesh.scale.set(50,50,50)
                @scene.add mesh)

### `@initViewer`

This is a global function, callable from other scripts, and
will be used with another script on the page to load an
arbitrary 3D model into a basic scene.
###
@initViewer = (filename, distance=1024) =>
    main = new Main(filename)
    main.init(distance)


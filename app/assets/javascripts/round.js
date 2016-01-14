(function() {
    "use strict";

    /*
     * Custom exception
     */
    var Exception = function(message) {
        this.message = "ERROR: " + message;
        this.name = "UserException";
        console.error(this.message);    
    }

    /*
     * $http
     * Wraps XMLHttpRequest() with Promise magic
     */
    var $http = function(url) {
        var core = {
            // Method that performs the ajax request
            ajax: function (method, url, args) {
                // Creating a promise
                var promise = new Promise(function (resolve, reject) {
                    // Instantiates the XMLHttpRequest
                    var client = new XMLHttpRequest();
                    var uri = url;
                    
                    //Encode data as a URL string for POSTs or PUTs
                    if (args && (method === 'POST' || method === 'PUT')) {
                        uri += '?';
                        var argcount = 0;
                        for (var key in args) {
                            if (args.hasOwnProperty(key)) {
                                if (argcount++) {
                                    uri += '&';
                                }
                                uri += encodeURIComponent(key) + '=' + encodeURIComponent(args[key]);
                            }
                        }
                    }
                    
                    //Send request to client
                    client.open(method, uri);
                    client.send();

                    //Resolve promise object on callback
                    client.onload = function () {
                        if (this.status >= 200 && this.status < 300) {
                            // Performs the function "resolve" when this.status is equal to 2xx
                            resolve(this.response);
                        } else {
                            // Performs the function "reject" when this.status is different than 2xx
                            reject(this.statusText);
                        }
                    }
                    //Reject the promise if the service is unreachable
                    client.onerror = function () {
                        reject(this.statusText);
                    }
                });
                // Return the promise
                return promise;
            }
        };
        //Expose methods to user
        return {
            'get': function(args) {
                return core.ajax('GET', url, args);
            },
            'post': function(args) {
                return core.ajax('POST', url, args);
            },
            'put': function(args) {
                return core.ajax('PUT', url, args);
            },
            'delete': function(args) {
                return core.ajax('DELETE', url, args);
            }
        };
    };

    /*
     * Replay
     * Displays a Replay of a given round
     * element {DOMelement} HTML element to bind the viewer to
     * assetsUrl {string} Absolute URL to the referee assets, http://localhost/referee/(refname)/assets/ 
     * MatchID {string} ID of the match that this round is contained in
     * RoundID {string} Round ID
     */
    var Replay = function(element, assetsUrl, MatchID, RoundID) {
        var self = this;

        self.MatchID = MatchID;
        self.RoundID = RoundID;
        self.assetsUrl = assetsUrl;
        self.element = element;

        self.moveNumber = -1;

        self.round = {};

        self.init();
    }

    /*
     * init()
     * Start the replay object, generate the layout elements, and load the round file
     */
    Replay.prototype.init = function() {
        var self = this;

        //Hook for plugins
        self.initPlugin();

        self.generateLayout();
        self.createControls();
        self.initRenderer();
        self.loadRound();
    }

    /*
     * togglePlayState()
     * Toggles playing the game
     */
    Replay.prototype.togglePlayState = function(state) {
        var self = this;

        //Default increment value
        self.playIncrement = self.playIncrement || 4;

        //Toggle playing variable back and forth
        if (typeof(state) === "boolean") {
            self.playing = state;
        } else {
            self.playing = (!self.playing) ? true : false;
        }
        
        //Create interval
        if (self.playing) {
            self.playButton.innerHTML = '<i class="fa fa-pause"></i>';
            self.playInterval = window.setInterval(self.play.bind(self), self.playIncrement * 1000);
        } else {
            self.playButton.innerHTML = '<i class="fa fa-play"></i>';
            if (self.playInterval) clearInterval(self.playInterval);
        }
    }

    /*
     * play()
     * Play the animation
     */
    Replay.prototype.play = function() {
        var self = this;
        
        if (!self.playing) {
            clearInterval(self.playInterval);
            return;
        }
        
        if (self.moveNumber === self.round.moves.length) {
            self.togglePlayState();
            return;
        }
 
        //Load the next move
        self.loadMove(self.moveNumber + 1);
    }

    /*
     * loadRound()
     * Load the round JSON file given the matchID and the roundID
     */
    Replay.prototype.loadRound = function() {
        var self = this;

        //Create URL to json file file
        self.roundJsonUrl = [window.location.protocol + "//" + window.location.host, "match-logs", self.MatchID, self.RoundID + ".json"].join("/");

        //AJAX callback functions
        var callback = {
            success: function(data) {
                self.round = JSON.parse(data);
                self.roundLoaded();
            },
            error: function(data) {
                throw new Exception("Can't load round file");
            }
        };

        //Get round JSON log
        $http(self.roundJsonUrl).get().then(callback.success).catch(callback.error);
    }

    /*
     * initPlugin()
     * Hook for plugin to load
     * Stub function, implemented in plugin
     */
    Replay.prototype.initPlugin = function() {}

    /*
     * roundLoaded()
     * Run after the round has been loaded
     *
     */
    Replay.prototype.roundLoaded = function() {
        var self = this;
        self.displayMoves();

        //Display default gameboard
        self.loadMove(-1);
    }

    /*
     * generateLayout()
     * Creates HTML elements for the viewer
     */
    Replay.prototype.generateLayout = function() {
        var self = this;

        self.elements = {};

        self.elements["controls"] = document.createElement("div");
        self.elements["renderer"] = document.createElement("div");
        self.elements["moves-viewer"] = document.createElement("ol");

        //Add elements to viewer
        for (var key in self.elements) {
            self.elements[key].classList.add(key);
            self.element.appendChild(self.elements[key]);
        }
    }

    /*
     * createControls
     */
    Replay.prototype.createControls = function() {
        var self = this;
        
        self.playButton = document.createElement("button");
        self.playButton.innerHTML = '<i class="fa fa-play"></i>';
        self.playButton.classList.add("play-button");

        self.playButton.addEventListener("click", self.togglePlayState.bind(self));

        self.elements["controls"].appendChild(self.playButton);
    }

    /*
     * displayMoves()
     * Generates HTML for displaying moves navigation to the user
     */
    Replay.prototype.displayMoves = function() {
        var self = this;

        var movesViewer = self.elements["moves-viewer"];

        self.elements["moves-controls"] = [];

        var move, view;

        for (var i = 0; i < self.round.moves.length; i++) {
            move = self.round.moves[i];
            view = document.createElement("li");
            view.setAttribute("id", "move-" + i);
            view.textContent = move["description"];
            movesViewer.appendChild(view);
            self.elements["moves-controls"].push(view);
        } 

        //Assign click event to moves viewer
        movesViewer.addEventListener("click", function(e) {
            if (e.target && e.target.nodeName === "LI") {
                var move = parseInt(e.target.id.replace("move-", ""));
                self.togglePlayState(false);
                self.loadMove(move);
            }
        });
    }

    /*
     * loadMove()
     * Display a move in the renderer
     * move {int} Index of move in moves object
     */
    Replay.prototype.loadMove = function(move) {
        var self = this;

        //Sepcial case, display default game board
        if (move === -1) {
            self.currentMoveIndex = move;
        } else {
            //Prevent invalid move indexes by wrapping the index to 0
            self.moveNumber = (move > self.round.moves.length || move < 0) ? 0 : move;

            self.currentMoveIndex = self.moveNumber;
            //Grab the move from the moves object
            self.currentMove = self.round.moves[self.currentMoveIndex];
        }

        //Calls user function to generate the game state for the current move
        self.generateGameState();

        //Update graphics to reflect current move
        self.render();
    }

    /*
     * render()
     * Takes gamestate and renders it to graphics window
     * Stub function, define in plugin
     */
    Replay.prototype.render = function() {}

    /*
     * generateGameState()
     * Generate the current gamestate based upon the current move
     * Stub function, define in plugin
     */
    Replay.prototype.generateGameState = function() {}

    /*
     * initRenderer()
     * Generates PIXI canvas element
     */
    Replay.prototype.initRenderer = function() {
        var self = this;

        //Create stage and renderer
        self.stage = new PIXI.Container();
        self.renderer = PIXI.autoDetectRenderer(self.rendererWidth, self.rendererHeight);
        
        //Add renderer to page
        self.elements["renderer"].appendChild(self.renderer.view);

        //Load all user defined textures
        self.loadTextures();

        //Reset sprites and load user sprites
        self.sprites = {};
        self.loadSprites();

        //Add sprites to stage
        self.spawnSprites();

        //Update on every animation frame (60 FPS)
        requestAnimationFrame(self.animate.bind(self));
    }


    /*
     * animate()
     * Update renderer state on every animation frame
     */
    Replay.prototype.animate = function() {
        var self = this;

        self.renderer.render(self.stage);

        requestAnimationFrame(self.animate.bind(self));
    }

    /*
     * loadTextures()
     * Stub function, defined in plugin
     * Loads all the textures
     */
    Replay.prototype.loadTextures = function() {}

    /* 
     * loadSprites()
     * Assign textures to sprites and load them in the view
     * Stub function, defined in plugin
     */
    Replay.prototype.loadSprites = function() {}


    /*
     * spawnSprites()
     * Add sprites to stage
     */
    Replay.prototype.spawnSprites = function() {
        var self = this;
        for (var key in self.sprites) {
            //Recursively load all the sprites in the sprites object
            self.spritesHelper(self.sprites[key]);
        }
    }

    /*
     * spritesHelper()
     * Recursively loop through sprites object and add new sprites to stage
     * obj {object} List of sprites or sprite
     */
    Replay.prototype.spritesHelper = function(obj) {
        var self = this;
        //Check if this is a PIXI object
        if ("_texture" in obj) {
            //Add to stage and render in viewer
            self.stage.addChild(obj);            
        } else {
            //Loop through children of current object
            for (var key in obj) {
                if (obj.hasOwnProperty(key)) {
                    self.spritesHelper(obj[key]);
                }
            }
        }         
    }

    /*
     * addTexture()
     * Add a texture to the textures object
     * name {string} name of the texture
     * url {string} Relative URL of the texture
     */
    Replay.prototype.addTexture = function(name, url) {
        var self = this;

        if (!self.textures) self.textures = {};
        if (name in self.textures) return;

        self.textures[name] = PIXI.Texture.fromImage(self.assetsUrl + url);
    }

 /*
     * parseJSON()
     * Helper function, replaces all single quotes with double quotes and parses the string as JSON
     * string {string} String to parse
     */
    Replay.prototype.parseJSON = function(string) {
        var self = this;
        //If this isn't a JSON string, don't parse it (simply return the object)
        if (typeof string !== "string") return string;
        //Try to parse string as JSON, otherwise return an empty object
        try {
            string = string.replace(/'/gi, '"');
            var obj = JSON.parse(string);
        } catch(e) {
            var obj = {};
        }
        return obj;
    }


    /*
     * copy()
     * Helper function to deep copy objects
     */
    Replay.prototype.copy = function(src) {
        var self = this;
        
        var mixin = function (dest, source, copyFunc) {
            var name, s, i, empty = {};
            for(name in source){
                // the (!(name in empty) || empty[name] !== s) condition avoids copying properties in "source"
                // inherited from Object.prototype.	 For example, if dest has a custom toString() method,
                // don't overwrite it with the toString() method that source inherited from Object.prototype
                s = source[name];
                if(!(name in dest) || (dest[name] !== s && (!(name in empty) || empty[name] !== s))){
                    dest[name] = copyFunc ? copyFunc(s) : s;
                }
            }
            return dest;
        }

        if (!src || typeof src != "object" || Object.prototype.toString.call(src) === "[object Function]") {
            // null, undefined, any non-object, or function
            return src;	// anything
        }
        if (src.nodeType && "cloneNode" in src) {
            // DOM Node
            return src.cloneNode(true); // Node
        }
        if (src instanceof Date) {
            // Date
            return new Date(src.getTime());	// Date
        }
        if (src instanceof RegExp) {
            // RegExp
            return new RegExp(src);   // RegExp
        }

        var r, i, l;
        if (src instanceof Array) {
            // array
            r = [];
            for(i = 0, l = src.length; i < l; ++i) {
                if (i in src) {
                    r.push(self.copy(src[i]));
                }
            }
        } else {
            // generic objects
            r = src.constructor ? new src.constructor() : {};
        }
        return mixin(r, src, self.copy.bind(self));
    }

    //Export class
    window.Replay = Replay
}).call(this)

console.log(PIXI);

	var stage = new PIXI.Stage(0x66FF99);

	var renderer = PIXI.autoDetectRenderer(722, 728,{backgroundColor: 0x1099bb});

	document.body.appendChild(renderer.view);

	requestAnimationFrame( animate );

	var checkerboard = PIXI.Texture.fromImage("checkerboard.png");
	var white = PIXI.Texture.fromImage("white.png");
	var black = PIXI.Texture.fromImage("black.png");
	var whiteKing = PIXI.Texture.fromImage("whiteKing.png");
	var blackKing = PIXI.Texture.fromImage("blackKing.png");

	var c = new PIXI.Sprite(checkerboard);

	var num_white = 12;
	var num_black = 12;

	var w = [];
	var b = [];

	//Create all the sprites for white and black pieces 
	for (var i = 0; i < 12; i++){ 
		w[i] = new PIXI.Sprite(white);
		b[i] = new PIXI.Sprite(black);
	}
	console.log(w);

	//Store position for each tile on the board
	// var board = {
 //        A: [[90, 0], [270, 0], [450, 0], [630, 0]],
 //        B: [[0, 91], [180]]
 //    }

	//Set starting positions for board and pieces
	c.position.x = -1;

	x_pos = 90;
	y_pos = 0;

	for (var i = 0; i < 12; i++){
		w[i].position.x = x_pos;
		w[i].position.y = y_pos;

		if (x_pos == 630){
			x_pos = 0;
			y_pos += 91;
		}
		else if (x_pos == 540){ 
			x_pos = 90;
			y_pos += 91;
		}
		else x_pos += 180;
	}

	x_pos = 0;
	y_pos = 455;

	for (var i = 0; i < 12; i++){
		b[i].position.x = x_pos;
		b[i].position.y = y_pos;

		if (x_pos == 630){
			x_pos = 0;
			y_pos += 91;
		}
		else if (x_pos == 540){ 
			x_pos = 90;
			y_pos += 91;
		}
		else x_pos += 180;
	}	
	
	//Add children to stage
	stage.addChild(c);
	for (var i = 0; i < 12; i++){ 
		w[i] = stage.addChild(w[i]);
		b[i] = stage.addChild(b[i]);
	}

	function animate() {
	    requestAnimationFrame( animate );

	    // render the stage   
	    renderer.render(stage);
	}
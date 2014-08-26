unit Game;

interface

	const 
		MapWidth = 10;
		MapHeight = 10;

		MinesInMap = 10;   	
	
	type
		TMapObject = (MO_NIL, MO_MINE);
		TGameState = (GS_NOSTARTED, GS_STARTED, GS_WIN, GS_OVER);
	
		TMapElm = record
			MapObject : TMapObject;
			Flag : boolean;
			Hide : boolean;
		end;		
	
        TGame = object
        
        		private
        			
        			GameState : TGameState;
        				
        			Map : array[0..MapWidth, 0..MapHeight] of TMapElm;	
        			FlagInMap : integer;
        
        			MapCurX, MapCurY : integer;
        							
       				procedure ClearMap; //Czysci mape
    	   			procedure SetMines; //Wstawia miny na plansze
       				function MinesARound(x, y : integer) : integer;
       				procedure ShowEmpy(x, y : integer); //Pokazuje puste pola 
       				
       				procedure ShowMines; //Pokazuje miny        

        
        		public
        			
        			procedure NewGame;
        			
        			function GetGameState : TGameState;
        		
        			procedure SetFlag;
        			procedure Show; //Pokazuje aktywne pole...
        			
        			procedure GoCurUp;
        			procedure GoCurRight;
        			procedure GoCurDown;
        			procedure GoCurLeft;
        			
        			procedure DrawMap;        				
    
        	end;	
	
implementation
		
	uses
		Crt;	
				
    procedure TGame.ClearMap;
    var 
    	i, j : integer;
    begin
    	for i := 0 to Mapwidth - 1 do
    		begin
    			for j := 0 to MapHeight - 1 do
    				begin
    					with Map[i][j] do
    						begin
    							MapObject := MO_NIL;
    							Flag := false;
    							Hide := true;
    						end;
    				end;
    		end;
    end;				
	
	procedure TGame.SetMines;
	var
		Count : integer = 0;
		x, y : integer;
	begin
		while Count <= MinesInMap do
			begin
				x := Random(10);
				y := Random(10);
				if Map[x][y].MapObject <> MO_MINE then
					begin
						Map[x][y].MapObject := MO_MINE;
						Inc(Count);
					end;
			end;
	end;

	function TGame.MinesARound(x, y : integer) : integer; //Liczy miny wokoło
	var
		tmp : integer = 0;
	begin
			if (x > 0) and (y > 0) and (Map[x - 1][y - 1].MapObject = MO_MINE) then Inc(tmp);
			if (y > 0 ) and (Map[x][y - 1].MapObject = MO_MINE) then Inc(tmp);
			if (x < MapWidth) and (y > 0) and (Map[x + 1][y - 1].MapObject = MO_MINE) then Inc(tmp);
			if (x > 0) and (Map[x - 1][y].MapObject = MO_MINE) then Inc(tmp);	
			if (x < MapWidth) and (Map[x + 1][y].MapObject = MO_MINE) then Inc(tmp);
			if (x > 0) and (y < MapHeight - 1) and (Map[x - 1][y + 1].MapObject = MO_MINE) then Inc(tmp);
			if (y < MapHeight) and (Map[x][y + 1].MapObject = MO_MINE) then Inc(tmp);
			if (x < MapWidth) and (y < MapHeight) and (Map[x + 1][y + 1].MapObject = MO_MINE) then Inc(tmp);
			MinesAround := tmp;	
	end;
		
	procedure TGame.ShowEmpy(x, y : integer); //TU jest błąd :/
	begin
		Map[x][y].Hide := false;
		if (y > 0 ) and (Map[x][y - 1].MapObject = MO_NIL) and (Map[x][y - 1].Hide = true) and (MinesARound(x, y -1) = 0) then
			begin
				ShowEmpy(x, y - 1);
			end;
		if (x > 0) and (Map[x - 1][y].MapObject = MO_NIL) and (Map[x - 1][y].Hide = true) and (MinesARound(x - 1, y) = 0) then
			begin
				ShowEmpy(x - 1, y);
			end;	
		if (x < MapWidth) and (Map[x + 1][y].MapObject = MO_NIL) and (Map[x + 1][y].Hide = true) and (MinesARound(x + 1, y) = 0) then
			begin
				ShowEmpy(x + 1, y);
			end;	
		if (y < MapHeight) and (Map[x][y + 1].MapObject = MO_NIL) and (Map[x][y +1].Hide = true) and (MinesARound(x, y +1) = 0) then
			begin
				ShowEmpy(x, y + 1);
			end;	
	end;	
				
	procedure TGame.ShowMines;
	var
		i, j : integer;
	begin
		for i := 0 to Mapwidth do
			begin
				for j := 0 to MapHeight do
					begin
						if Map[i][j].MapObject = MO_MINE then
							begin
								if not Map[i][j].Flag then Map[i][j].Hide := false;
							end
						else
							if Map[i][j].Flag then Map[i][j].flag := false;
					end;	
			end;
	end;				

	procedure TGame.NewGame;
	begin
		GameState := GS_STARTED;
		FlagInMap := 0;
		MapCurX := 0;
		MapCurY := 0;
		ClearMap;
		SetMines;	
	end; 
	
	function TGame.GetGameState : TGameState;
	begin
		GetGameState := GameState;
	end;
	
	procedure TGame.SetFlag;
	var	
		i, j : integer;	
	begin
		if Map[MapCurX][MapCurY].Hide = false then exit; 
		if Map[MapCurX][MapCurY].Flag then 
			begin			
				Map[MapCurX][MapCurY].Flag := false;
				Dec(FlagInMap); 	
			end	
		else 
			begin
				Map[MapCurX][MapcurY].Flag := true;
				Inc(FlagInMap);
			end;
		if FlagInMap - 1 = MinesInMap then //Sprawdzamy wygrana...
			begin			
				for i := 0 to MapHeight do
					begin
						for j := 0 to MapWidth do
							begin
								if (Map[i][j].MapObject = MO_NIL) and (Map[i][j].Flag) then
									begin
										exit;
									end;	
							end;
					end;
				GameState := GS_WIN;	
			end;	
	end;
		
	procedure TGame.Show;
	begin
		if (Map[MapCurX][MapCurY].Hide) and not(Map[MapCurX][MapCurY].Flag = true) then
			begin				
				if Map[MapCurX][MapCurY].MapObject = MO_NIL then					
					begin
						Map[MapCurX][MapCurY].Hide := false;
						if MinesARound(MapCurX, MapCurY) = 0 then ShowEmpy(MapCurX, MapCurY);
					end	
				else
					begin						
						GameState := GS_OVER;																
						MapCurX := -1;
						MapcurY := -1;
						ShowMines;
					end;	
			end;	
	end;
	
	procedure TGame.GoCurUp;
	begin
		if MapCurY > 0 then Dec(MapCurY);
	end;
	
	procedure TGame.GoCurRight;
	begin
		if MapCurX < MapWidth - 1 then Inc(MapCurX);
	end;
	
	procedure TGame.GoCurDown;
	begin
		if MapCurY < MapHeight - 1 then Inc(MapCurY);
	end;
	
	procedure TGame.GoCurLeft;
	begin
		if MapCurX > 0 then Dec(MapCurX);
	end;
	
	procedure TGame.DrawMap;
	var
		i, j : integer;
		
	function IsActive : boolean; //sprawdza czy aktualnbe pole jest polem aktywnym
	begin
		if (i = MapCurX) and (j = MapCurY) then
			IsActive := true
		else
			IsActive := false;
	end;
		
	begin
		TextBackground(0);
		ClrScr;
		for i := 0 to MapHeight - 1 do
			begin
				for j := 0 to MapWidth - 1 do
					begin
						GoToXY((j + 1) * 3 + 23, i + 7);
						with Map[i][j] do
							begin
								if Flag then 
									begin
										TextBackground(7);												
										if IsActive then //rysujemy pole z flaga
											begin
												TextColor(4);												
												Write('[');
												TextColor(4);
												Write('F');
												TextColor(4);	
												Write(']');
											end
										else
											begin
												TextColor(0);
												Write('[');
												TextColor(4);
												Write('F');
												TextColor(0);
												Write(']');
											end;
										continue;
									end;
								if Hide then
									begin
										TextBackground(7);
										if IsActive then
											begin
												TextColor(4);
												Write('[ ]');												
											end
										else
											begin
												TextColor(8);
												Write('[ ]');
											end;
									end
								else	
									begin
										if MapObject = MO_NIL then
											begin
												TextBackground(0);
												if IsActive then
													begin
														TextColor(4);														
														if MinesARound(i,j) = 0 then
															Write('[ ]')
														else
															begin
																Write('[');
																TextColor(1);
																Write(MinesARound(i,j));
																TextColor(4);
																Write(']');
															end;	
													end
												else
													begin
														if MinesARound(i,j) = 0 then
															begin
																TextColor(8);
																Write('[ ]');
															end	
														else
															begin
																TextColor(8);
																Write('[');
																TextColor(1);
																Write(MinesARound(i,j));
																TextColor(8);
																Write(']');
															end;
													end;
											end
										else //Rysujemy Miny...
											begin
												TextBackground(7);
												TextColor(4);
												Write('[M]');
											end;
									end;
							end;
					end;
			end;
	WriteLn;
	end;
	
end.

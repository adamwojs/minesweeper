unit MainMenu;

interface
	type 
		TMainMenu = object			
			private
				ActiveItem : integer;				
				MenuItems : array[0..2] of string;		
		
			public
				constructor Create;
				
				procedure DrawMenu;
								
				procedure CurUp;
				procedure CurDown;
				
				function GetActiveItem : integer;
		end;

implementation

	uses
		Crt;

	constructor TMainMenu.Create;
	begin
		MenuItems[0] := '    Nowa gra    ';
		MenuItems[1] := '     Pomoc      ';
		MenuItems[2] := '    Zakończ     ';
		ActiveItem := 0;
	end;
  
	procedure TMainMenu.DrawMenu;
	var
		i : integer;
	begin		
		TextBackground(0);
		ClrScr;
		
		TextColor(12);
		TextBackground(6);
		GoToXY(33, 6);
		Write('SaperPas');
		TextColor(4);
		Write(' v 1.0');
		GoToXY(33, 7);
		TextColor(7);
		TextBackground(0);
		Write('    by Adawo/SCT 2007');
		WriteLn;

		for i := 0 to 2 do
			begin
				GoToXY(35, 10 + i);
				if ActiveItem = i then 
					begin					
						TextColor(4);
						TextBackground(7);												
					end
				else
					begin
						TextColor(0);
						Textbackground(7);
					end;	
				Write(MenuItems[i]);	
			end;
		WriteLn;	
	end;

	procedure TMainMenu.CurUp;
	begin
		if ActiveItem > 0 then Dec(ActiveItem);
	end;
	
	procedure TMainMenu.CurDown;
	begin
		if ActiveItem < 2 then Inc(ActiveItem);
	end;
	
	function TMainMenu.GetActiveItem : integer;
	begin
		GetActiveItem := ActiveItem;
	end;
end.

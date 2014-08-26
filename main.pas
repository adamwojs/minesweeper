program SaperPas;

uses
	Crt, Game, MainMenu;	
	
var
	MainGame : TGame;		
	GameMenu : TMainMenu;
	Odp : char = #1;

procedure GameOverScreen;
begin
	TextBackground(0);
	ClrScr;
	GoToXY(37, 8);
	TextColor(12);
	Write('GAME IS OVER');
	GoToXY(37, 9);
	TextColor(7);
	Write('    R.I.P    ');
	GoToXY(25, 12);
	TextColor(4);
	Write('Saper myli się tylko 2 razy w życiu: ');
	GoToXY(25, 13);
	Write('        Raz: wybierając zawód        ');
	GoToXY(25, 14);
	Write('      Dwa: Trafiajać na mine...      ');
	WriteLn;
	ReadKey;
end;
	
procedure GameWinScreen;
begin
	TextBackground(0);
	ClrScr;
	GoToXY(22, 12);
	TextColor(1);
	Write('Brawo, udało Ci się przezyć...');
	ReadKey;
end;	 
	
procedure HelpScreen; //Wyswietla ekran pomocy...
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
	WriteLn;
	WriteLn;
	TextColor(15);
	WriteLn('Cel gry:');
	TextColor(7);
	WriteLn('    Oflagowanie wszystkich pól zaminowanych...');
	WriteLn;
	TextColor(15);
	WriteLn('Sterowanie:');
	TextColor(7);
	WriteLn('    Strzałki - przemiszczanie kursora');
	WriteLn('    Enter - odkrycie pola');
	WriteLn('    F - oflagowanie aktywnego pola');
	WriteLn;
	TextColor(15);
	WriteLn('Legenda:');
	TextColor(8);
	Write('    [ ]');
	TextColor(7);
	Write(' - Puste pole');
	WriteLn;
	Write('    ');
	TextBackground(7);
	TextColor(0);
	Write('[ ]');
	TextColor(7);
	TextBackground(0);
	Write(' - Nieodkryte pole');
	WriteLn;
	Write('    ');
	TextColor(8);
	Write('[');
	TextColor(1);
	Write(1);
	TextColor(8);
	Write(']');
	TextColor(7);
	Write(' - Ilosc min wokol pola');
	WriteLn;
	Write('    ');
	TextColor(8);
	Write('[');
	TextColor(4);
	Write('F');
	TextColor(8);
	Write(']');
	TextColor(7);
	Write(' - Pole oflagowane');
	WriteLn;
	Write('    ');
	TextBackground(7);
	TextColor(0);
	Write('[');
	TextColor(4);
	Write('M');
	TextColor(0);
	Write(']');
	TextBackground(0);
	TextColor(7);
	Write(' - Pole na którym znajduje sie mina');
	WriteLn;
	WriteLn;
	WriteLn('Nacisnij dowolny klawisz aby kontynulować...');
	readkey;
end;	
	
begin

	Randomize;
	
	GameMenu.Create;
	while Odp <> #27 do
		begin
			GameMenu.Drawmenu;
			Odp := ReadKey;
			case Odp of 
				#13 : 
					begin
						case GameMenu.GetActiveItem of
							0 : begin //Nowa gra
									MainGame.NewGame;
									while true do
										begin
											MainGame.DrawMap;
											Odp := ReadKey;
											case Odp of
												#0 :
													begin
														Odp := ReadKey;
														case Odp of
															#72 : MainGame.GoCurLeft;
															#75 : MainGame.GoCurUp;
															#77 : MainGame.GoCurDown;	
															#80 : MainGame.GoCurRight;
														end;	
													end;
												#13 : MainGame.Show;
												#27 : //Przerwanie gry...
													begin 
														Odp := #1;
														break;
													end;	
												#102 : MainGame.SetFlag;
												end;
											//Sprawdzamy czy nie gracz nie wygrał lyb przegrał
											if MainGame.GetGameState = GS_OVER then 
												begin				
													MainGame.DrawMap;
													ReadKey;																						
													GameOverScreen; // skladamy mu kondolencjie
													break;													
												end;	
											if MainGame.GetGameState = GS_WIN then 
												begin
													MainGame.DrawMap;
													ReadKey;
													GameWinScreen; 
													break;													
												end;	
										end; 
								end;
							1 : begin //Pomoc
									HelpScreen;
								end;	
							2 : begin
									TextBackground(0);
									ClrScr;
									Exit;
								end;
						end;		
					end;
				#0 : 
					begin
						Odp := ReadKey;
						case Odp of
								#72 : GameMenu.CurUP;
								#80 : GameMenu.CurDown;
							end;
					end;		
			end;
		end;
end.

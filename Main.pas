unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ComCtrls, UDisp, ExtCtrls;

type
  TFTesteEsc = class(TForm)
    Label1: TLabel;
    edNumTel: TEdit;
    lbMens: TLabel;
    pbMens: TProgressBar;
    btLig: TBitBtn;
    btDes: TBitBtn;
    Label3: TLabel;
    cbCom: TComboBox;
    Timer: TTimer;
    procedure btLigClick(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure btDesClick(Sender: TObject);
    procedure edNumTelKeyPress(Sender: TObject; var Key: Char);
  private
    Contador : integer;
    procedure EnviaMens(Mens : string);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FTesteEsc: TFTesteEsc;

implementation

{$R *.dfm}

procedure TFTesteEsc.btLigClick(Sender: TObject);
var
 Porta : TPort;
begin
//99370289
   EnviaMens('Verificando as informações ...');
   if (edNumTel.GetTextLen = 8)  or (edNumTel.GetTextLen = 13)then
   begin
      EnviaMens('Abrindo porta de comunicação ...');
      Porta := TPort.Create;
      if Porta.AbrPort(cbCom.ItemIndex + 1,8,NOPARITY,ONESTOPBIT,CBR_19200) = 0 then
      begin
         EnviaMens('Enviando configuração ...');
         Porta.EnvMens('ATE0' + #13 + #10);
         Porta.EnvMens('AT+MODE=2' + #13 + #10);
         if Porta.EnvMensEspResp(10000,'OK') then
         begin
            btLig.Enabled := false;
            EnviaMens('Discando ...');
            Porta.EnvMens('ATDT ' + edNumTel.Text + #13 + #10);
            if Porta.EnvMensEspResp(10000,'OK') then
            begin
               Contador := 30;
               Timer.Enabled := true;
               EnviaMens('Tempo restante para o teste : 30 segundos');
               Porta.FecPort;
            end
            else
            begin
               Application.MessageBox('Não foi possível completar a ligação !',
                                      'Atenção', MB_OK + MB_IconError);
               btLig.Enabled := true;
            end;
         end
         else
            Application.MessageBox('Não foi possível enviar o comando de configuração !',
                                   'Atenção',MB_OK + MB_IconError);
      end
      else
         Application.MessageBox('Não foi possível abrir a porta selecionada !','Atenção',
                                MB_OK + MB_IconError);
      Porta.Free;
   end
   else
      Application.MessageBox('Digite um número de telefone !','Atenção',
                             MB_OK + MB_IconError);
   if not Timer.Enabled then
   begin
      lbMens.Caption := '';
      pbMens.Position := 0;
   end;
   edNumTel.Text := '';
   edNumTel.SetFocus;
end;

procedure TFTesteEsc.EnviaMens(Mens: string);
begin
   lbMens.Caption := Mens;
   pbMens.Position := pbMens.Position + 1;
   Application.ProcessMessages;
end;

procedure TFTesteEsc.TimerTimer(Sender: TObject);
begin
   Dec(Contador);
   EnviaMens('Tempo restante para o teste : ' + IntToStr(Contador) + ' segundos');
   if Contador = 0 then
   begin
      Timer.Enabled := false;
      btDesClick(btDes);
   end;
end;

procedure TFTesteEsc.btDesClick(Sender: TObject);
var
 Porta : TPort;
begin
   Timer.Enabled := false;
   Porta := TPort.Create;
   if Porta.AbrPort(cbCom.ItemIndex + 1,8,NOPARITY,ONESTOPBIT,CBR_19200) = 0 then
      Porta.EnvMens('ATH' + #13 + #10);
   lbMens.Caption := '';
   pbMens.Position := 0;
   Porta.Free;
   btLig.Enabled := true;
end;

procedure TFTesteEsc.edNumTelKeyPress(Sender: TObject; var Key: Char);
begin
   if not ((Key in ['0'..'9']) or (Key = #8)) then
   begin
      Application.MessageBox('Digite somente números !','Atenção',MB_OK + MB_IconError);
      Key := #0;
      edNumTel.SetFocus;
   end;
end;

end.

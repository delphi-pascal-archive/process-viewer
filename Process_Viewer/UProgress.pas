unit UProgress;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Gauges, StdCtrls, Buttons, ExtCtrls;

type
  TfmProgress = class(TForm)
    Panel1: TPanel;
    pnSlow: TPanel;
    Label1: TLabel;
    lbF: TLabel;
    Label3: TLabel;
    lbFounded: TLabel;
    lbSize: TLabel;
    lbCurAddr: TLabel;
    Label4: TLabel;
    lbCurMod: TLabel;
    Label5: TLabel;
    lbModSize: TLabel;
    Label6: TLabel;
    lbPageProt: TLabel;
    Label7: TLabel;
    lbSearchTime: TLabel;
    pnProg: TPanel;
    Panel3: TPanel;
    gag: TGauge;
    btStop: TBitBtn;
    Label8: TLabel;
    lbRegSize: TLabel;
    Label9: TLabel;
    lbPageState: TLabel;
    Label10: TLabel;
    LbSizeFromReg: TLabel;
    procedure btStopClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormActivate(Sender: TObject);
  private
    procedure WMMinimize(var M: Tmessage);message WM_SYSCOMMAND;
  public
    procedure OnClose(Sender: TObject);
    { Public declarations }
  end;

var
  fmProgress: TfmProgress;
  VisibleProgress: Boolean;

implementation

uses UDump;
{$R *.DFM}

procedure TfmProgress.btStopClick(Sender: TObject);
begin
  breaksearch:=true;
  btStop.Caption:='Close';
  btStop.OnClick:=OnClose;
{  Hide;
  ShowModal;}
end;

procedure TfmProgress.OnClose(Sender: TObject);
begin
  close;
end;

procedure TfmProgress.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  breaksearch:=true;
end;

procedure TfmProgress.WMMinimize(var M: Tmessage);
begin
  case M.WParam of
    SC_MINIMIZE: begin
      ShowWindow(Handle,SW_MINIMIZE);
      ShowWindow(Application.Handle,SW_MINIMIZE);
    end;
  end;
  inherited;
end;

procedure TfmProgress.FormActivate(Sender: TObject);
begin
//  Application.Restore;
end;

end.

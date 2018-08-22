unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.TabControl,
  System.Bluetooth, System.Bluetooth.Components, FMX.Layouts, FMX.ListBox,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, BTconfig;

type
  TForm1 = class(TForm)
    TabControl1: TTabControl;
    TabItem1: TTabItem;
    TabItem2: TTabItem;
    Bluetooth1: TBluetooth;
    lst1: TListBox;
    btn1: TButton;
    Layout_Searching: TLayout;
    lbl1: TLabel;
    Rectangle1: TRectangle;
    Rectangle2: TRectangle;
    Rectangle3: TRectangle;
    AniIndicator3: TAniIndicator;
    AniIndicator4: TAniIndicator;
    btn2: TButton;
    lst2: TListBox;
    procedure FormShow(Sender: TObject);
    procedure btn1Click(Sender: TObject);
    procedure Bluetooth1DiscoveryEnd(const Sender: TObject;
      const ADeviceList: TBluetoothDeviceList);
    procedure FormCreate(Sender: TObject);
    procedure lst1ItemClick(const Sender: TCustomListBox;
      const Item: TListBoxItem);
  private
    { Private declarations }
    BTMethod : TBTMethod;
    TargetPaireNo : integer;                // 현재 지정된 페어링 디바이스 No
  public
    { Public declarations }
    FScanedDevices : TBluetoothDeviceList;
  end;

var
  Form1: TForm1;

implementation


{$R *.fmx}

uses
  Androidapi.JNI.Bluetooth,
  Androidapi.Helpers,
  Androidapi.JNI.GraphicsContentViewText;


procedure TForm1.Bluetooth1DiscoveryEnd(const Sender: TObject;
  const ADeviceList: TBluetoothDeviceList);
var
  i : Integer;
begin
  FScanedDevices := ADeviceList;

  for i := 0 to FScanedDevices.Count - 1 do
  begin
    lst1.Items.Add(FScanedDevices.Items[i].DeviceName);
  end;

  Layout_Searching.Visible := False;

end;

procedure TForm1.btn1Click(Sender: TObject);
var
  Adapter: JBluetoothAdapter;
begin
  //블루투스가 켜져있으면 주변 장치를 검색한다.
  if Bluetooth1.StateConnected = True then
  begin

    Bluetooth1.DiscoverDevices(10000);

    //여기에 10초동안 검색하면서 다른창 띄우기.
    Layout_Searching.Visible := True;
    //검색되는 동안 띄운 창을 없애는 부분은 DiscoveryEnd에 넣어야한다.
  end
  else
    ShowMessage('블루투스가 꺼져있습니다.');
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Layout_Searching.Visible := False;
  Layout_Searching.Align := TAlignLayout.Client;
end;

procedure TForm1.FormShow(Sender: TObject);
var
  Adapter: JBluetoothAdapter;
begin
  Bluetooth1.Enabled := True;

  //블루투스가 꺼져있으면 자동으로 블루투스 ON
  if Bluetooth1.StateConnected = False then
  begin
    Adapter := TJBluetoothAdapter.JavaClass.getDefaultAdapter;
    if Adapter.enable then
      //ShowMessage('Bluetooth를 활성화합니다.')
    else
      ShowMessage('사용할 수 없습니다.');
  end;

  BTMethod := TBTMethod.Create //BTconfig객체 생성

end;

procedure TForm1.lst1ItemClick(const Sender: TCustomListBox;
  const Item: TListBoxItem);
var
  i : Integer;
begin
  //검색된 장치를 누르면 바로 페어링
  Bluetooth1.Pair(FScanedDevices.Items[Item.Index]);

  //검색 리스트에서 누른 이름과 페어링 리스트의 이름과 비교하여 페어링 리스트 인덱스 얻음
  for i := 0 to Bluetooth1.PairedDevices.Count do
  begin
    if Item.Text = Bluetooth1.PairedDevices.Items[i].DeviceName then
      TargetPaireNo := i;
  end;

  //BTMethod에 블루투스 메니저정보 전달
  BTMethod.Setup(Bluetooth1.CurrentManager, Bluetooth1.PairedDevices, Bluetooth1.CurrentAdapter);


  //서비스에 시리얼 있는지 판별, 없으면 연결할수 없는 장치라고 안내.

  //한글한글

  //아니 인코딩 뭔데




end;

end.

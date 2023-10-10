unit formPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  IPPeerClient, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, REST.Response.Adapter,
  REST.Client, Data.Bind.Components, Data.Bind.ObjectScope, uFormat, REST.Types,
  cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxContainer,
  cxEdit, dxSkinsCore, dxSkinsDefaultPainters, cxTextEdit, cxMemo;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    Shape2: TShape;
    EditCEP: TEdit;
    btnGo: TButton;
    RESTClient1: TRESTClient;
    RESTRequest1: TRESTRequest;
    RESTResponse1: TRESTResponse;
    RESTResponseDataSetAdapter1: TRESTResponseDataSetAdapter;
    MemTable: TFDMemTable;
    cxMemo: TcxMemo;
    procedure btnGoClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.btnGoClick(Sender: TObject);
var
    cep: String;
begin
    //
    cep := SomenteNumero(EditCEP.Text);

    //Tamanho da string em cep
    if Length(cep) <> 8 then
    begin
        ShowMessage('CEP Invalido!');
        exit;
    end;

    //Executando requisição
     RESTRequest1.Resource := cep + '/json';
     RESTRequest1.Execute;

    //Verificando retorno 200 = sucesso
     if RESTRequest1.Response.StatusCode = 200 then
     begin
        //verificando se tem erro no retorno
        if RESTRequest1.Response.Content.IndexOf('erro') > 0 then
        begin
            ShowMessage('CEP não encontrado!');
        end
        else
        begin
          with MemTable do
          begin
              cxMemo.Lines.Clear;
              cxMemo.Lines.Add('Cep: ' + FieldByName('cep').AsString);
              cxMemo.Lines.Add('Rua: ' + FieldByName('logradouro').AsString);
              cxMemo.Lines.Add('Comple: ' + FieldByName('complemento').AsString);
              cxMemo.Lines.Add('Bairro: ' + FieldByName('bairro').AsString);
              cxMemo.Lines.Add('Cidade: ' + FieldByName('localidade').AsString);
              cxMemo.Lines.Add('UF: ' + FieldByName('uf').AsString);
              cxMemo.Lines.Add('IBGE: ' + FieldByName('ibge').AsString);
          end;
        end;
     end
     else
     begin
        ShowMessage('Erro ao consultar CEP.');
     end;

end;

end.

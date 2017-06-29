program SPG;

uses
  Forms,
  MAIN in 'MAIN.PAS' {MAINForm},
  VIEW in 'VIEW.pas' {VIEWFORM},
  ent in 'ENT.PAS',
  ndinfo in 'ndinfo.pas' {NODEINFO},
  barinfo in 'barinfo.pas' {binfo},
  generate in 'generate.pas',
  new in 'new.pas' {createwj},
  barres in 'barres.pas' {bres},
  model in 'model.pas',
  inq in 'inq.pas' {inqform},
  abt in 'abt.pas' {abtform},
  mdch in 'mdch.pas' {mdchform},
  load in 'load.pas' {loadform},
  comb in 'comb.pas' {combform},
  force in 'force.pas' {forceform},
  zxx in 'zxx.pas' {zxxform},
  xl in 'xl.pas' {xlform},
  js in 'JS.PAS' {jsForm},
  sc in 'sc.pas' {scform},
  input in 'input.pas' {inputForm},
  show3d in 'show3d.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TMAINForm, MAINForm);
  Application.CreateForm(TVIEWFORM, VIEWFORM);
  Application.Run;
end.
